! irc.f90
!
! Author:  Philipp Engel
! Licence: ISC
module irc
    !! IRC connectivity module.
    use, intrinsic :: iso_fortran_env, only: i8 => int64, stderr => error_unit, stdout => output_unit
    use :: unix
    implicit none

    public :: irc_connect
    public :: irc_send
    public :: irc_send_message
contains
    integer function irc_connect(hostname, port) result(fd)
        !! Creates a socket connection to `hostname`:`port`. The file descriptor
        !! of the socket is returned on success, -1 on failure.
        !!
        !! The source code has been adapted from the example listed at
        !! [https://man.openbsd.org/getaddrinfo.3](https://man.openbsd.org/getaddrinfo.3).
        character(len=*), intent(in) :: hostname
        integer,          intent(in) :: port

        character(len=64), target :: host_str
        character(len=8),  target :: port_str

        integer     :: stat
        integer     :: sock_fd
        type(c_ptr) :: ptr

        type(c_addrinfo), target  :: hints
        type(c_addrinfo), target  :: res
        type(c_addrinfo), pointer :: next

        character(len=:), allocatable :: err_str

        fd = -1

        host_str = trim(hostname) // c_null_char
        write (port_str, '(i0, a)') port, c_null_char

        ! Initialise derived type.
        hints%ai_family   = AF_INET
        hints%ai_socktype = SOCK_STREAM
        hints%ai_flags    = AI_NUMERICSERV

        ptr  = c_loc(res)
        stat = c_getaddrinfo(node    = c_loc(host_str), &
                             service = c_loc(port_str), &
                             hints   = c_loc(hints), &
                             res     = ptr)

        ! Print error message of `c_getaddrinfo()`.
        if (stat /= 0) then
            ptr = c_gai_strerror(stat)
            call c_f_str_ptr(ptr, err_str)
            write (stderr, '("getaddrinfo(): ", a)') err_str
            return
        end if

        ! `c_getaddrinfo()` returns a list of address structures.
        ! Try each address until `c_connect()` is successful.
        call c_f_pointer(ptr, next)

        do while (associated(next))
            sock_fd = c_socket(next%ai_family, next%ai_socktype, next%ai_protocol)

            if (sock_fd == -1) then
                call c_f_pointer(next%ai_next, next)
                cycle
            end if

            if (sock_fd < -1) then
                call c_perror('socket()' // c_null_char)
                return
            end if

            stat = c_connect(sock_fd, next%ai_addr, next%ai_addrlen)

            if (stat == -1) then
                call c_perror('connect()' // c_null_char)
                stat = c_close(sock_fd)
                return
            end if

            exit
        end do

        if (.not. associated(next)) then
            stat = c_close(sock_fd)
            return
        end if

        fd = sock_fd
    end function irc_connect

    integer(kind=i8) function irc_send(socket, bytes) result(nbytes)
        !! Sends string to socket (raw).
        character(len=*), parameter :: CR_LF = char(13) // char(10)

        integer,          intent(in) :: socket
        character(len=*), intent(in) :: bytes

        character(len=:), allocatable, target :: buffer

        buffer = trim(bytes) // CR_LF
        nbytes = c_write(socket, c_loc(buffer), len(buffer, kind=c_size_t))
        write (*, '("*** ", a, " (", i0, " Bytes)")') trim(bytes), nbytes
    end function irc_send

    integer(kind=i8) function irc_send_message(socket, channel, message) result(nbytes)
        !! Sends string as IRC message (PRIVMSG) to channel.
        integer,          intent(in) :: socket
        character(len=*), intent(in) :: channel
        character(len=*), intent(in) :: message

        character(len=:), allocatable :: buffer

        buffer = 'PRIVMSG ' // trim(channel) // ' :' // trim(message)
        nbytes = irc_send(socket, buffer)
    end function irc_send_message
end module irc

program main
    !! Dumb IRC bot that connects to an IRC server, joins a channel, and sends a
    !! message each time someone mentions Fortran.
    !!
    !! You may want to change the following parameters to your liking:
    !!
    !! * `IRC_MSG`
    !! * `IRC_USERNAME`
    !! * `IRC_HOSTNAME`
    !! * `IRC_CHANNEL`
    !! * `IRC_PORT`
    use :: irc
    use :: unix
    implicit none

    character(len=*), parameter :: IRC_MSG      = 'FORTRAN: The Greatest of the Programming Languages!'
    character(len=*), parameter :: IRC_USERNAME = 'forbot'
    character(len=*), parameter :: IRC_HOSTNAME = 'irc.libera.chat'
    character(len=*), parameter :: IRC_CHANNEL  = '#bot-test'
    integer,          parameter :: IRC_PORT     = 6667

    character(len=512), target :: buffer       ! Received message.
    integer                    :: sock_fd      ! Socket file descriptor.
    integer(kind=i8)           :: nbytes       ! Bytes read/written.
    logical                    :: is_logged_in ! Send credentials.

    print '("<<< FORTRAN IRC BOT >>>")'
    print '("User:     ", a)',    trim(IRC_USERNAME)
    print '("Hostname: ", a)',    trim(IRC_HOSTNAME)
    print '("Port:     ", i0)',   IRC_PORT
    print '("Channel:  ", a, /)', trim(IRC_CHANNEL)

    ! Connect to IRC server.
    print '("*** Connecting to ", a, ":", i0)', trim(IRC_HOSTNAME), IRC_PORT

    sock_fd = irc_connect(IRC_HOSTNAME, IRC_PORT)

    if (sock_fd < 0) then
        write (stderr, '("Connection to server ", a, ":", i0, " failed")') trim(IRC_HOSTNAME), IRC_PORT
        stop
    end if

    ! Event loop.
    is_logged_in = .false.

    do
        ! Read from socket.
        nbytes = c_read(sock_fd, c_loc(buffer), len(buffer, kind=c_size_t))
        if (nbytes <= 0) exit

        ! Write buffer to standard output.
        write (*, '(a)', advance='no') buffer(1:nbytes)

        ! Check for IRC server `PING` and answer with `PONG` + payload.
        if (index(buffer(1:nbytes), 'PING') == 1) then
            nbytes = irc_send(sock_fd, 'PONG ' // trim(buffer(6:len_trim(buffer) - 2)))
        end if

        ! Log-in and join channel.
        if (.not. is_logged_in) then
            nbytes = irc_send(sock_fd, 'NICK ' // trim(IRC_USERNAME))
            nbytes = irc_send(sock_fd, 'USER ' // trim(IRC_USERNAME) // ' . . :' // trim(IRC_USERNAME))
            nbytes = irc_send(sock_fd, 'JOIN ' // trim(IRC_CHANNEL))
            is_logged_in = .true.
        end if

        ! Check for new channel message.
        if (index(buffer(1:nbytes), 'PRIVMSG ' // trim(IRC_CHANNEL) // ' :') > 0) then
            ! Check for 'Fortran' substring in received message and respond with
            ! sample message if found.
            if (index(string_lower(buffer(1:nbytes)), 'fortran') > 0) then
                nbytes = irc_send_message(sock_fd, IRC_CHANNEL, IRC_MSG)
            end if
        end if

        ! Clear buffer.
        buffer = ' '
    end do

    ! Disconnect from server.
    nbytes = irc_send(sock_fd, 'QUIT')

    ! Close connection.
    if (c_close(sock_fd) /= 0) then
        call c_perror('Error' // c_null_char)
        stop
    end if
contains
    pure elemental function string_lower(str) result(lower)
        !! Returns given string in lower case.
        character(len=*), intent(in) :: str   !! String to convert.
        character(len=len(str))      :: lower !! Result.

        character :: a
        integer   :: i

        do i = 1, len(str)
            a = str(i:i)
            if (a >= 'A' .and. a <= 'Z') a = achar(iachar(a) + 32)
            lower(i:i) = a
        end do
    end function string_lower
end program main
