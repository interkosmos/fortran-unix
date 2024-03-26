! unix_stdlib.F90
!
! Author:  Philipp Engel
! Licence: ISC
module unix_stdlib
    use, intrinsic :: iso_c_binding
    implicit none
    private

    integer(kind=c_int), parameter, public :: EXIT_SUCCESS = 0
    integer(kind=c_int), parameter, public :: EXIT_FAILURE = 1

    public :: c_exit
    public :: c_free

    interface
        ! void exit(int status)
        subroutine c_exit(status) bind(c, name='exit')
            import :: c_int
            implicit none
            integer(kind=c_int), intent(in), value :: status
        end subroutine c_exit

        ! void free(void *ptr)
        subroutine c_free(ptr) bind(c, name='free')
            import :: c_ptr
            implicit none
            type(c_ptr), intent(in), value :: ptr
        end subroutine c_free
    end interface
end module unix_stdlib
