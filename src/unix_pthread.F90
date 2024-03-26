! unix_pthread.F90
!
! Author:  Philipp Engel
! Licence: ISC
module unix_pthread
    use, intrinsic :: iso_c_binding
    implicit none
    private

#if defined (__linux__)

    integer(kind=c_int), parameter :: PTHREAD_CREATE_DETACHED = 1

    integer(kind=c_int), parameter :: PTHREAD_CANCEL_ENABLE       = 0
    integer(kind=c_int), parameter :: PTHREAD_CANCEL_DISABLE      = 1
    integer(kind=c_int), parameter :: PTHREAD_CANCEL_DEFERRED     = 0
    integer(kind=c_int), parameter :: PTHREAD_CANCEL_ASYNCHRONOUS = 1
    integer(kind=c_int), parameter :: PTHREAD_CANCELED            = -1

    integer(kind=c_int), parameter :: PTHREAD_EXPLICIT_SCHED  = 1
    integer(kind=c_int), parameter :: PTHREAD_PROCESS_PRIVATE = 0

    integer(kind=c_int), parameter :: PTHREAD_MUTEX_NORMAL     = 0
    integer(kind=c_int), parameter :: PTHREAD_MUTEX_ERRORCHECK = 2
    integer(kind=c_int), parameter :: PTHREAD_MUTEX_RECURSIVE  = 1

    integer, parameter :: PTHREAD_SIZE       = 8  ! 8 Bytes.
    integer, parameter :: PTHREAD_MUTEX_SIZE = 40 ! 40 Bytes.

#elif defined (__FreeBSD__)

    integer(kind=c_int), parameter :: PTHREAD_DETACHED      = int(z'1')
    integer(kind=c_int), parameter :: PTHREAD_SCOPE_SYSTEM  = int(z'2')
    integer(kind=c_int), parameter :: PTHREAD_INHERIT_SCHED = int(z'4')
    integer(kind=c_int), parameter :: PTHREAD_NOFLOAT       = int(z'8')

    integer(kind=c_int), parameter :: PTHREAD_CREATE_DETACHED = PTHREAD_DETACHED
    integer(kind=c_int), parameter :: PTHREAD_CREATE_JOINABLE = 0
    integer(kind=c_int), parameter :: PTHREAD_SCOPE_PROCESS   = 0
    integer(kind=c_int), parameter :: PTHREAD_EXPLICIT_SCHED  = 0

    integer(kind=c_int), parameter :: PTHREAD_PROCESS_PRIVATE = 0
    integer(kind=c_int), parameter :: PTHREAD_PROCESS_SHARED  = 1

    integer(kind=c_int), parameter :: PTHREAD_CANCEL_ENABLE       = 0
    integer(kind=c_int), parameter :: PTHREAD_CANCEL_DISABLE      = 1
    integer(kind=c_int), parameter :: PTHREAD_CANCEL_DEFERRED     = 0
    integer(kind=c_int), parameter :: PTHREAD_CANCEL_ASYNCHRONOUS = 2
    integer(kind=c_int), parameter :: PTHREAD_CANCELED            = 1

    integer(kind=c_int), parameter :: PTHREAD_MUTEX_ERRORCHECK  = 1 ! Default POSIX mutex.
    integer(kind=c_int), parameter :: PTHREAD_MUTEX_RECURSIVE   = 2 ! Recursive mutex.
    integer(kind=c_int), parameter :: PTHREAD_MUTEX_NORMAL      = 3 ! No error checking.
    integer(kind=c_int), parameter :: PTHREAD_MUTEX_ADAPTIVE_NP = 4 ! Adaptive mutex, spins briefly before blocking on lock.
    integer(kind=c_int), parameter :: PTHREAD_MUTEX_DEFAULT     = PTHREAD_MUTEX_ERRORCHECK

    integer, parameter :: PTHREAD_SIZE       = 8 ! 8 Bytes.
    integer, parameter :: PTHREAD_MUTEX_SIZE = 8 ! 8 Bytes.

