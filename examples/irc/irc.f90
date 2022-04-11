! irc.f90
!
! Dumb IRC bot that connects to an IRC server, joins a channel, and sends a
! message each time someone mentions Fortran.
!
! You may want to change the following parameters to your liking:
!
!   IRC_MSG
!   IRC_USERNAME
!   IRC_HOSTNAME
!   IRC_CHANNEL
!   IRC_PORT
!
! Author:  Philipp Engel
! Licence: ISC
module irc
    use, intrinsic :: iso_c_binding
    use, intrinsic :: iso_fortran_env, only: stderr => error_unit, stdout => output_unit
    use :: unix
    implicit none
    private

    public :: irc_connect
    public :: irc_send
    public :: irc_send_message
contains
    integer function irc_connect(hostname, port)
        !! Creates a socket connection to `hostname`:`port`. The file descriptor
        !! of the socket is returned on success, -1 on failure.
        !!
        !! The source code has been adapted from the example listed at:
        !!     https://man.openbsd.org/getaddrinfo.3
        character(len=*), intent(in)  :: hostname
        integer,          intent(in)  :: port
        character(len=63), target     :: host_str
        character(len=7),  target     :: port_str
        character(len=:), allocatable :: err_str
        integer                       :: rc
        integer                       :: sock_fd
        type(c_addrinfo),  target     :: hints
        type(c_addrinfo),  target     :: res
        type(c_addrinfo),  pointer    :: next
        type(c_ptr)                   :: ptr

        irc_connect = -1

        write (host_str, '(a, a)') trim(hostname), c_null_char
        write (port_str, '(i0, a)') port, c_null_char

        ! Initialise derived type manually.
        hints%ai_family    = AF_INET
        hints%ai_socktype  = SOCK_STREAM
        hints%ai_flags     = AI_NUMERICSERV
        hints%ai_protocol  = 0
        hints%ai_addrlen   = 0_i8
        hints%ai_canonname = c_null_ptr
        hints%ai_addr      = c_null_ptr
        hints%ai_next      = c_null_ptr

        ptr = c_loc(res)
        rc  = c_getaddrinfo(node    = c_loc(host_str), &
                            service = c_loc(port_str), &
                            hints   = c_loc(hints), &
                            res     = ptr)

        ! Print error message of `c_getaddrinfo()`.
        if (rc /= 0) then
            ptr = c_gai_strerror(rc)
            call c_f_str_ptr(ptr, err_str)
            if (allocated(err_str)) &
                write (stderr, '(2a)') 'getaddrinfo(): ', err_str
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

            if (c_connect(sock_fd, next%ai_addr, next%ai_addrlen) == -1) then
                call c_perror('connect()' // c_null_char)
                rc = c_close(sock_fd)
                return
            end if

            exit
        end do

        if (.not. associated(next)) then
            rc = c_close(sock_fd)
            return
        end if

        irc_connect = sock_fd
    end function irc_connect

    integer(kind=i8) function irc_send(socket, str)
        !! Sends string to socket (raw).
        character(len=2), parameter           :: CR_LF = char(13) // char(10)
        integer,          intent(in)          :: socket
        character(len=*), intent(in)          :: str
        character(len=:), allocatable, target :: str_esc

        str_esc  = trim(str) // CR_LF
        irc_send = c_write(socket, c_loc(str_esc), len(str_esc, kind=i8))

        write (*, '("*** ", a, " (", i0, " Bytes)")') trim(str), irc_send
    end function irc_send

    integer(kind=i8) function irc_send_message(socket, channel, str)
        !! Sends string as IRC message (PRIVMSG) to channel.
        integer,          intent(in)  :: socket
        character(len=*), intent(in)  :: channel
        character(len=*), intent(in)  :: str
        character(len=:), allocatable :: message

        message = 'PRIVMSG ' // trim(channel) // ' :' // trim(str)
        irc_send_message = irc_send(socket, message)
    end function irc_send_message
end module irc

program main
    use, intrinsic :: iso_c_binding
    use, intrinsic :: iso_fortran_env, only: stderr => error_unit
    use :: irc
    use :: unix
    implicit none
    character(len=*), parameter :: IRC_MSG      = 'FORTRAN: The Greatest of the Programming Languages!'
    character(len=*), parameter :: IRC_USERNAME = 'forbot'
    character(len=*), parameter :: IRC_HOSTNAME = 'irc.libera.chat'
    character(len=*), parameter :: IRC_CHANNEL  = '#bot-test'
    integer,          parameter :: IRC_PORT     = 6667

    character(len=512), target :: buffer                 ! Received message.
    integer(kind=i8)           :: n                      ! Bytes read/written.
    integer(kind=i8)           :: rc                     ! Return code.
    integer                    :: sock_fd                ! Socket file descriptor.
    logical                    :: is_logged_in = .false. ! Send credentials.

    print '(a)', '<<< FORTRAN IRC BOT >>>'
    print '("User:     ", a)',    trim(IRC_USERNAME)
    print '("Hostname: ", a)',    trim(IRC_HOSTNAME)
    print '("Port:     ", i0)',   IRC_PORT
    print '("Channel:  ", a, /)', trim(IRC_CHANNEL)

    ! Connect to IRC server.
    print '(3a, i0, a)', '*** Connecting to ', trim(IRC_HOSTNAME), ':', IRC_PORT, ' ...'

    sock_fd = irc_connect(IRC_HOSTNAME, IRC_PORT)

    if (sock_fd < 0) then
        write (stderr, '(3a, i0, a)') 'Connection to server ', trim(IRC_HOSTNAME), &
                                      ':', IRC_PORT, ' failed'
        stop
    end if

    ! Event loop.
    do
        ! Read from socket.
        n = c_read(sock_fd, c_loc(buffer), len(buffer, kind=i8))
        if (n <= 0) exit

        ! Write buffer to standard output.
        write (*, '(a)', advance='no') buffer(1:n)

        ! Check for IRC server `PING` and answer with `PONG` + payload.
        if (index(buffer(1:n), 'PING') == 1) &
            rc = irc_send(sock_fd, 'PONG ' // trim(buffer(6:len_trim(buffer) - 2)))

        ! Log-in and join channel.
        if (.not. is_logged_in) then
            rc = irc_send(sock_fd, 'NICK ' // trim(IRC_USERNAME))
            rc = irc_send(sock_fd, 'USER ' // trim(IRC_USERNAME) // ' . . :' // trim(IRC_USERNAME))
            rc = irc_send(sock_fd, 'JOIN ' // trim(IRC_CHANNEL))
            is_logged_in = .true.
        end if

        ! Check for new channel message.
        if (index(buffer(1:n), 'PRIVMSG ' // trim(IRC_CHANNEL) // ' :') > 0) then
            ! Check for 'FORTRAN', 'fortran', and 'Fortran' substring in received
            ! message and respond with sample message if found.
            if (index(buffer(1:n), 'FORTRAN') > 0 .or. &
                index(buffer(1:n), 'fortran') > 0 .or. &
                index(buffer(1:n), 'Fortran') > 0) then
                rc = irc_send_message(sock_fd, IRC_CHANNEL, IRC_MSG)
            end if
        end if

        ! Clear buffer.
        buffer = ' '
    end do

    ! Disconnect from server.
    rc = irc_send(sock_fd, 'QUIT')

    ! Close connection.
    if (c_close(sock_fd) /= 0) then
        call c_perror('Error' // c_null_char)
        stop
    end if
end program main
