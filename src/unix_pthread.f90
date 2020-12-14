! unix_pthread.f90
module unix_pthread
    use, intrinsic :: iso_c_binding
    implicit none
    private

    public :: c_pthread_create
    public :: c_pthread_join

    integer, parameter :: SIZE_OF_TYPE = 2

    type, bind(c), public :: c_pthread_t
        private
        integer(kind=c_int) :: hidden(SIZE_OF_TYPE)
    end type c_pthread_t

    interface
        ! int pthread_create(pthread_t *thread, const pthread_attr_t *attr, void *(*start_routine) (void *), void *arg)
        function c_pthread_create(thread, attr, start_routine, arg) bind(c, name='pthread_create')
            import :: c_int, c_ptr, c_funptr, c_pthread_t
            type(c_pthread_t), intent(inout)     :: thread
            type(c_ptr),       intent(in), value :: attr
            type(c_funptr),    intent(in), value :: start_routine
            type(c_ptr),       intent(in), value :: arg
            integer(kind=c_int)                  :: c_pthread_create
        end function c_pthread_create

        ! int pthread_join(pthread_t thread, void **value_ptr)
        function c_pthread_join(thread, value_ptr) bind(c, name='pthread_join')
            import :: c_int, c_ptr, c_pthread_t
            type(c_pthread_t), intent(in), value :: thread
            type(c_ptr),       intent(in)        :: value_ptr
            integer(kind=c_int)                  :: c_pthread_join
        end function c_pthread_join
    end interface
end module unix_pthread
