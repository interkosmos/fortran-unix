! unix_termios.f90
module unix_termios
    use, intrinsic :: iso_c_binding
    use :: unix_types
    implicit none
    private

#if defined (__linux__)

    integer, parameter, public :: c_cc_t     = c_unsigned_int
    integer, parameter, public :: c_speed_t  = c_unsigned_int
    integer, parameter, public :: c_tcflag_t = c_unsigned_int

    integer, parameter, public :: NCCS = 32

    type, bind(c), public :: c_termios
        integer(kind=c_tcflag_t) :: c_iflag
        integer(kind=c_tcflag_t) :: c_oflag
        integer(kind=c_tcflag_t) :: c_cflag
        integer(kind=c_tcflag_t) :: c_lflag
        integer(kind=c_cc_t)     :: c_line
        integer(kind=c_cc_t)     :: c_cc(0:NCCS - 1)
        integer(kind=c_speed_t)  :: c_ispeed
        integer(kind=c_speed_t)  :: c_ospeed
    end type c_termios

    integer, parameter, public :: VINTR    = 0
    integer, parameter, public :: VQUIT    = 1
    integer, parameter, public :: VERASE   = 2
    integer, parameter, public :: VKILL    = 3
    integer, parameter, public :: VEOF     = 4
    integer, parameter, public :: VTIME    = 5
    integer, parameter, public :: VMIN     = 6
    integer, parameter, public :: VSWTC    = 7
    integer, parameter, public :: VSTART   = 8
    integer, parameter, public :: VSTOP    = 9
    integer, parameter, public :: VSUSP    = 10
    integer, parameter, public :: VEOL     = 11
    integer, parameter, public :: VREPRINT = 12
    integer, parameter, public :: VDISCARD = 13
    integer, parameter, public :: VWERASE  = 14
    integer, parameter, public :: VLNEXT   = 15
    integer, parameter, public :: VEOL2    = 16

    integer, parameter, public :: IGNBRK = int(o'000001')
    integer, parameter, public :: BRKINT = int(o'000002')
    integer, parameter, public :: IGNPAR = int(o'000004')
    integer, parameter, public :: PARMRK = int(o'000010')
    integer, parameter, public :: INPCK  = int(o'000020')
    integer, parameter, public :: ISTRIP = int(o'000040')
    integer, parameter, public :: INLCR  = int(o'000100')
    integer, parameter, public :: IGNCR  = int(o'000200')
    integer, parameter, public :: ICRNL  = int(o'000400')
    integer, parameter, public :: IUCLC  = int(o'001000')
    integer, parameter, public :: IXON   = int(o'002000')
    integer, parameter, public :: IXANY  = int(o'004000')
    integer, parameter, public :: IXOFF  = int(o'010000')
    integer, parameter, public :: IMAXBEL= int(o'020000')
    integer, parameter, public :: IUTF8  = int(o'040000')

    integer, parameter, public :: OPOST  = int(o'000001')
    integer, parameter, public :: OLCUC  = int(o'000002')
    integer, parameter, public :: ONLCR  = int(o'000004')
    integer, parameter, public :: OCRNL  = int(o'000010')
    integer, parameter, public :: ONOCR  = int(o'000020')
    integer, parameter, public :: ONLRET = int(o'000040')
    integer, parameter, public :: OFILL  = int(o'000100')
    integer, parameter, public :: OFDEL  = int(o'000200')

    integer, parameter, public :: VTDLY  = int(o'040000')
    integer, parameter, public :: VT0    = int(o'000000')
    integer, parameter, public :: VT1    = int(o'040000')

    integer, parameter, public :: CSIZE  = int(o'000060')
    integer, parameter, public :: CS5    = int(o'000000')
    integer, parameter, public :: CS6    = int(o'000020')
    integer, parameter, public :: CS7    = int(o'000040')
    integer, parameter, public :: CS8    = int(o'000060')
    integer, parameter, public :: CSTOPB = int(o'000100')
    integer, parameter, public :: CREAD  = int(o'000200')
    integer, parameter, public :: PARENB = int(o'000400')
    integer, parameter, public :: PARODD = int(o'001000')
    integer, parameter, public :: HUPCL  = int(o'002000')
    integer, parameter, public :: CLOCAL = int(o'004000')

    integer, parameter, public :: ISIG   = int(o'000001')
    integer, parameter, public :: ICANON = int(o'000002')
    integer, parameter, public :: ECHO   = int(o'000010')
    integer, parameter, public :: ECHOE  = int(o'000020')
    integer, parameter, public :: ECHOK  = int(o'000040')
    integer, parameter, public :: ECHONL = int(o'000100')
    integer, parameter, public :: NOFLSH = int(o'000200')
    integer, parameter, public :: TOSTOP = int(o'000400')
    integer, parameter, public :: IEXTEN = int(o'100000')

    integer, parameter, public :: TCOOFF    = 0
    integer, parameter, public :: TCOON     = 1
    integer, parameter, public :: TCIOFF    = 2
    integer, parameter, public :: TCION     = 3
    integer, parameter, public :: TCIFLUSH  = 0
    integer, parameter, public :: TCOFLUSH  = 1
    integer, parameter, public :: TCIOFLUSH = 2
    integer, parameter, public :: TCSANOW   = 0
    integer, parameter, public :: TCSADRAIN = 1
    integer, parameter, public :: TCSAFLUSH = 2

    integer, parameter, public :: B0       = int(o'000000')
    integer, parameter, public :: B50      = int(o'000001')
    integer, parameter, public :: B75      = int(o'000002')
    integer, parameter, public :: B110     = int(o'000003')
    integer, parameter, public :: B134     = int(o'000004')
    integer, parameter, public :: B150     = int(o'000005')
    integer, parameter, public :: B200     = int(o'000006')
    integer, parameter, public :: B300     = int(o'000007')
    integer, parameter, public :: B600     = int(o'000010')
    integer, parameter, public :: B1200    = int(o'000011')
    integer, parameter, public :: B1800    = int(o'000012')
    integer, parameter, public :: B2400    = int(o'000013')
    integer, parameter, public :: B4800    = int(o'000014')
    integer, parameter, public :: B9600    = int(o'000015')
    integer, parameter, public :: B19200   = int(o'000016')
    integer, parameter, public :: B38400   = int(o'000017')
    integer, parameter, public :: B57600   = int(o'010001')
    integer, parameter, public :: B115200  = int(o'010002')
    integer, parameter, public :: B230400  = int(o'010003')
    integer, parameter, public :: B460800  = int(o'010004')
    integer, parameter, public :: B500000  = int(o'010005')
    integer, parameter, public :: B576000  = int(o'010006')
    integer, parameter, public :: B921600  = int(o'010007')
    integer, parameter, public :: B1000000 = int(o'010010')
    integer, parameter, public :: B1152000 = int(o'010011')
    integer, parameter, public :: B1500000 = int(o'010012')
    integer, parameter, public :: B2000000 = int(o'010013')
    integer, parameter, public :: B2500000 = int(o'010014')
    integer, parameter, public :: B3000000 = int(o'010015')
    integer, parameter, public :: B3500000 = int(o'010016')
    integer, parameter, public :: B4000000 = int(o'010017')

