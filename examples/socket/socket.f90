! socket.f90
!
! Example program that connects to a TCP server using BSD sockets. On FreeBSD,
! start a local TCP server on port 8888 with netcat:
!
!   $ nc -l 8888
!
! On Linux, run instead:
!
!   $ nc -l -p 8888
!
! Then, execute the example:
!
!   $ ./socket
!
! Enter 'PING' in netcat to receive a 'PONG' from the Fortran program.
!
! Author:  Philipp Engel
! Licence: ISC
program main
    use, intrinsic :: iso_c_binding
    use, intrinsic :: iso_fortran_env, only: stderr => error_unit, stdout => output_unit
    use :: unix
    implicit none
    character(len=*), parameter :: HOST = '127.0.0.1'   ! IP address or FQDN.
    integer,          parameter :: PORT = 8888          ! Port number.

    character(len=512), target :: buffer                ! Input buffer.
    integer                    :: sock_fd               ! Socket file descriptor.
    integer(kind=i8)           :: n, rc

    ! Connect to TCP server.
    write (stdout, '(3a, i0, a)') 'Connecting to ', trim(HOST), ':', PORT, ' ...'

    sock_fd = socket_connect(HOST, PORT)

    if (sock_fd < 0) then
        write (stderr, '(3a, i0, a)') 'Connection to server ', trim(HOST), &
                                      ':', PORT, ' failed'
        call c_perror('socket_connect()' // c_null_char)
        stop
    end if

    ! Write to socket.
    rc = socket_send(sock_fd, 'PING')

    do
        ! Read from socket.
        n = c_read(sock_fd, c_loc(buffer), len(buffer, kind=i8))

        ! Exit on error.
        if (n <= 0) exit

        ! Print input buffer.
        write (stdout, '("<<< ", a)', advance='no') buffer(1:n)

        ! Answer to `PING` with `PONG`.
        if (index(buffer, 'PING') > 0) &
            rc = socket_send(sock_fd, 'PONG')

        buffer = ' '
    end do

    ! Close connection.
    if (c_close(sock_fd) < 0) &
        call c_perror('close()' // c_null_char)
contains
    integer function socket_connect(host, port)
        !! Creates a socket connection to `host`:`port`. The file descriptor
        !! of the socket is returned on success, the error code on failure.
        !!
        !! The source code has been adapted from the example listed at:
        !!
        !!     https://man.openbsd.org/getaddrinfo.3
        !!
        !! Make sure the derived type `hints` is initialised properly.
        character(len=*), intent(in)  :: host
        integer,          intent(in)  :: port
        character(len=63), target     :: host_str
        character(len=7),  target     :: port_str
        character(len=:), allocatable :: err_str
        integer                       :: rc
        integer                       :: sock_fd
        type(c_addrinfo),  pointer    :: next
        type(c_addrinfo),  target     :: hints
        type(c_addrinfo),  target     :: res
        type(c_ptr)                   :: ptr

        socket_connect = -1

        write (host_str, '(a, a)') trim(HOST), c_null_char
        write (port_str, '(i0, a)') PORT, c_null_char

        ! Initialise derived type manually.
        hints%ai_family    = AF_INET
        hints%ai_socktype  = SOCK_STREAM
        hints%ai_flags     = 0
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
            if (allocated(err_str)) write (stderr, '(2a)') 'getaddrinfo() failed: ', err_str
            return
        end if

        ! `c_getaddrinfo()` returns a list of address structures.
        ! Try each address until `c_connect()` is successful.
        call c_f_pointer(ptr, next)

        do while (associated(next))
            sock_fd = c_socket(next%ai_family, next%ai_socktype, next%ai_protocol)

            if (sock_fd == -1) then
                ! Try next address.
                call c_f_pointer(next%ai_next, next)
                cycle
            end if

            if (sock_fd < -1) return

            if (c_connect(sock_fd, next%ai_addr, next%ai_addrlen) == -1) then
                rc = c_close(sock_fd)
                return
            end if

            exit
        end do

        if (.not. associated(next)) then
            rc = c_close(sock_fd)
            return
        end if

        socket_connect = sock_fd
    end function socket_connect

    integer(kind=i8) function socket_send(socket, str)
        !! Writes given string to socket.
        character(len=2), parameter           :: CR_LF = char(13) // char(10)
        integer,          intent(in)          :: socket
        character(len=*), intent(in)          :: str
        character(len=:), allocatable, target :: str_esc

        str_esc     = trim(str) // CR_LF
        socket_send = c_write(socket, c_loc(str_esc), len(str_esc, kind=i8))

        write (stdout, '(">>> ", a, " (", i0, " Byte)")') trim(str), socket_send
    end function socket_send
end program main
