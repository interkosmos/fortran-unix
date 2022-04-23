! unix_pthread.F90
module unix_pthread
    use, intrinsic :: iso_c_binding
    implicit none
    private

    public :: c_pthread_create
    public :: c_pthread_detach
    public :: c_pthread_join
    public :: c_pthread_mutex_destroy
    public :: c_pthread_mutex_init
    public :: c_pthread_mutex_lock
    public :: c_pthread_mutex_trylock
    public :: c_pthread_mutex_unlock

    integer, parameter :: PTHREAD_SIZE       = 8    ! 8 Bytes.

#if defined (__linux__)

    integer, parameter :: PTHREAD_MUTEX_SIZE = 40   ! 40 Bytes.

#elif defined (__FreeBSD__)

    integer, parameter :: PTHREAD_MUTEX_SIZE = 8    ! 8 Bytes.

#endif

    type, bind(c), public :: c_pthread_t
        private
        character(kind=c_char) :: hidden(PTHREAD_SIZE)
    end type c_pthread_t

    type, bind(c), public :: c_pthread_mutex_t
        private
        character(kind=c_char) :: hidden(PTHREAD_MUTEX_SIZE)
    end type c_pthread_mutex_t

    interface
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

        ! int pthread_join(pthread_t thread, void **value_ptr)
        function c_pthread_join(thread, value_ptr) bind(c, name='pthread_join')
            import :: c_int, c_ptr, c_pthread_t
            implicit none
            type(c_pthread_t), intent(in), value :: thread
            type(c_ptr),       intent(in)        :: value_ptr
            integer(kind=c_int)                  :: c_pthread_join
        end function c_pthread_join

        ! int pthread_mutex_destroy(pthread_mutex_t *mutex)
        function c_pthread_mutex_destroy(mutex) bind(c, name='pthread_mutex_destroy')
            import :: c_int, c_pthread_mutex_t
            implicit none
            type(c_pthread_mutex_t), intent(in) :: mutex
            integer(kind=c_int)                 :: c_pthread_mutex_destroy
        end function c_pthread_mutex_destroy

        ! int pthread_mutex_init(pthread_mutex_t *restrict mutex, const pthread_mutexattr_t *restrict attr)
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
    end interface
end module unix_pthread
