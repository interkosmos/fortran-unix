! unix_signal.F90
!
! Author:  Philipp Engel
! Licence: ISC
module unix_signal
    use :: unix_types
    implicit none
    private

#if defined (__linux__)

    integer(kind=c_int), parameter, public :: SIGHUP    = 1
    integer(kind=c_int), parameter, public :: SIGINT    = 2
    integer(kind=c_int), parameter, public :: SIGQUIT   = 3
    integer(kind=c_int), parameter, public :: SIGILL    = 4
    integer(kind=c_int), parameter, public :: SIGTRAP   = 5
    integer(kind=c_int), parameter, public :: SIGABRT   = 6
    integer(kind=c_int), parameter, public :: SIGIOT    = 6
    integer(kind=c_int), parameter, public :: SIGBUS    = 7
    integer(kind=c_int), parameter, public :: SIGFPE    = 8
    integer(kind=c_int), parameter, public :: SIGKILL   = 9
    integer(kind=c_int), parameter, public :: SIGUSR1   = 10
    integer(kind=c_int), parameter, public :: SIGSEGV   = 11
    integer(kind=c_int), parameter, public :: SIGUSR2   = 12
    integer(kind=c_int), parameter, public :: SIGPIPE   = 13
    integer(kind=c_int), parameter, public :: SIGALRM   = 14
    integer(kind=c_int), parameter, public :: SIGTERM   = 15
    integer(kind=c_int), parameter, public :: SIGSTKFLT = 16
    integer(kind=c_int), parameter, public :: SIGCHLD   = 17
    integer(kind=c_int), parameter, public :: SIGCONT   = 18
    integer(kind=c_int), parameter, public :: SIGSTOP   = 19
    integer(kind=c_int), parameter, public :: SIGTSTP   = 20
    integer(kind=c_int), parameter, public :: SIGTTIN   = 21
    integer(kind=c_int), parameter, public :: SIGTTOU   = 22
    integer(kind=c_int), parameter, public :: SIGURG    = 23
    integer(kind=c_int), parameter, public :: SIGXCPU   = 24
    integer(kind=c_int), parameter, public :: SIGXFSZ   = 25
    integer(kind=c_int), parameter, public :: SIGVTALRM = 26
    integer(kind=c_int), parameter, public :: SIGPROF   = 27
    integer(kind=c_int), parameter, public :: SIGWINCH  = 28
    integer(kind=c_int), parameter, public :: SIGIO     = 29
    integer(kind=c_int), parameter, public :: SIGPOLL   = SIGIO
    integer(kind=c_int), parameter, public :: SIGPWR    = 30
    integer(kind=c_int), parameter, public :: SIGSYS    = 31
    integer(kind=c_int), parameter, public :: SIGUNUSED = 31

    integer, parameter :: SIG_WORDS = 16

    ! struct sigset_t
    type, bind(c), public :: c_sigset_t
        integer(kind=c_unsigned_long) :: bits(SIG_WORDS) = 0_c_unsigned_long
    end type c_sigset_t

    ! struct sigaction
    type, bind(c), public :: c_sigaction_t
        type(c_funptr)               :: sa_handler  = c_null_funptr
        type(c_sigset_t)             :: sa_mask     = c_sigset_t()
        integer(kind=c_int)          :: sa_flags    = 0
        integer(kind=c_int), private :: padding     = 0 ! Explicit ABI padding on x86_64 glibc.
        type(c_funptr)               :: sa_restorer = c_null_funptr
    end type c_sigaction_t

