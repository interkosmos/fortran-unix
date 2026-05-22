! unix_termios.F90
!
! Author:  Philipp Engel
! Licence: ISC
module unix_termios
    use :: unix_types
    implicit none
    private

#if defined (__linux__)

    integer(c_int), parameter, public :: VINTR    = 0
    integer(c_int), parameter, public :: VQUIT    = 1
    integer(c_int), parameter, public :: VERASE   = 2
    integer(c_int), parameter, public :: VKILL    = 3
    integer(c_int), parameter, public :: VEOF     = 4
    integer(c_int), parameter, public :: VTIME    = 5
    integer(c_int), parameter, public :: VMIN     = 6
    integer(c_int), parameter, public :: VSWTC    = 7
    integer(c_int), parameter, public :: VSTART   = 8
    integer(c_int), parameter, public :: VSTOP    = 9
    integer(c_int), parameter, public :: VSUSP    = 10
    integer(c_int), parameter, public :: VEOL     = 11
    integer(c_int), parameter, public :: VREPRINT = 12
    integer(c_int), parameter, public :: VDISCARD = 13
    integer(c_int), parameter, public :: VWERASE  = 14
    integer(c_int), parameter, public :: VLNEXT   = 15
    integer(c_int), parameter, public :: VEOL2    = 16

    integer(c_int), parameter, public :: IGNBRK  = int(o'000001')
    integer(c_int), parameter, public :: BRKINT  = int(o'000002')
    integer(c_int), parameter, public :: IGNPAR  = int(o'000004')
    integer(c_int), parameter, public :: PARMRK  = int(o'000010')
    integer(c_int), parameter, public :: INPCK   = int(o'000020')
    integer(c_int), parameter, public :: ISTRIP  = int(o'000040')
    integer(c_int), parameter, public :: INLCR   = int(o'000100')
    integer(c_int), parameter, public :: IGNCR   = int(o'000200')
    integer(c_int), parameter, public :: ICRNL   = int(o'000400')
    integer(c_int), parameter, public :: IUCLC   = int(o'001000')
    integer(c_int), parameter, public :: IXON    = int(o'002000')
    integer(c_int), parameter, public :: IXANY   = int(o'004000')
    integer(c_int), parameter, public :: IXOFF   = int(o'010000')
    integer(c_int), parameter, public :: IMAXBEL = int(o'020000')
    integer(c_int), parameter, public :: IUTF8   = int(o'040000')

    integer(c_int), parameter, public :: OPOST  = int(o'000001')
    integer(c_int), parameter, public :: OLCUC  = int(o'000002')
    integer(c_int), parameter, public :: ONLCR  = int(o'000004')
    integer(c_int), parameter, public :: OCRNL  = int(o'000010')
    integer(c_int), parameter, public :: ONOCR  = int(o'000020')
    integer(c_int), parameter, public :: ONLRET = int(o'000040')
    integer(c_int), parameter, public :: OFILL  = int(o'000100')
    integer(c_int), parameter, public :: OFDEL  = int(o'000200')

    integer(c_int), parameter, public :: VTDLY  = int(o'040000')
    integer(c_int), parameter, public :: VT0    = int(o'000000')
    integer(c_int), parameter, public :: VT1    = int(o'040000')

    integer(c_int), parameter, public :: CSIZE  = int(o'000060')
    integer(c_int), parameter, public :: CS5    = int(o'000000')
    integer(c_int), parameter, public :: CS6    = int(o'000020')
    integer(c_int), parameter, public :: CS7    = int(o'000040')
    integer(c_int), parameter, public :: CS8    = int(o'000060')
    integer(c_int), parameter, public :: CSTOPB = int(o'000100')
    integer(c_int), parameter, public :: CREAD  = int(o'000200')
    integer(c_int), parameter, public :: PARENB = int(o'000400')
    integer(c_int), parameter, public :: PARODD = int(o'001000')
    integer(c_int), parameter, public :: HUPCL  = int(o'002000')
    integer(c_int), parameter, public :: CLOCAL = int(o'004000')

    integer(c_int), parameter, public :: ISIG   = int(o'000001')
    integer(c_int), parameter, public :: ICANON = int(o'000002')
    integer(c_int), parameter, public :: ECHO   = int(o'000010')
    integer(c_int), parameter, public :: ECHOE  = int(o'000020')
    integer(c_int), parameter, public :: ECHOK  = int(o'000040')
    integer(c_int), parameter, public :: ECHONL = int(o'000100')
    integer(c_int), parameter, public :: NOFLSH = int(o'000200')
    integer(c_int), parameter, public :: TOSTOP = int(o'000400')
    integer(c_int), parameter, public :: IEXTEN = int(o'100000')

    integer(c_int), parameter, public :: TCOOFF    = 0
    integer(c_int), parameter, public :: TCOON     = 1
    integer(c_int), parameter, public :: TCIOFF    = 2
    integer(c_int), parameter, public :: TCION     = 3
    integer(c_int), parameter, public :: TCIFLUSH  = 0
    integer(c_int), parameter, public :: TCOFLUSH  = 1
    integer(c_int), parameter, public :: TCIOFLUSH = 2
    integer(c_int), parameter, public :: TCSANOW   = 0
    integer(c_int), parameter, public :: TCSADRAIN = 1
    integer(c_int), parameter, public :: TCSAFLUSH = 2

    integer(c_int), parameter, public :: B0       = int(o'000000')
    integer(c_int), parameter, public :: B50      = int(o'000001')
    integer(c_int), parameter, public :: B75      = int(o'000002')
    integer(c_int), parameter, public :: B110     = int(o'000003')
    integer(c_int), parameter, public :: B134     = int(o'000004')
    integer(c_int), parameter, public :: B150     = int(o'000005')
    integer(c_int), parameter, public :: B200     = int(o'000006')
    integer(c_int), parameter, public :: B300     = int(o'000007')
    integer(c_int), parameter, public :: B600     = int(o'000010')
    integer(c_int), parameter, public :: B1200    = int(o'000011')
    integer(c_int), parameter, public :: B1800    = int(o'000012')
    integer(c_int), parameter, public :: B2400    = int(o'000013')
    integer(c_int), parameter, public :: B4800    = int(o'000014')
    integer(c_int), parameter, public :: B9600    = int(o'000015')
    integer(c_int), parameter, public :: B19200   = int(o'000016')
    integer(c_int), parameter, public :: B38400   = int(o'000017')
    integer(c_int), parameter, public :: B57600   = int(o'010001')
    integer(c_int), parameter, public :: B115200  = int(o'010002')
    integer(c_int), parameter, public :: B230400  = int(o'010003')
    integer(c_int), parameter, public :: B460800  = int(o'010004')
    integer(c_int), parameter, public :: B500000  = int(o'010005')
    integer(c_int), parameter, public :: B576000  = int(o'010006')
    integer(c_int), parameter, public :: B921600  = int(o'010007')
    integer(c_int), parameter, public :: B1000000 = int(o'010010')
    integer(c_int), parameter, public :: B1152000 = int(o'010011')
    integer(c_int), parameter, public :: B1500000 = int(o'010012')
    integer(c_int), parameter, public :: B2000000 = int(o'010013')
    integer(c_int), parameter, public :: B2500000 = int(o'010014')
    integer(c_int), parameter, public :: B3000000 = int(o'010015')
    integer(c_int), parameter, public :: B3500000 = int(o'010016')
    integer(c_int), parameter, public :: B4000000 = int(o'010017')

    integer(c_int), parameter, public :: TIOCM_LE   = int(z'001')
    integer(c_int), parameter, public :: TIOCM_DTR  = int(z'002')
    integer(c_int), parameter, public :: TIOCM_RTS  = int(z'004')
    integer(c_int), parameter, public :: TIOCM_ST   = int(z'008')
    integer(c_int), parameter, public :: TIOCM_SR   = int(z'010')
    integer(c_int), parameter, public :: TIOCM_CTS  = int(z'020')
    integer(c_int), parameter, public :: TIOCM_CAR  = int(z'040')
    integer(c_int), parameter, public :: TIOCM_RNG  = int(z'080')
    integer(c_int), parameter, public :: TIOCM_DSR  = int(z'100')
    integer(c_int), parameter, public :: TIOCM_CD   = TIOCM_CAR
    integer(c_int), parameter, public :: TIOCM_RI   = TIOCM_RNG
    integer(c_int), parameter, public :: TIOCM_OUT1 = int(z'2000')
    integer(c_int), parameter, public :: TIOCM_OUT2 = int(z'4000')
    integer(c_int), parameter, public :: TIOCM_LOOP = int(z'8000')

    integer(c_int), parameter, public :: TIOCMGET = int(z'5415')
    integer(c_int), parameter, public :: TIOCMBIC = int(z'5417')
    integer(c_int), parameter, public :: TIOCMBIS = int(z'5416')
    integer(c_int), parameter, public :: TIOCMSET = int(z'5418')

    integer, parameter, public :: NCCS = 32

    ! struct termios
    type, bind(c), public :: c_termios
        integer(c_tcflag_t) :: c_iflag          = 0_c_tcflag_t
        integer(c_tcflag_t) :: c_oflag          = 0_c_tcflag_t
        integer(c_tcflag_t) :: c_cflag          = 0_c_tcflag_t
        integer(c_tcflag_t) :: c_lflag          = 0_c_tcflag_t
        integer(c_cc_t)     :: c_line           = 0_c_cc_t
        integer(c_cc_t)     :: c_cc(0:NCCS - 1) = 0_c_cc_t
        integer(c_speed_t)  :: c_ispeed         = 0_c_speed_t
        integer(c_speed_t)  :: c_ospeed         = 0_c_speed_t
    end type c_termios

