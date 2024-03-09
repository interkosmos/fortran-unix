! unix_ioctl.F90
!
! Author:  Philipp Engel
! Licence: ISC
module unix_ioctl
    use, intrinsic :: iso_c_binding
    use :: unix_types
    implicit none
    private

    public :: c_ioctl

    interface
        ! int c_ioctl(int fd, unsigned long request, void *arg)
        function c_ioctl(fd, request, arg) bind(c, name='c_ioctl')
            import :: c_int, c_ptr, c_unsigned_long
            implicit none
            integer(kind=c_int),           intent(in), value :: fd
            integer(kind=c_unsigned_long), intent(in), value :: request
            type(c_ptr),                   intent(in), value :: arg
            integer(kind=c_int)                              :: c_ioctl
        end function c_ioctl
    end interface
end module unix_ioctl