#elif defined (__FreeBSD__)

    integer(kind=c_int), parameter, public :: SIGHUP    = 1
    integer(kind=c_int), parameter, public :: SIGINT    = 2
    integer(kind=c_int), parameter, public :: SIGQUIT   = 3
    integer(kind=c_int), parameter, public :: SIGILL    = 4
    integer(kind=c_int), parameter, public :: SIGTRAP   = 5
    integer(kind=c_int), parameter, public :: SIGABRT   = 6
    integer(kind=c_int), parameter, public :: SIGIOT    = SIGABRT
    integer(kind=c_int), parameter, public :: SIGEMT    = 7
    integer(kind=c_int), parameter, public :: SIGFPE    = 8
    integer(kind=c_int), parameter, public :: SIGKILL   = 9
    integer(kind=c_int), parameter, public :: SIGBUS    = 10
    integer(kind=c_int), parameter, public :: SIGSEGV   = 11
    integer(kind=c_int), parameter, public :: SIGSYS    = 12
    integer(kind=c_int), parameter, public :: SIGPIPE   = 13
    integer(kind=c_int), parameter, public :: SIGALRM   = 14
    integer(kind=c_int), parameter, public :: SIGTERM   = 15
    integer(kind=c_int), parameter, public :: SIGURG    = 16
    integer(kind=c_int), parameter, public :: SIGSTOP   = 17
    integer(kind=c_int), parameter, public :: SIGTSTP   = 18
    integer(kind=c_int), parameter, public :: SIGCONT   = 19
    integer(kind=c_int), parameter, public :: SIGCHLD   = 20
    integer(kind=c_int), parameter, public :: SIGTTIN   = 21
    integer(kind=c_int), parameter, public :: SIGTTOU   = 22
    integer(kind=c_int), parameter, public :: SIGIO     = 23
    integer(kind=c_int), parameter, public :: SIGXCPU   = 24
    integer(kind=c_int), parameter, public :: SIGXFSZ   = 25
    integer(kind=c_int), parameter, public :: SIGVTALRM = 26
    integer(kind=c_int), parameter, public :: SIGPROF   = 27
    integer(kind=c_int), parameter, public :: SIGWINCH  = 28
    integer(kind=c_int), parameter, public :: SIGINFO   = 29
    integer(kind=c_int), parameter, public :: SIGUSR1   = 30
    integer(kind=c_int), parameter, public :: SIGUSR2   = 31

    integer, parameter :: SIG_WORDS = 4

    ! struct sigset_t
    type, bind(c), public :: c_sigset_t
        integer(kind=c_uint32_t) :: bits(SIG_WORDS) = 0_c_uint32_t
    end type c_sigset_t

    ! struct sigaction
    type, bind(c), public :: c_sigaction_t
        type(c_funptr)      :: sa_handler = c_null_funptr
        integer(kind=c_int) :: sa_flags   = 0
        type(c_sigset_t)    :: sa_mask    = c_sigset_t()
    end type c_sigaction_t

#endif

    public :: c_kill
    public :: c_sigaction
    public :: c_signal

    interface
        ! int kill(pid_t pid, int sig)
        function c_kill(pid, sig) bind(c, name='kill')
            import :: c_int, c_pid_t
            implicit none
            integer(kind=c_pid_t), intent(in), value :: pid
            integer(kind=c_int),   intent(in), value :: sig
            integer(kind=c_int)                      :: c_kill
        end function c_kill

        ! int sigaction(int signum, const struct sigaction *act, struct sigaction *oact)
        function c_sigaction(signum, act, oact) bind(c, name='sigaction')
            import :: c_int, c_sigaction_t
            implicit none
            integer(kind=c_int), intent(in),  value    :: signum
            type(c_sigaction_t), intent(in),  optional :: act
            type(c_sigaction_t), intent(out), optional :: oact
            integer(kind=c_int)                        :: c_sigaction
        end function c_sigaction

        ! sig_t signal(int sig, sig_t func)
        function c_signal(sig, func) bind(c, name='signal')
            import :: c_funptr, c_int
            implicit none
            integer(kind=c_int), intent(in), value :: sig
            type(c_funptr),      intent(in), value :: func
            type(c_funptr)                         :: c_signal
        end function c_signal
    end interface
end module unix_signal
