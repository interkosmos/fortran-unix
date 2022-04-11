! serial.f90
!
! Reads from a serial port, and prints received characters to screen.
!
! Create a two pseudo-terminals with socat(1):
!
!   $ socat -d -d pty,raw,echo=0 pty,raw,echo=0
!   2021/11/20 21:37:31 socat[40743] N PTY is /dev/pts/5
!   2021/11/20 21:37:31 socat[40743] N PTY is /dev/pts/6
!   2021/11/20 21:37:31 socat[40743] N starting data transfer loop with FDs [5,5] and [7,7]
!
! Run the example program with one of the terminals as an argument:
!
!   $ ./serial /dev/pts/5
!
! Open the other terminal with minicom(1):
!
!   $ minicom -p /dev/pts/6
!
! The characters typed into minicom are printed by the program, until
! CTRL + C or a new line is sent.
!
! Author:  Philipp Engel
! Licence: ISC
module serial
    use :: unix
    implicit none
    private

    public :: serial_close
    public :: serial_open
    public :: serial_read
    public :: serial_set_attributes
    public :: serial_set_blocking
    public :: serial_write
contains
    integer function serial_close(fd) result(rc)
        !! Closes file descriptor.
        integer, intent(in) :: fd

        rc = c_close(fd)
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

        fd = c_open(trim(port_name) // c_null_char, flags, 0)
    end function serial_open

    integer(kind=i8) function serial_read(fd, a) result(n)
        !! Reads a single byte from file descriptor to `a`. Returns number of
        !! bytes read.
        integer,           intent(in)  :: fd
        character, target, intent(out) :: a

        n = c_read(fd, c_loc(a), int(1, kind=i8))
    end function serial_read

    integer function serial_set_attributes(fd, speed, byte_size, stop_bits, parity, timeout) result(rc)
        !! Sets terminal attributes.
        integer, intent(in) :: fd        !! File descriptor.
        integer, intent(in) :: speed     !! Baud rate (B4800, B9600, B19200, ...).
        integer, intent(in) :: byte_size !! Byte size (CS5, CS6, CS7, CS8).
        integer, intent(in) :: stop_bits !! Number of stop bits (0 for one, CSTOPB for two).
        integer, intent(in) :: parity    !! Parity (0 for none, PARENB for even, ior(PARENB, PARODD) for odd).
        integer, intent(in) :: timeout   !! Timeout in 1/10 seconds.
        type(c_termios)     :: tty

        ! Get current attributes.
        rc = c_tcgetattr(fd, tty)
        if (rc /= 0) return

        ! Set baud rate (I/O).
        rc = c_cfsetispeed(tty, speed)
        if (rc /= 0) return
        rc = c_cfsetospeed(tty, speed)
        if (rc /= 0) return

        ! Set byte size.
        tty%c_cflag = iand(tty%c_cflag, not(CSIZE))
        tty%c_cflag = ior(tty%c_cflag, byte_size)

        ! Set stop bits.
        tty%c_cflag = iand(tty%c_cflag, not(CSTOPB))
        tty%c_cflag = ior(tty%c_cflag, stop_bits)

        ! Set parity.
        tty%c_cflag = iand(tty%c_cflag, not(ior(PARENB, PARODD)))
        tty%c_cflag = ior(tty%c_cflag, parity)

        ! Disable break processing.
        tty%c_iflag = ior(tty%c_iflag, not(IGNBRK))

        ! Translate carriage-return to new-line.
        tty%c_iflag = iand(tty%c_iflag, ICRNL)

        ! No signaling chars, no echo, no canonical processing.
        tty%c_lflag = 0

        ! No remapping, no delays.
        tty%c_oflag = 0

        ! Read doesn't block.
        tty%c_cc(VMIN) = 0

        ! Read timeout in 1/10 seconds.
        tty%c_cc(VTIME) = timeout

        ! Turn XON/XOFF control off.
        tty%c_iflag = iand(tty%c_iflag, not(IXON + IXOFF + IXANY))

        ! Ignore modem controls, enable reading.
        tty%c_cflag = ior(tty%c_cflag, ior(CLOCAL, CREAD))

        ! Set attributes.
        rc = c_tcsetattr(fd, TCSANOW, tty)
    end function serial_set_attributes

    integer function serial_set_blocking(fd, is_blocking, timeout) result(rc)
        !! Set terminal read mode to blocking/non-blocking.
        integer, intent(in)           :: fd
        logical, intent(in)           :: is_blocking
        integer, intent(in), optional :: timeout
        type(c_termios)               :: tty

        rc = c_tcgetattr(fd, tty)
        if (rc /= 0) return

        if (is_blocking) then
            tty%c_cc(VMIN) = 1
        else
            tty%c_cc(VMIN) = 0
        end if

        if (present(timeout)) tty%c_cc(VTIME) = timeout

        rc = c_tcsetattr(fd, TCSANOW, tty)
    end function serial_set_blocking

    integer(kind=i8) function serial_write(fd, a) result(n)
        !! Writes single byte to terminal, returns number of bytes written.
        integer,           intent(in) :: fd
        character, target, intent(in) :: a

        n = c_write(fd, c_loc(a), int(1, kind=i8))
    end function serial_write
end module serial

program main
    use :: serial
    use :: unix
    implicit none
    character         :: a
    integer           :: fd, rc
    integer(kind=i8)  :: n
    character(len=72) :: path

    ! Get path to pseudo-terminal.
    if (command_argument_count() /= 1) &
        stop 'Error: Path to TTY is missing'
    call get_command_argument(1, path)

    ! Open serial connection to pseudo-terminal.
    fd = serial_open(path, O_RDWR)
    if (fd <= 0) stop 'Error: TTY could not be opened'

    ! Set terminal settings:
    ! 9600 baud, 8 bits per byte, 1 stop bit, no parity, 1 sec. timeout.
    rc = serial_set_attributes(fd, B9600, CS8, 0, 0, 10)

    ! Enable blocking access.
    rc = serial_set_blocking(fd, .true., 10)

    ! Read and print characters to screen until CTRL + C or new-line is
    ! received.
    do
        n = serial_read(fd, a)
        if (n == 0) exit
        write (*, '(a)', advance='no') a
        if (ichar(a) == 3 .or. a == new_line(a)) exit
    end do

    ! Close serial connection.
    rc = serial_close(fd)
end program main