#elif defined (__FreeBSD__)

    integer, parameter, public :: c_cc_t     = c_unsigned_int
    integer, parameter, public :: c_speed_t  = c_unsigned_int
    integer, parameter, public :: c_tcflag_t = c_unsigned_int

    integer, parameter, public :: NCCS = 20

    type, bind(c), public :: c_termios
        integer(kind=c_tcflag_t) :: c_iflag
        integer(kind=c_tcflag_t) :: c_oflag
        integer(kind=c_tcflag_t) :: c_cflag
        integer(kind=c_tcflag_t) :: c_lflag
        integer(kind=c_cc_t  )   :: c_cc(0:NCCS - 1)
        integer(kind=c_speed_t)  :: c_ispeed
        integer(kind=c_speed_t)  :: c_ospeed
    end type c_termios

    integer, parameter, public :: VEOF     = 0  ! ICANON
    integer, parameter, public :: VEOL     = 1  ! ICANON
    integer, parameter, public :: VEOL2    = 2  ! ICANON together with IEXTEN
    integer, parameter, public :: VERASE   = 3  ! ICANON
    integer, parameter, public :: VWERASE  = 4  ! ICANON together with IEXTEN
    integer, parameter, public :: VKILL    = 5  ! ICANON
    integer, parameter, public :: VREPRINT = 6  ! ICANON together with IEXTEN
    integer, parameter, public :: VERASE2  = 7  ! ICANON
    integer, parameter, public :: VINTR    = 8  ! ISIG
    integer, parameter, public :: VQUIT    = 9  ! ISIG
    integer, parameter, public :: VSUSP    = 10 ! ISIG
    integer, parameter, public :: VDSUSP   = 11 ! ISIG together with IEXTEN
    integer, parameter, public :: VSTART   = 12 ! IXON, IXOFF
    integer, parameter, public :: VSTOP    = 13 ! IXON, IXOFF
    integer, parameter, public :: VLNEXT   = 14 ! IEXTEN
    integer, parameter, public :: VDISCARD = 15 ! IEXTEN
    integer, parameter, public :: VMIN     = 16 ! !ICANON
    integer, parameter, public :: VTIME    = 17 ! !ICANON
    integer, parameter, public :: VSTATUS  = 18 ! ICANON together with IEXTEN

    ! Commands passed to tcsetattr() for setting the termios structure.
    integer, parameter, public :: TCSANOW   = 0          ! make change immediate
    integer, parameter, public :: TCSADRAIN = 1          ! drain output, then change
    integer, parameter, public :: TCSAFLUSH = 2          ! drain output, flush input
    integer, parameter, public :: TCSASOFT  = int(z'10') ! flag - don't alter h.w. state

    integer, parameter, public :: TCIFLUSH  = 1
    integer, parameter, public :: TCOFLUSH  = 2
    integer, parameter, public :: TCIOFLUSH = 3
    integer, parameter, public :: TCOOFF    = 1
    integer, parameter, public :: TCOON     = 2
    integer, parameter, public :: TCIOFF    = 3
    integer, parameter, public :: TCION     = 4

    ! Input flags (software input processing).
    integer, parameter, public :: IGNBRK  = int(z'000001') ! ignore BREAK condition
    integer, parameter, public :: BRKINT  = int(z'000002') ! map BREAK to SIGINTR
    integer, parameter, public :: IGNPAR  = int(z'000004') ! ignore (discard) parity errors
    integer, parameter, public :: PARMRK  = int(z'000008') ! mark parity and framing errors
    integer, parameter, public :: INPCK   = int(z'000010') ! enable checking of parity errors
    integer, parameter, public :: ISTRIP  = int(z'000020') ! strip 8th bit off chars
    integer, parameter, public :: INLCR   = int(z'000040') ! map NL into CR
    integer, parameter, public :: IGNCR   = int(z'000080') ! ignore CR
    integer, parameter, public :: ICRNL   = int(z'000100') ! map CR to NL (ala CRMOD)
    integer, parameter, public :: IXON    = int(z'000200') ! enable output flow control
    integer, parameter, public :: IXOFF   = int(z'000400') ! enable input flow control
    integer, parameter, public :: IXANY   = int(z'000800') ! any char will restart after stop
    integer, parameter, public :: IMAXBEL = int(z'002000') ! ring bell on input queue full

    ! Control flags (hardware control of terminal).
    integer, parameter, public :: CIGNORE    = int(z'000001') ! ignore control flags
    integer, parameter, public :: CSIZE      = int(z'000300') ! character size mask
    integer, parameter, public :: CS5        = int(z'000000') ! 5 bits (pseudo)
    integer, parameter, public :: CS6        = int(z'000100') ! 6 bits
    integer, parameter, public :: CS7        = int(z'000200') ! 7 bits
    integer, parameter, public :: CS8        = int(z'000300') ! 8 bits
    integer, parameter, public :: CSTOPB     = int(z'000400') ! send 2 stop bits
    integer, parameter, public :: CREAD      = int(z'000800') ! enable receiver
    integer, parameter, public :: PARENB     = int(z'001000') ! parity enable
    integer, parameter, public :: PARODD     = int(z'002000') ! odd parity, else even
    integer, parameter, public :: HUPCL      = int(z'004000') ! hang up on last close
    integer, parameter, public :: CLOCAL     = int(z'008000') ! ignore modem status lines
    integer, parameter, public :: CCTS_OFLOW = int(z'010000') ! CTS flow control of output
    integer, parameter, public :: CRTS_IFLOW = int(z'020000') ! RTS flow control of input
    integer, parameter, public :: CRTSCTS    = ior(CCTS_OFLOW, CRTS_IFLOW)
    integer, parameter, public :: CDTR_IFLOW = int(z'040000') ! DTR flow control of input
    integer, parameter, public :: CDSR_OFLOW = int(z'080000') ! DSR flow control of output
    integer, parameter, public :: CCAR_OFLOW = int(z'100000') ! DCD flow control of output
    integer, parameter, public :: CNO_RTSDTR = int(z'200000') ! do not assert RTS or DTR automatically

    integer, parameter, public :: ECHOKE     = int(z'00000001') ! visual erase for line kill
    integer, parameter, public :: ECHOE      = int(z'00000002') ! visually erase chars
    integer, parameter, public :: ECHOK      = int(z'00000004') ! echo NL after line kill
    integer, parameter, public :: ECHO       = int(z'00000008') ! enable echoing
    integer, parameter, public :: ECHONL     = int(z'00000010') ! echo NL even if ECHO is off
    integer, parameter, public :: ECHOPRT    = int(z'00000020') ! visual erase mode for hardcopy
    integer, parameter, public :: ECHOCTL    = int(z'00000040') ! echo control chars as ^(Char)
    integer, parameter, public :: ISIG       = int(z'00000080') ! enable signals INTR, QUIT, [D]SUSP
    integer, parameter, public :: ICANON     = int(z'00000100') ! canonicalize input lines
    integer, parameter, public :: ALTWERASE  = int(z'00000200') ! use alternate WERASE algorithm
    integer, parameter, public :: IEXTEN     = int(z'00000400') ! enable DISCARD and LNEXT
    integer, parameter, public :: EXTPROC    = int(z'00000800') ! external processing
    integer, parameter, public :: TOSTOP     = int(z'00400000') ! stop background jobs from output
    integer, parameter, public :: FLUSHO     = int(z'00800000') ! output being flushed (state)
    integer, parameter, public :: NOKERNINFO = int(z'02000000') ! no kernel output from VSTATUS
    integer, parameter, public :: PENDIN     = int(z'20000000') ! XXX retype pending input (state)
    integer, parameter, public :: NOFLSH     = int(z'80000000') ! don't flush after interrupt

    integer, parameter, public :: B0      = 0
    integer, parameter, public :: B50     = 50
    integer, parameter, public :: B75     = 75
    integer, parameter, public :: B110    = 110
    integer, parameter, public :: B134    = 134
    integer, parameter, public :: B150    = 150
    integer, parameter, public :: B200    = 200
    integer, parameter, public :: B300    = 300
    integer, parameter, public :: B600    = 600
    integer, parameter, public :: B1200   = 1200
    integer, parameter, public :: B1800   = 1800
    integer, parameter, public :: B2400   = 2400
    integer, parameter, public :: B4800   = 4800
    integer, parameter, public :: B9600   = 9600
    integer, parameter, public :: B19200  = 19200
    integer, parameter, public :: B38400  = 38400
    integer, parameter, public :: B7200   = 7200
    integer, parameter, public :: B14400  = 14400
    integer, parameter, public :: B28800  = 28800
    integer, parameter, public :: B57600  = 57600
    integer, parameter, public :: B76800  = 76800
    integer, parameter, public :: B115200 = 115200
    integer, parameter, public :: B230400 = 230400
    integer, parameter, public :: B460800 = 460800
    integer, parameter, public :: B921600 = 921600

