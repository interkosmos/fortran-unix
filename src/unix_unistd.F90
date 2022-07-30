! unix_unistd.F90
module unix_unistd
    use, intrinsic :: iso_c_binding
    use :: unix_types
    implicit none
    private

    integer(kind=c_int), parameter, public :: c_useconds_t = c_int32_t

    integer(kind=c_int), parameter, public :: STDIN_FILENO  = 0
    integer(kind=c_int), parameter, public :: STDOUT_FILENO = 1
    integer(kind=c_int), parameter, public :: STDERR_FILENO = 2

    public :: c_chdir
    public :: c_close
    public :: c_dup
    public :: c_dup2
    public :: c_execl
    public :: c_fork
    public :: c_getpid
    public :: c_pipe
    public :: c_read
    public :: c_setsid
    public :: c_unlink
    public :: c_usleep
    public :: c_write

    interface
        ! int chdir(const char *path)
        function c_chdir(path) bind(c, name='chdir')
            import :: c_int, c_char
            implicit none
            character(kind=c_char), intent(in) :: path
            integer(kind=c_int)                :: c_chdir
        end function c_chdir

        ! int close(int fd)
        function c_close(fd) bind(c, name='close')
            import :: c_int
            implicit none
            integer(kind=c_int), intent(in), value :: fd
            integer(kind=c_int)                    :: c_close
        end function c_close

        ! int dup(int oldfd)
        function c_dup(old_fd) bind(c, name='dup')
            import :: c_int
            implicit none
            integer(kind=c_int), intent(in), value :: old_fd
            integer(kind=c_int)                    :: c_dup
        end function c_dup

        ! int dup2(int oldfd, int newfd)
        function c_dup2(old_fd, new_fd) bind(c, name='dup2')
            import :: c_int
            implicit none
            integer(kind=c_int), intent(in), value :: old_fd
            integer(kind=c_int), intent(in), value :: new_fd
            integer(kind=c_int)                    :: c_dup2
        end function c_dup2

        ! int execl(const char *path, const char *arg, ...)
        function c_execl(path, arg1, arg2, arg3, ptr) bind(c, name='execl')
            import :: c_char, c_int, c_ptr
            implicit none
            character(kind=c_char), intent(in)        :: path
            character(kind=c_char), intent(in)        :: arg1
            character(kind=c_char), intent(in)        :: arg2
            character(kind=c_char), intent(in)        :: arg3
            type(c_ptr),            intent(in), value :: ptr
            integer(kind=c_int)                       :: c_execl
        end function c_execl

        ! pid_t fork(void)
        function c_fork() bind(c, name='fork')
            import :: c_pid_t
            implicit none
            integer(kind=c_pid_t) :: c_fork
        end function c_fork

        ! pid_t fork(void)
        function c_getpid() bind(c, name='getpid')
            import :: c_pid_t
            implicit none
            integer(kind=c_pid_t) :: c_getpid
        end function c_getpid

        ! int pipe(int fd[2])
        function c_pipe(fd) bind(c, name='pipe')
            import :: c_int
            implicit none
            integer(kind=c_int), intent(in) :: fd(2)
            integer(kind=c_int)             :: c_pipe
        end function c_pipe

        ! ssize_t read(int fd, void *buf, size_t nbyte)
        function c_read(fd, buf, nbyte) bind(c, name='read')
            import :: c_int, c_ptr, c_size_t
            implicit none
            integer(kind=c_int),    intent(in), value :: fd
            type(c_ptr),            intent(in), value :: buf
            integer(kind=c_size_t), intent(in), value :: nbyte
            integer(kind=c_size_t)                    :: c_read
        end function c_read

        ! pid_t setsid(void)
        function c_setsid() bind(c, name='setsid')
            import :: c_pid_t
            implicit none
            integer(kind=c_pid_t) :: c_setsid
        end function c_setsid

        ! int unlink(const char *path)
        function c_unlink(path) bind(c, name='unlink')
            import :: c_char, c_int
            implicit none
            character(kind=c_char), intent(in) :: path
            integer(kind=c_int)                :: c_unlink
        end function c_unlink

        ! int usleep(useconds_t useconds)
        function c_usleep(useconds) bind(c, name='usleep')
            import :: c_int, c_useconds_t
            implicit none
            integer(kind=c_useconds_t), value :: useconds
            integer(kind=c_int)               :: c_usleep
        end function c_usleep

        ! ssize_t write(int fd, void *buf, size_t nbyte)
        function c_write(fd, buf, nbyte) bind(c, name='write')
            import :: c_int, c_size_t, c_ptr
            implicit none
            integer(kind=c_int),    intent(in), value :: fd
            type(c_ptr),            intent(in), value :: buf
            integer(kind=c_size_t), intent(in), value :: nbyte
            integer(kind=c_size_t)                    :: c_write
        end function c_write
    end interface
end module unix_unistd
