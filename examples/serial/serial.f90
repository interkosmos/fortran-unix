! serial.f90
!
! Author:  Philipp Engel
! Licence: ISC
module serial
    !! Serial port access module.
    use, intrinsic :: iso_fortran_env, only: i8 => int64
    use :: unix
    implicit none

    public :: serial_close
    public :: serial_open
    public :: serial_read
    public :: serial_set_attributes
    public :: serial_set_blocking
    public :: serial_write
contains
    integer function serial_close(fd) result(stat)
        !! Closes file descriptor.
        integer, intent(in) :: fd

        stat = c_close(fd)
    end function serial_close

    integer function serial_open(port_name, access_mode) result(fd)
        !! Open serial connection to given port. `access_mode` has to be either
        !! `O_RDONLY` (read-only), `O_WRONLY` (write-only), or `O_RDWR`
        !! (read-write).
        character(len=*), intent(in) :: port_name
        integer,          intent(in) :: access_mode
        integer                      :: flags

        flags = ior(O_NOCTTY, O_SYNC)
        flags = ior(flags, access_mode)

        fd = c_open(trim(port_name) // c_null_char, flags, 0_c_mode_t)
    end function serial_open

    integer(kind=i8) function serial_read(fd, a) result(nbytes)
        !! Reads a single byte from file descriptor to `a`. Returns number of
        !! bytes read.
        integer,           intent(in)  :: fd
        character, target, intent(out) :: a

        nbytes = c_read(fd, c_loc(a), 1_c_size_t)
    end function serial_read

    integer function serial_set_attributes(fd, speed, byte_size, stop_bits, parity, timeout) result(stat)
        !! Sets terminal attributes.
        integer, intent(in) :: fd        !! File descriptor.
        integer, intent(in) :: speed     !! Baud rate (`B4800`, `B9600`, `B19200`, ...).
        integer, intent(in) :: byte_size !! Byte size (`CS5`, `CS6`, `CS7`, `CS8`).
        integer, intent(in) :: stop_bits !! Number of stop bits (0 for one, `CSTOPB`  for two).
        integer, intent(in) :: parity    !! Parity (0 for none, `PARENB` for even, `ior(PARENB, PARODD)` for odd).
        integer, intent(in) :: timeout   !! Timeout in 1/10 seconds.

        integer(kind=c_tcflag_t) :: c_cflag
        integer(kind=c_tcflag_t) :: c_iflag
        integer(kind=c_tcflag_t) :: c_lflag
        integer(kind=c_tcflag_t) :: c_oflag

        type(c_termios) :: tty

        ! Get current attributes.
        stat = c_tcgetattr(fd, tty)
        if (stat /= 0) return

        ! Set baud rate (I/O).
        stat = c_cfsetispeed(tty, speed); if (stat /= 0) return
        stat = c_cfsetospeed(tty, speed); if (stat /= 0) return

        c_cflag = int(c_uint_to_int(tty%c_cflag), kind=c_tcflag_t)
        c_iflag = int(c_uint_to_int(tty%c_iflag), kind=c_tcflag_t)
        c_oflag = int(c_uint_to_int(tty%c_oflag), kind=c_tcflag_t)
        c_lflag = int(c_uint_to_int(tty%c_lflag), kind=c_tcflag_t)

        c_cflag = ior (c_cflag, ior(CLOCAL, CREAD))        ! Ignore modem controls, enable reading.
        c_cflag = iand(c_cflag, not(CSIZE))                ! Unset byte size.
        c_cflag = ior (c_cflag, byte_size)                 ! Set byte size.
        c_cflag = iand(c_cflag, not(CSTOPB))               ! Unset stop bits.
        c_cflag = ior (c_cflag, stop_bits)                 ! Set stop bits.
        c_cflag = iand(c_cflag, not(ior(PARENB, PARODD)))  ! Unset parity
        c_cflag = ior (c_cflag, parity)                    ! Set parity

        c_iflag = iand(c_iflag, not(IGNBRK))               ! Disable break processing.
        c_iflag = ior (c_iflag, ICRNL)                     ! Translate carriage-return to new-line.
        c_iflag = iand(c_iflag, not(IXON + IXOFF + IXANY)) ! Turn XON/XOFF control off.

        c_oflag = 0 ! No remapping, no delays.
        c_lflag = 0 ! No signaling chars, no echo, no canonical processing.

        tty%c_cflag = c_cflag
        tty%c_iflag = c_iflag
        tty%c_oflag = c_oflag
        tty%c_lflag = c_lflag

        tty%c_cc(VMIN)  = 0                         ! Read doesn't block.
        tty%c_cc(VTIME) = int(timeout, kind=c_cc_t) ! Read timeout in 1/10 seconds.

        ! Set attributes.
        stat = c_tcsetattr(fd, TCSANOW, tty)
    end function serial_set_attributes

    integer function serial_set_blocking(fd, is_blocking, timeout) result(stat)
        !! Set terminal read mode to blocking/non-blocking.
        integer, intent(in)           :: fd
        logical, intent(in)           :: is_blocking
        integer, intent(in), optional :: timeout

        type(c_termios) :: tty

        stat = c_tcgetattr(fd, tty)
        if (stat /= 0) return

        if (is_blocking) then
            tty%c_cc(VMIN) = 1
        else
            tty%c_cc(VMIN) = 0

            if (present(timeout)) then
                tty%c_cc(VTIME) = int(timeout, kind=c_cc_t)
            end if
        end if

        stat = c_tcsetattr(fd, TCSANOW, tty)
    end function serial_set_blocking

    integer(kind=i8) function serial_write(fd, a) result(nbytes)
        !! Writes single byte to terminal, returns number of bytes written.
        integer,           intent(in) :: fd
        character, target, intent(in) :: a

        nbytes = c_write(fd, c_loc(a), 1_c_size_t)
    end function serial_write
end module serial

program main
    !! Reads from a serial port, and prints received characters to screen.
    !! Create two pseudo-terminals with socat(1):
    !!
    !! ```
    !! $ socat -d -d pty,raw,echo=0 pty,raw,echo=0
    !! 2021/11/20 21:37:31 socat[40743] N PTY is /dev/pts/5
    !! 2021/11/20 21:37:31 socat[40743] N PTY is /dev/pts/6
    !! 2021/11/20 21:37:31 socat[40743] N starting data transfer loop with FDs [5,5] and [7,7]
    !! ```
    !!
    !! Run the example program with one of the terminals as an argument:
    !!
    !! ```
    !! $ ./serial /dev/pts/5
    !! ```
    !!
    !! Open the other terminal with minicom(1):
    !!
    !! ```
    !! $ minicom -p /dev/pts/6
    !! ```
    !!
    !! The characters typed into minicom are printed by the program, until
    !! `CTRL` + `C` or a new line is sent.
    use :: serial
    use :: unix
    implicit none

    character         :: a
    integer           :: fd, stat
    integer(kind=i8)  :: nbytes
    character(len=72) :: path

    ! Get path to pseudo-terminal.
    if (command_argument_count() /= 1) then
        stop 'Error: Path to TTY is missing'
    end if

    call get_command_argument(1, path)

    ! Open serial connection to pseudo-terminal.
    fd = serial_open(path, O_RDWR)
    if (fd <= 0) stop 'Error: Failed to open TTY'

    ! Set terminal settings:
    ! 9600 baud, 8 bits per byte, 1 stop bit, no parity, 1 sec. timeout.
    stat = serial_set_attributes(fd, B9600, CS8, 0, 0, 10)

    ! Enable blocking access.
    stat = serial_set_blocking(fd, .true., 10)

    ! Read and print characters to screen until CTRL + C or new-line is
    ! received.
    do
        nbytes = serial_read(fd, a)
        if (nbytes == 0) exit
        write (*, '(a)', advance='no') a
        if (iachar(a) == 3 .or. a == new_line(a)) exit
    end do

    ! Close serial connection.
    stat = serial_close(fd)
end program main
