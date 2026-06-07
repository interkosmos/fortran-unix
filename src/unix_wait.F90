! unix_wait.F90
!
! Author:  Philipp Engel
! Licence: ISC
module unix_wait
    use :: unix_types
    implicit none
    private

#if defined (__linux__)

    integer(c_int), parameter, public :: WNOHANG    = int(z'00000001')
    integer(c_int), parameter, public :: WUNTRACED  = int(z'00000002')
    integer(c_int), parameter, public :: WSTOPPED   = WUNTRACED
    integer(c_int), parameter, public :: WEXITED    = int(z'00000004')
    integer(c_int), parameter, public :: WCONTINUED = int(z'00000008')
    integer(c_int), parameter, public :: WNOWAIT    = int(z'01000000')

#elif defined (__FreeBSD__)

    integer(c_int), parameter, public :: WNOHANG    = 1         ! Don’t hang in wait.
    integer(c_int), parameter, public :: WUNTRACED  = 2         ! Tell about stopped, untraced children.
    integer(c_int), parameter, public :: WSTOPPED   = WUNTRACED ! SUS compatibility
    integer(c_int), parameter, public :: WCONTINUED = 4         ! Report a job control continued process.
    integer(c_int), parameter, public :: WNOWAIT    = 8         ! Poll only. Don’t delete the proc entry.
    integer(c_int), parameter, public :: WEXITED    = 16        ! Wait for exited processes.
    integer(c_int), parameter, public :: WTRAPPED   = 32        ! Wait for a process to hit a trap or a breakpoint.

#endif

    public :: c_wait
    public :: c_waitpid

    interface
        ! pid_t wait(int *stat_loc)
        function c_wait(stat_loc) bind(c, name='wait')
            import :: c_int, c_pid_t
            implicit none
            integer(c_int), intent(out) :: stat_loc
            integer(c_pid_t)            :: c_wait
        end function c_wait

        ! pid_t waitpid(pid_t pid, int *status, int options);
        function c_waitpid(pid, status, options) bind(c, name='waitpid')
            import :: c_int, c_pid_t
            implicit none
            integer(c_pid_t), intent(in), value :: pid
            integer(c_int),   intent(out)       :: status
            integer(c_int),   intent(in), value :: options
            integer(c_pid_t)                    :: c_waitpid
        end function c_waitpid
    end interface
end module unix_wait
