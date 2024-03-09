! socket.f90
!
! Author:  Philipp Engel
! Licence: ISC
program main
    !! Example program that connects to a TCP server using BSD sockets. On
    !! FreeBSD, start a local TCP server on port 8888 with netcat:
    !!
    !! ```
    !! $ nc -l 8888
    !! ```
    !!
    !! On Linux, run instead:
    !!
    !! ```
    !! $ nc -l -p 8888
    !! ```
    !!
    !! Then, execute the example:
    !!
    !! ```
    !! $ ./socket
    !! ```
    !!
    !! Enter 'PING' in netcat to receive a 'PONG' from the Fortran program.
    use, intrinsic :: iso_fortran_env, only: i8 => int64, stderr => error_unit, stdout => output_unit
    use :: unix
    implicit none

    character(len=*), parameter :: HOST = '127.0.0.1' ! IP address or FQDN.
    integer,          parameter :: PORT = 8888        ! Port number.

    character(len=512), target :: buffer  ! Input buffer.
    integer                    :: sock_fd ! Socket file descriptor.
    integer                    :: stat
    integer(kind=i8)           :: nbytes

    ! Connect to TCP server.
    write (stdout, '("Connecting to ", a, ":", i0, " ...")') HOST, PORT
    sock_fd = socket_connect(HOST, PORT)

    if (sock_fd < 0) then
        write (stderr, '("Connection to server ", a, ":", i0, " failed")') HOST, PORT
        call c_perror('socket_connect()' // c_null_char)
        stop
    end if

    ! Write to socket.
    nbytes = socket_send(sock_fd, 'PING')

    do
        ! Read from socket.
        buffer = ' '
        nbytes = c_read(sock_fd, c_loc(buffer), len(buffer, kind=i8))

        ! Exit on error.
        if (nbytes <= 0) exit

        ! Print input buffer.
        write (stdout, '("<<< ", a)', advance='no') buffer(1:nbytes)

        ! Answer to `PING` with `PONG`.
        if (index(buffer, 'PING') > 0) then
            nbytes = socket_send(sock_fd, 'PONG')
        end if
    end do

    ! Close connection.
    stat = c_close(sock_fd)
    if (stat < 0) call c_perror('close()' // c_null_char)
contains
    integer function socket_connect(host, port) result(fd)
        !! Creates a socket connection to `host`:`port`. The file descriptor
        !! of the socket is returned on success, the error code on failure.
        !!
        !! The source code has been adapted from the example listed at
        !! [https://man.openbsd.org/getaddrinfo.3](https://man.openbsd.org/getaddrinfo.3).
        character(len=*), intent(in)  :: host
        integer,          intent(in)  :: port

        character(len=64), target :: host_str
        character(len=8),  target :: port_str

        type(c_addrinfo), pointer :: next
        type(c_addrinfo), target  :: hints
        type(c_addrinfo), target  :: res

        character(len=:), allocatable :: err_str
        integer                       :: stat
        integer                       :: sock_fd
        type(c_ptr)                   :: ptr

        fd = -1

        host_str = trim(host) // c_null_char
        write (port_str, '(i0, a)') port, c_null_char

        ! Initialise derived type manually.
        hints%ai_family   = AF_INET
        hints%ai_socktype = SOCK_STREAM

        ptr  = c_loc(res)
        stat = c_getaddrinfo(node    = c_loc(host_str), &
                             service = c_loc(port_str), &
                             hints   = c_loc(hints), &
                             res     = ptr)

        ! Print error message of `c_getaddrinfo()`.
        if (stat /= 0) then
            ptr = c_gai_strerror(stat)
            call c_f_str_ptr(ptr, err_str)
            write (stderr, '("getaddrinfo() failed: ", a)') err_str
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

            stat = c_connect(sock_fd, next%ai_addr, next%ai_addrlen)

            if (stat == -1) then
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
    end function socket_connect

    integer(kind=i8) function socket_send(socket, str) result(nbytes)
        !! Writes given string to socket.
        character(len=*), parameter :: CR_LF = char(13) // char(10)

        integer,          intent(in) :: socket
        character(len=*), intent(in) :: str

        character(len=:), allocatable, target :: buffer

        buffer = trim(str) // CR_LF
        nbytes = c_write(socket, c_loc(buffer), len(buffer, kind=c_size_t))
        write (stdout, '(">>> ", a, " (", i0, " Byte)")') trim(str), nbytes
    end function socket_send
end program main