#endif

    public :: c_cfgetispeed
    public :: c_cfgetospeed
    public :: c_cfmakeraw
    public :: c_cfsetispeed
    public :: c_cfsetospeed
    public :: c_cfsetspeed
    public :: c_tcdrain
    public :: c_tcflow
    public :: c_tcflush
    public :: c_tcgetattr
    public :: c_tcsendbreak
    public :: c_tcsetattr

    interface
        ! int cfsetispeed(struct termios *termios_p, speed_t speed)
        function c_cfsetispeed(termios_p, speed) bind(c, name='cfsetispeed')
            import :: c_int, c_speed_t, c_termios
            type(c_termios),         intent(in)        :: termios_p
            integer(kind=c_speed_t), intent(in), value :: speed
            integer(kind=c_int)                        :: c_cfsetispeed
        end function c_cfsetispeed

        ! int cfsetospeed(struct termios *termios_p, speed_t speed)
        function c_cfsetospeed(termios_p, speed) bind(c, name='cfsetospeed')
            import :: c_int, c_speed_t, c_termios
            type(c_termios),         intent(in)        :: termios_p
            integer(kind=c_speed_t), intent(in), value :: speed
            integer(kind=c_int)                        :: c_cfsetospeed
        end function c_cfsetospeed

        ! int cfsetspeed(struct termios *termios_p, speed_t speed)
        function c_cfsetspeed(termios_p, speed) bind(c, name='cfsetspeed')
            import :: c_int, c_speed_t, c_termios
            type(c_termios),         intent(in)        :: termios_p
            integer(kind=c_speed_t), intent(in), value :: speed
            integer(kind=c_int)                        :: c_cfsetspeed
        end function c_cfsetspeed

        ! int tcdrain(int fd)
        function c_tcdrain(fd) bind(c, name='tcdrain')
            import :: c_int
            integer(kind=c_int), intent(in), value :: fd
            integer(kind=c_int)                    :: c_tcdrain
        end function c_tcdrain

        ! int tcflow(int fd, int action)
        function c_tcflow(fd, action) bind(c, name='tcflow')
            import :: c_int
            integer(kind=c_int), intent(in), value :: fd
            integer(kind=c_int), intent(in), value :: action
            integer(kind=c_int)                    :: c_tcflow
        end function c_tcflow

        ! int tcflush(int fd, int queue_selector)
        function c_tcflush(fd, queue_selector) bind(c, name='tcflush')
            import :: c_int
            integer(kind=c_int), intent(in), value :: fd
            integer(kind=c_int), intent(in), value :: queue_selector
            integer(kind=c_int)                    :: c_tcflush
        end function c_tcflush

        ! int tcgetattr(int fd, struct termios *termios_p)
        function c_tcgetattr(fd, termios_p) bind(c, name='tcgetattr')
            import :: c_int, c_termios
            integer(kind=c_int), intent(in), value :: fd
            type(c_termios),     intent(in)        :: termios_p
            integer(kind=c_int)                    :: c_tcgetattr
        end function c_tcgetattr

        ! int tcsendbreak(int fd, int duration)
        function c_tcsendbreak(fd, duration) bind(c, name='tcsendbreak')
            import :: c_int
            integer(kind=c_int), intent(in), value :: fd
            integer(kind=c_int), intent(in), value :: duration
            integer(kind=c_int)                    :: c_tcsendbreak
        end function c_tcsendbreak

        ! int tcsetattr(int fd, int optional_actions, const struct termios *termios_p)
        function c_tcsetattr(fd, optional_actions, termios_p) bind(c, name='tcsetattr')
            import :: c_int, c_termios
            integer(kind=c_int), intent(in), value :: fd
            integer(kind=c_int), intent(in), value :: optional_actions
            type(c_termios),     intent(in)        :: termios_p
            integer(kind=c_int)                    :: c_tcsetattr
        end function c_tcsetattr

        ! speed_t cfgetispeed(const struct termios *termios_p)
        function c_cfgetispeed(termios_p) bind(c, name='cfgetispeed')
            import :: c_speed_t, c_termios
            type(c_termios), intent(in) :: termios_p
            integer(kind=c_speed_t)     :: c_cfgetispeed
        end function c_cfgetispeed

        ! speed_t cfgetospeed(const struct termios *termios_p)
        function c_cfgetospeed(termios_p) bind(c, name='cfgetospeed')
            import :: c_speed_t, c_termios
            type(c_termios), intent(in) :: termios_p
            integer(kind=c_speed_t)     :: c_cfgetospeed
        end function c_cfgetospeed

        ! void cfmakeraw(struct termios *termios_p)
        subroutine c_cfmakeraw(termios_p) bind(c, name='cfmakeraw')
            import :: c_termios
            type(c_termios), intent(in) :: termios_p
        end subroutine c_cfmakeraw
    end interface
end module unix_termios
