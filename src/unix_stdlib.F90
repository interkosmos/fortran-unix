! unix_stdlib.f90
module unix_stdlib
    use, intrinsic :: iso_c_binding
    implicit none
    private

    public :: c_free

    interface
        ! void free(void *ptr)
        subroutine c_free(ptr) bind(c, name='free')
            import :: c_ptr
            implicit none
            type(c_ptr), intent(in), value :: ptr
        end subroutine c_free
    end interface
end module unix_stdlib
