! unix_unistd.f90
module unix_unistd
    use, intrinsic :: iso_c_binding
    use :: unix_types
    implicit none
    private

    public :: c_close
    public :: c_fork
    public :: c_pipe
    public :: c_read
    public :: c_unlink
    public :: c_usleep
    public :: c_write

    interface
        ! int close(int fd)
        function c_close(fd) bind(c, name='close')
            import :: c_int
            integer(kind=c_int), intent(in), value :: fd
            integer(kind=c_int)                    :: c_close
        end function c_close

        ! pid_t fork(void)
        function c_fork() bind(c, name='fork')
            import :: c_pid_t
            integer(kind=c_pid_t) :: c_fork
        end function c_fork

        ! int pipe(int fd[2])
        function c_pipe(fd) bind(c, name='pipe')
            import :: c_int
            integer(kind=c_int), intent(in) :: fd(2)
            integer(kind=c_int)             :: c_pipe
        end function c_pipe

        ! ssize_t read(int fd, void *buf, size_t nbyte)
        function c_read(fd, buf, nbyte) bind(c, name='read')
            import :: c_int, c_ptr, c_size_t
            integer(kind=c_int),    intent(in), value :: fd
            type(c_ptr),            intent(in), value :: buf
            integer(kind=c_size_t), intent(in), value :: nbyte
            integer(kind=c_size_t)                    :: c_read
        end function c_read

        ! int unlink(const char *path)
        function c_unlink(path) bind(c, name='unlink')
            import :: c_char, c_int
            character(kind=c_char), intent(in) :: path
            integer(kind=c_int)                :: c_unlink
        end function c_unlink

        ! int usleep(useconds_t useconds)
        function c_usleep(useconds) bind(c, name='usleep')
            import :: c_int, c_int32_t
            integer(kind=c_int32_t), value :: useconds
            integer(kind=c_int)            :: c_usleep
        end function c_usleep

        ! ssize_t write(int fd, void *buf, size_t nbyte)
        function c_write(fd, buf, nbyte) bind(c, name='write')
            import :: c_int, c_size_t, c_ptr
            integer(kind=c_int),    intent(in), value :: fd
            type(c_ptr),            intent(in), value :: buf
            integer(kind=c_size_t), intent(in), value :: nbyte
            integer(kind=c_size_t)                    :: c_write
        end function c_write
    end interface
end module unix_unistd
