! unix_ioctl.F90
module unix_ioctl
    use, intrinsic :: iso_c_binding
    implicit none
    private

    public :: c_ioctl

    interface
        ! int ioctl(int fd, int cmd, int arg)
        function c_ioctl(fd, request, arg) bind(c, name='ioctl')
            import :: c_int, c_ptr
            implicit none
            integer(kind=c_int), intent(in), value :: fd
            integer(kind=c_int), intent(in), value :: request
            type(c_ptr),         intent(in), value :: arg
            integer(kind=c_int)                    :: c_ioctl
        end function c_ioctl
    end interface
end module unix_ioctl