#elif defined (__FreeBSD__)

    integer(c_int), parameter, public :: VEOF     = 0  ! ICANON
    integer(c_int), parameter, public :: VEOL     = 1  ! ICANON
    integer(c_int), parameter, public :: VEOL2    = 2  ! ICANON together with IEXTEN
    integer(c_int), parameter, public :: VERASE   = 3  ! ICANON
    integer(c_int), parameter, public :: VWERASE  = 4  ! ICANON together with IEXTEN
    integer(c_int), parameter, public :: VKILL    = 5  ! ICANON
    integer(c_int), parameter, public :: VREPRINT = 6  ! ICANON together with IEXTEN
    integer(c_int), parameter, public :: VERASE2  = 7  ! ICANON
    integer(c_int), parameter, public :: VINTR    = 8  ! ISIG
    integer(c_int), parameter, public :: VQUIT    = 9  ! ISIG
    integer(c_int), parameter, public :: VSUSP    = 10 ! ISIG
    integer(c_int), parameter, public :: VDSUSP   = 11 ! ISIG together with IEXTEN
    integer(c_int), parameter, public :: VSTART   = 12 ! IXON, IXOFF
    integer(c_int), parameter, public :: VSTOP    = 13 ! IXON, IXOFF
    integer(c_int), parameter, public :: VLNEXT   = 14 ! IEXTEN
    integer(c_int), parameter, public :: VDISCARD = 15 ! IEXTEN
    integer(c_int), parameter, public :: VMIN     = 16 ! !ICANON
    integer(c_int), parameter, public :: VTIME    = 17 ! !ICANON
    integer(c_int), parameter, public :: VSTATUS  = 18 ! ICANON together with IEXTEN

    ! Commands passed to tcsetattr() for setting the termios structure.
    integer(c_int), parameter, public :: TCSANOW   = 0          ! Make change immediate.
    integer(c_int), parameter, public :: TCSADRAIN = 1          ! Drain output, then change.
    integer(c_int), parameter, public :: TCSAFLUSH = 2          ! Drain output, flush input.
    integer(c_int), parameter, public :: TCSASOFT  = int(z'10') ! Flag – don’t alter h.w. state.

    ! Input flags (software input processing).
    integer(c_int), parameter, public :: IGNBRK  = int(z'000001') ! Ignore BREAK condition.
    integer(c_int), parameter, public :: BRKINT  = int(z'000002') ! Map BREAK to SIGINTR.
    integer(c_int), parameter, public :: IGNPAR  = int(z'000004') ! Ignore (discard) parity errors.
    integer(c_int), parameter, public :: PARMRK  = int(z'000008') ! Mark parity and framing errors.
    integer(c_int), parameter, public :: INPCK   = int(z'000010') ! Enable checking of parity errors.
    integer(c_int), parameter, public :: ISTRIP  = int(z'000020') ! Strip 8th bit off chars.
    integer(c_int), parameter, public :: INLCR   = int(z'000040') ! Map NL into CR.
    integer(c_int), parameter, public :: IGNCR   = int(z'000080') ! Ignore CR.
    integer(c_int), parameter, public :: ICRNL   = int(z'000100') ! Map CR to NL (ala CRMOD).
    integer(c_int), parameter, public :: IXON    = int(z'000200') ! Enable output flow control.
    integer(c_int), parameter, public :: IXOFF   = int(z'000400') ! Enable input flow control.
    integer(c_int), parameter, public :: IXANY   = int(z'000800') ! Any char will restart after stop.
    integer(c_int), parameter, public :: IMAXBEL = int(z'002000') ! Ring bell on input queue full.

    ! Output flags.
    integer(c_int), parameter, public :: OPOST  = int(o'0000001')
    integer(c_int), parameter, public :: ONLCR  = int(o'0000002')
    integer(c_int), parameter, public :: OCRNL  = int(o'0000010')
    integer(c_int), parameter, public :: ONOCR  = int(o'0000020')
    integer(c_int), parameter, public :: ONLRET = int(o'0000040')

    ! Control flags (hardware control of terminal).
    integer(c_int), parameter, public :: CIGNORE    = int(z'000001') ! Ignore control flags.
    integer(c_int), parameter, public :: CSIZE      = int(z'000300') ! Character size mask.
    integer(c_int), parameter, public :: CS5        = int(z'000000') ! 5 bits (pseudo).
    integer(c_int), parameter, public :: CS6        = int(z'000100') ! 6 bits.
    integer(c_int), parameter, public :: CS7        = int(z'000200') ! 7 bits.
    integer(c_int), parameter, public :: CS8        = int(z'000300') ! 8 bits.
    integer(c_int), parameter, public :: CSTOPB     = int(z'000400') ! Send 2 stop bits.
    integer(c_int), parameter, public :: CREAD      = int(z'000800') ! Enable receiver.
    integer(c_int), parameter, public :: PARENB     = int(z'001000') ! Parity enable.
    integer(c_int), parameter, public :: PARODD     = int(z'002000') ! Odd parity, else even.
    integer(c_int), parameter, public :: HUPCL      = int(z'004000') ! Hang up on last close.
    integer(c_int), parameter, public :: CLOCAL     = int(z'008000') ! Ignore modem status lines.
    integer(c_int), parameter, public :: CCTS_OFLOW = int(z'010000') ! CTS flow control of output.
    integer(c_int), parameter, public :: CRTS_IFLOW = int(z'020000') ! RTS flow control of input.
    integer(c_int), parameter, public :: CRTSCTS    = ior(CCTS_OFLOW, CRTS_IFLOW)
    integer(c_int), parameter, public :: CDTR_IFLOW = int(z'040000') ! DTR flow control of input.
    integer(c_int), parameter, public :: CDSR_OFLOW = int(z'080000') ! DSR flow control of output.
    integer(c_int), parameter, public :: CCAR_OFLOW = int(z'100000') ! DCD flow control of output.
    integer(c_int), parameter, public :: CNO_RTSDTR = int(z'200000') ! Do not assert RTS or DTR automatically.

    integer(c_int), parameter, public :: ECHOKE     = int(z'00000001') ! Visual erase for line kill.
    integer(c_int), parameter, public :: ECHOE      = int(z'00000002') ! Visually erase chars.
    integer(c_int), parameter, public :: ECHOK      = int(z'00000004') ! Echo NL after line kill.
    integer(c_int), parameter, public :: ECHO       = int(z'00000008') ! Enable echoing.
    integer(c_int), parameter, public :: ECHONL     = int(z'00000010') ! Echo NL even if ECHO is off.
    integer(c_int), parameter, public :: ECHOPRT    = int(z'00000020') ! Visual erase mode for hardcopy.
    integer(c_int), parameter, public :: ECHOCTL    = int(z'00000040') ! Echo control chars as ^(Char).
    integer(c_int), parameter, public :: ISIG       = int(z'00000080') ! Enable signals INTR, QUIT, [D]SUSP.
    integer(c_int), parameter, public :: ICANON     = int(z'00000100') ! Canonicalize input lines.
    integer(c_int), parameter, public :: ALTWERASE  = int(z'00000200') ! Use alternate WERASE algorithm.
    integer(c_int), parameter, public :: IEXTEN     = int(z'00000400') ! Enable DISCARD and LNEXT.
    integer(c_int), parameter, public :: EXTPROC    = int(z'00000800') ! External processing.
    integer(c_int), parameter, public :: TOSTOP     = int(z'00400000') ! Stop background jobs from output.
    integer(c_int), parameter, public :: FLUSHO     = int(z'00800000') ! Output being flushed (state).
    integer(c_int), parameter, public :: NOKERNINFO = int(z'02000000') ! No kernel output from VSTATUS.
    integer(c_int), parameter, public :: PENDIN     = int(z'20000000') ! XXX retype pending input (state).
    integer(c_int), parameter, public :: NOFLSH     = int(z'80000000') ! Don’t flush after interrupt.

    integer(c_int), parameter, public :: TCIFLUSH  = 1
    integer(c_int), parameter, public :: TCOFLUSH  = 2
    integer(c_int), parameter, public :: TCIOFLUSH = 3
    integer(c_int), parameter, public :: TCOOFF    = 1
    integer(c_int), parameter, public :: TCOON     = 2
    integer(c_int), parameter, public :: TCIOFF    = 3
    integer(c_int), parameter, public :: TCION     = 4

    integer(c_int), parameter, public :: B0      = 0
    integer(c_int), parameter, public :: B50     = 50
    integer(c_int), parameter, public :: B75     = 75
    integer(c_int), parameter, public :: B110    = 110
    integer(c_int), parameter, public :: B134    = 134
    integer(c_int), parameter, public :: B150    = 150
    integer(c_int), parameter, public :: B200    = 200
    integer(c_int), parameter, public :: B300    = 300
    integer(c_int), parameter, public :: B600    = 600
    integer(c_int), parameter, public :: B1200   = 1200
    integer(c_int), parameter, public :: B1800   = 1800
    integer(c_int), parameter, public :: B2400   = 2400
    integer(c_int), parameter, public :: B4800   = 4800
    integer(c_int), parameter, public :: B9600   = 9600
    integer(c_int), parameter, public :: B19200  = 19200
    integer(c_int), parameter, public :: B38400  = 38400
    integer(c_int), parameter, public :: B7200   = 7200
    integer(c_int), parameter, public :: B14400  = 14400
    integer(c_int), parameter, public :: B28800  = 28800
    integer(c_int), parameter, public :: B57600  = 57600
    integer(c_int), parameter, public :: B76800  = 76800
    integer(c_int), parameter, public :: B115200 = 115200
    integer(c_int), parameter, public :: B230400 = 230400
    integer(c_int), parameter, public :: B460800 = 460800
    integer(c_int), parameter, public :: B921600 = 921600

    integer(c_int), parameter, public :: TIOCM_LE  = int(o'0001') ! line enable
    integer(c_int), parameter, public :: TIOCM_DTR = int(o'0002') ! data terminal ready
    integer(c_int), parameter, public :: TIOCM_RTS = int(o'0004') ! request to send
    integer(c_int), parameter, public :: TIOCM_ST  = int(o'0010') ! secondary transmit
    integer(c_int), parameter, public :: TIOCM_SR  = int(o'0020') ! secondary receive
    integer(c_int), parameter, public :: TIOCM_CTS = int(o'0040') ! clear to send
    integer(c_int), parameter, public :: TIOCM_DCD = int(o'0100') ! data carrier detect
    integer(c_int), parameter, public :: TIOCM_RI  = int(o'0200') ! ring indicate
    integer(c_int), parameter, public :: TIOCM_DSR = int(o'0400') ! data set ready
    integer(c_int), parameter, public :: TIOCM_CD  = TIOCM_DCD
    integer(c_int), parameter, public :: TIOCM_CAR = TIOCM_DCD
    integer(c_int), parameter, public :: TIOCM_RNG = TIOCM_RI

    integer(c_int), parameter, public :: TIOCMGET  = int(z'4004746a')
    integer(c_int), parameter, public :: TIOCMBIC  = int(z'8004746b')
    integer(c_int), parameter, public :: TIOCMBIS  = int(z'8004746c')
    integer(c_int), parameter, public :: TIOCMSET  = int(z'8004746d')
    integer(c_int), parameter, public :: TIOCSTART = int(z'2000746e')
    integer(c_int), parameter, public :: TIOCSTOP  = int(z'2000746f')

    integer, parameter, public :: NCCS = 20

    ! struct termios
    type, bind(c), public :: c_termios
        integer(c_tcflag_t) :: c_iflag          = 0_c_tcflag_t
        integer(c_tcflag_t) :: c_oflag          = 0_c_tcflag_t
        integer(c_tcflag_t) :: c_cflag          = 0_c_tcflag_t
        integer(c_tcflag_t) :: c_lflag          = 0_c_tcflag_t
        integer(c_cc_t)     :: c_cc(0:NCCS - 1) = 0_c_cc_t
        integer(c_speed_t)  :: c_ispeed         = 0_c_speed_t
        integer(c_speed_t)  :: c_ospeed         = 0_c_speed_t
    end type c_termios

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
            implicit none
            type(c_termios),    intent(in)        :: termios_p
            integer(c_speed_t), intent(in), value :: speed
            integer(c_int)                        :: c_cfsetispeed
        end function c_cfsetispeed

        ! int cfsetospeed(struct termios *termios_p, speed_t speed)
        function c_cfsetospeed(termios_p, speed) bind(c, name='cfsetospeed')
            import :: c_int, c_speed_t, c_termios
            implicit none
            type(c_termios),    intent(in)        :: termios_p
            integer(c_speed_t), intent(in), value :: speed
            integer(c_int)                        :: c_cfsetospeed
        end function c_cfsetospeed

        ! int cfsetspeed(struct termios *termios_p, speed_t speed)
        function c_cfsetspeed(termios_p, speed) bind(c, name='cfsetspeed')
            import :: c_int, c_speed_t, c_termios
            implicit none
            type(c_termios),    intent(in)        :: termios_p
            integer(c_speed_t), intent(in), value :: speed
            integer(c_int)                        :: c_cfsetspeed
        end function c_cfsetspeed

        ! int tcdrain(int fd)
        function c_tcdrain(fd) bind(c, name='tcdrain')
            import :: c_int
            implicit none
            integer(c_int), intent(in), value :: fd
            integer(c_int)                    :: c_tcdrain
        end function c_tcdrain

        ! int tcflow(int fd, int action)
        function c_tcflow(fd, action) bind(c, name='tcflow')
            import :: c_int
            implicit none
            integer(c_int), intent(in), value :: fd
            integer(c_int), intent(in), value :: action
            integer(c_int)                    :: c_tcflow
        end function c_tcflow

        ! int tcflush(int fd, int queue_selector)
        function c_tcflush(fd, queue_selector) bind(c, name='tcflush')
            import :: c_int
            implicit none
            integer(c_int), intent(in), value :: fd
            integer(c_int), intent(in), value :: queue_selector
            integer(c_int)                    :: c_tcflush
        end function c_tcflush

        ! int tcgetattr(int fd, struct termios *termios_p)
        function c_tcgetattr(fd, termios_p) bind(c, name='tcgetattr')
            import :: c_int, c_termios
            implicit none
            integer(c_int),  intent(in), value :: fd
            type(c_termios), intent(in)        :: termios_p
            integer(c_int)                     :: c_tcgetattr
        end function c_tcgetattr

        ! int tcsendbreak(int fd, int duration)
        function c_tcsendbreak(fd, duration) bind(c, name='tcsendbreak')
            import :: c_int
            implicit none
            integer(c_int), intent(in), value :: fd
            integer(c_int), intent(in), value :: duration
            integer(c_int)                    :: c_tcsendbreak
        end function c_tcsendbreak

        ! int tcsetattr(int fd, int optional_actions, const struct termios *termios_p)
        function c_tcsetattr(fd, optional_actions, termios_p) bind(c, name='tcsetattr')
            import :: c_int, c_termios
            implicit none
            integer(c_int),  intent(in), value :: fd
            integer(c_int),  intent(in), value :: optional_actions
            type(c_termios), intent(in)        :: termios_p
            integer(c_int)                     :: c_tcsetattr
        end function c_tcsetattr

        ! speed_t cfgetispeed(const struct termios *termios_p)
        function c_cfgetispeed(termios_p) bind(c, name='cfgetispeed')
            import :: c_speed_t, c_termios
            implicit none
            type(c_termios), intent(in) :: termios_p
            integer(c_speed_t)          :: c_cfgetispeed
        end function c_cfgetispeed

        ! speed_t cfgetospeed(const struct termios *termios_p)
        function c_cfgetospeed(termios_p) bind(c, name='cfgetospeed')
            import :: c_speed_t, c_termios
            implicit none
            type(c_termios), intent(in) :: termios_p
            integer(c_speed_t)          :: c_cfgetospeed
        end function c_cfgetospeed

        ! void cfmakeraw(struct termios *termios_p)
        subroutine c_cfmakeraw(termios_p) bind(c, name='cfmakeraw')
            import :: c_termios
            implicit none
            type(c_termios), intent(in) :: termios_p
        end subroutine c_cfmakeraw
    end interface
end module unix_termios
