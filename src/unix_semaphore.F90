! unix_semaphore.F90
module unix_semaphore
    use, intrinsic :: iso_c_binding
    use :: unix_time
    use :: unix_types
    implicit none
    private

#if defined (__linux__)

    integer, parameter :: SEM_SIZE = 32

#elif defined (__FreeBSD__)

    integer, parameter :: SEM_SIZE = 16

#endif

    type, bind(c), public :: c_sem_t
        character(kind=c_char) :: hidden(SEM_SIZE)
    end type c_sem_t

    public :: c_sem_close     ! named
    public :: c_sem_destroy   ! unnamed
    public :: c_sem_getvalue  ! named, unnamed
    public :: c_sem_init      ! unnamed
    public :: c_sem_open      ! named
    public :: c_sem_post      ! named, unnamed
    public :: c_sem_timedwait ! named, unnamed
    public :: c_sem_trywait   ! named, unnamed
    public :: c_sem_unlink    ! named
    public :: c_sem_wait      ! named, unnamed

    interface
        ! int sem_close(sem_t *sem)
        function c_sem_close(sem) bind(c, name='sem_close')
            import :: c_int, c_ptr
            implicit none
            type(c_ptr), intent(in), value :: sem
            integer(kind=c_int)            :: c_sem_close
        end function c_sem_close

        ! int sem_destroy(sem_t *sem)
        function c_sem_destroy(sem) bind(c, name='sem_destroy')
            import :: c_int, c_sem_t
            implicit none
            type(c_sem_t), intent(in) :: sem
            integer(kind=c_int)       :: c_sem_destroy
        end function c_sem_destroy

        ! int sem_getvalue(sem_t *sem, int *value)
        function c_sem_getvalue(sem, value) bind(c, name='sem_getvalue')
            import :: c_int, c_ptr
            implicit none
            type(c_ptr),         intent(in), value :: sem
            integer(kind=c_int), intent(out)       :: value
            integer(kind=c_int)                    :: c_sem_getvalue
        end function c_sem_getvalue

        ! int sem_init(sem_t *sem, int, unsigned int value)
        function c_sem_init(sem, value) bind(c, name='sem_init')
            import :: c_int, c_sem_t, c_unsigned_int
            implicit none
            type(c_sem_t),                intent(in)        :: sem
            integer(kind=c_unsigned_int), intent(in), value :: value
            integer(kind=c_int)                             :: c_sem_init
        end function c_sem_init

        ! sem_t *semsem_open(const char *name, int oflag, mode_t mode, unsigned int value)
        function c_sem_open(name, oflag, mode, value) bind(c, name='sem_open')
            import :: c_char, c_int, c_mode_t, c_ptr, c_unsigned_int
            implicit none
            character(kind=c_char),       intent(in)        :: name
            integer(kind=c_int),          intent(in), value :: oflag
            integer(kind=c_mode_t),       intent(in), value :: mode
            integer(kind=c_unsigned_int), intent(in), value :: value
            type(c_ptr)                                     :: c_sem_open
        end function c_sem_open

        ! int sem_post(sem_t *sem)
        function c_sem_post(sem) bind(c, name='sem_post')
            import :: c_int, c_ptr
            implicit none
            type(c_ptr), intent(in), value :: sem
            integer(kind=c_int)            :: c_sem_post
        end function c_sem_post

        ! int sem_timedwait(sem_t *sem, const struct timespec *abs_timeout)
        function c_sem_timedwait(sem, abs_timeout) bind(c, name='sem_timedwait')
            import :: c_int, c_ptr, c_timespec
            implicit none
            type(c_ptr),      intent(in), value :: sem
            type(c_timespec), intent(in)        :: abs_timeout
            integer(kind=c_int)                 :: c_sem_timedwait
        end function c_sem_timedwait

        ! int sem_trywait(sem_t *sem)
        function c_sem_trywait(sem) bind(c, name='sem_trywait')
            import :: c_int, c_ptr
            implicit none
            type(c_ptr), intent(in), value :: sem
            integer(kind=c_int)            :: c_sem_trywait
        end function c_sem_trywait

        ! int sem_unlink(const char *name)
        function c_sem_unlink(name) bind(c, name='sem_unlink')
            import :: c_char, c_int
            implicit none
            character(kind=c_char), intent(in) :: name
            integer(kind=c_int)                :: c_sem_unlink
        end function c_sem_unlink

        ! int sem_wait(sem_t *sem)
        function c_sem_wait(sem) bind(c, name='sem_wait')
            import :: c_int, c_ptr
            implicit none
            type(c_ptr), intent(in), value :: sem
            integer(kind=c_int)            :: c_sem_wait
        end function c_sem_wait
    end interface
end module unix_semaphore