#endif

    ! struct pthread_t
    type, bind(c), public :: c_pthread_t
        private
        character(kind=c_char) :: hidden(PTHREAD_SIZE)
    end type c_pthread_t

    ! struct pthread_mutex_t
    type, bind(c), public :: c_pthread_mutex_t
        private
        character(kind=c_char) :: hidden(PTHREAD_MUTEX_SIZE)
    end type c_pthread_mutex_t

    public :: c_pthread_cancel
    public :: c_pthread_create
    public :: c_pthread_detach
    public :: c_pthread_exit
    public :: c_pthread_join
    public :: c_pthread_mutex_destroy
    public :: c_pthread_mutex_init
    public :: c_pthread_mutex_lock
    public :: c_pthread_mutex_trylock
    public :: c_pthread_mutex_unlock
    public :: c_pthread_setcancelstate
    public :: c_pthread_setcanceltype

    interface
        ! int pthread_cancel(pthread_t thread)
        function c_pthread_cancel(thread) bind(c, name='pthread_cancel')
            import :: c_int, c_ptr, c_pthread_t
            implicit none
            type(c_pthread_t), intent(in), value :: thread
            integer(kind=c_int)                  :: c_pthread_cancel
        end function c_pthread_cancel

        ! int pthread_create(pthread_t *thread, const pthread_attr_t *attr, void *(*start_routine) (void *), void *arg)
        function c_pthread_create(thread, attr, start_routine, arg) bind(c, name='pthread_create')
            import :: c_int, c_ptr, c_funptr, c_pthread_t
            implicit none
            type(c_pthread_t), intent(inout)     :: thread
            type(c_ptr),       intent(in), value :: attr
            type(c_funptr),    intent(in), value :: start_routine
            type(c_ptr),       intent(in), value :: arg
            integer(kind=c_int)                  :: c_pthread_create
        end function c_pthread_create

        ! int pthread_detach(pthread_t thread)
        function c_pthread_detach(thread) bind(c, name='pthread_detach')
            import :: c_int, c_ptr, c_pthread_t
            implicit none
            type(c_pthread_t), intent(in), value :: thread
            integer(kind=c_int)                  :: c_pthread_detach
        end function c_pthread_detach

        ! void pthread_exit(void *retval)
        subroutine c_pthread_exit(retval) bind(c, name='pthread_exit')
            import :: c_ptr
            implicit none
            type(c_ptr), intent(in), value :: retval
        end subroutine c_pthread_exit

        ! int pthread_join(pthread_t thread, void **value_ptr)
        function c_pthread_join(thread, value_ptr) bind(c, name='pthread_join')
            import :: c_int, c_ptr, c_pthread_t
            implicit none
            type(c_pthread_t), intent(in), value :: thread
            type(c_ptr),       intent(out)       :: value_ptr
            integer(kind=c_int)                  :: c_pthread_join
        end function c_pthread_join

        ! int pthread_mutex_destroy(pthread_mutex_t *mutex)
        function c_pthread_mutex_destroy(mutex) bind(c, name='pthread_mutex_destroy')
            import :: c_int, c_pthread_mutex_t
            implicit none
            type(c_pthread_mutex_t), intent(in) :: mutex
            integer(kind=c_int)                 :: c_pthread_mutex_destroy
        end function c_pthread_mutex_destroy

        ! int pthread_mutex_init(pthread_mutex_t *mutex, const pthread_mutexattr_t *attr)
        function c_pthread_mutex_init(mutex, attr) bind(c, name='pthread_mutex_init')
            import :: c_int, c_ptr, c_pthread_mutex_t
            implicit none
            type(c_pthread_mutex_t), intent(in)        :: mutex
            type(c_ptr),             intent(in), value :: attr
            integer(kind=c_int)                        :: c_pthread_mutex_init
        end function c_pthread_mutex_init

        ! int pthread_mutex_lock(pthread_mutex_t *mutex)
        function c_pthread_mutex_lock(mutex) bind(c, name='pthread_mutex_lock')
            import :: c_int, c_pthread_mutex_t
            implicit none
            type(c_pthread_mutex_t), intent(in) :: mutex
            integer(kind=c_int)                 :: c_pthread_mutex_lock
        end function c_pthread_mutex_lock

        ! int pthread_mutex_trylock(pthread_mutex_t *mutex)
        function c_pthread_mutex_trylock(mutex) bind(c, name='pthread_mutex_trylock')
            import :: c_int, c_pthread_mutex_t
            implicit none
            type(c_pthread_mutex_t), intent(in) :: mutex
            integer(kind=c_int)                 :: c_pthread_mutex_trylock
        end function c_pthread_mutex_trylock

        ! int pthread_mutex_unlock(pthread_mutex_t *mutex)
        function c_pthread_mutex_unlock(mutex) bind(c, name='pthread_mutex_unlock')
            import :: c_int, c_pthread_mutex_t
            implicit none
            type(c_pthread_mutex_t), intent(in) :: mutex
            integer(kind=c_int)                 :: c_pthread_mutex_unlock
        end function c_pthread_mutex_unlock

        ! int pthread_setcancelstate(int state, int *oldstate)
        function c_pthread_setcancelstate(state, oldstate) bind(c, name='pthread_setcancelstate')
            import :: c_int
            implicit none
            integer(kind=c_int), intent(in), value :: state
            integer(kind=c_int), intent(out)       :: oldstate
            integer(kind=c_int)                    :: c_pthread_setcancelstate
        end function c_pthread_setcancelstate

        ! int pthread_setcanceltype(int type, int *oldtype)
        function c_pthread_setcanceltype(type, oldtype) bind(c, name='pthread_setcanceltype')
            import :: c_int
            implicit none
            integer(kind=c_int), intent(in), value :: type
            integer(kind=c_int), intent(out)       :: oldtype
            integer(kind=c_int)                    :: c_pthread_setcanceltype
        end function c_pthread_setcanceltype
    end interface
end module unix_pthread
