! unix_fcntl.F90
!
! Author:  Philipp Engel
! Licence: ISC
module unix_fcntl
    use :: unix_types
    implicit none
    private

#if defined (__linux__)

    integer(c_int), parameter, public :: AT_EACCESS          = int(z'200')
    integer(c_int), parameter, public :: AT_SYMLINK_NOFOLLOW = int(z'100')
    integer(c_int), parameter, public :: AT_SYMLINK_FOLLOW   = int(z'400')
    integer(c_int), parameter, public :: AT_REMOVEDIR        = int(z'200')
    integer(c_int), parameter, public :: AT_EMPTY_PATH       = int(z'1000')

    integer(c_int), parameter, public :: O_ACCMODE  = int(o'0003')
    integer(c_int), parameter, public :: O_RDONLY   = int(o'00')
    integer(c_int), parameter, public :: O_WRONLY   = int(o'01')
    integer(c_int), parameter, public :: O_RDWR     = int(o'02')
    integer(c_int), parameter, public :: O_CREAT    = int(o'0100')
    integer(c_int), parameter, public :: O_EXCL     = int(o'0200')
    integer(c_int), parameter, public :: O_NOCTTY   = int(o'0400')
    integer(c_int), parameter, public :: O_TRUNC    = int(o'01000')
    integer(c_int), parameter, public :: O_APPEND   = int(o'02000')
    integer(c_int), parameter, public :: O_NONBLOCK = int(o'04000')
    integer(c_int), parameter, public :: O_NDELAY   = O_NONBLOCK
    integer(c_int), parameter, public :: O_SYNC     = int(o'04010000')
    integer(c_int), parameter, public :: O_FSYNC    = O_SYNC
    integer(c_int), parameter, public :: O_ASYNC    = int(o'020000')

    integer(c_int), parameter, public :: O_CLOEXEC  = int(o'02000000')

#elif defined (__FreeBSD__)

    integer(c_int), parameter, public :: AT_EACCESS          = int(z'0100') ! Check access using effective user and group ID.
    integer(c_int), parameter, public :: AT_SYMLINK_NOFOLLOW = int(z'0200') ! Do not follow symbolic links.
    integer(c_int), parameter, public :: AT_SYMLINK_FOLLOW   = int(z'0400') ! Follow symbolic link.
    integer(c_int), parameter, public :: AT_REMOVEDIR        = int(z'0800') ! Remove directory instead of file.
    integer(c_int), parameter, public :: AT_EMPTY_PATH       = int(z'4000') ! Operate on dirfd if path is empty.

    integer(c_int), parameter, public :: O_RDONLY   = int(z'0000') ! Open for reading only.
    integer(c_int), parameter, public :: O_WRONLY   = int(z'0001') ! Open for writing only.
    integer(c_int), parameter, public :: O_RDWR     = int(z'0002') ! Open for reading and writing.
    integer(c_int), parameter, public :: O_ACCMODE  = int(z'0003') ! Mask for above modes.
    integer(c_int), parameter, public :: O_SYNC     = int(z'0008') ! POSIX synonym for O_FSYNC.
    integer(c_int), parameter, public :: O_CREAT    = int(z'0200') ! Create if nonexistent.
    integer(c_int), parameter, public :: O_TRUNC    = int(z'0400') ! Truncate to zero length.
    integer(c_int), parameter, public :: O_EXCL     = int(z'0800') ! Error if already exists.
    integer(c_int), parameter, public :: O_NONBLOCK = int(z'0004') ! No delay.
    integer(c_int), parameter, public :: O_NDELAY   = O_NONBLOCK
    integer(c_int), parameter, public :: O_APPEND   = int(z'0008') ! Set append mode.
    integer(c_int), parameter, public :: O_NOCTTY   = int(z'8000') ! Don't assign controlling terminal.

    integer(c_int), parameter, public :: O_CLOEXEC  = int(z'00100000')

#endif

    integer(c_int), parameter, public :: F_DUPFD = 0 ! Duplicate file descriptor.
    integer(c_int), parameter, public :: F_GETFD = 1 ! Get file descriptor flags.
    integer(c_int), parameter, public :: F_SETFD = 2 ! Set file descriptor flags.
    integer(c_int), parameter, public :: F_GETFL = 3 ! Get file status flags.
    integer(c_int), parameter, public :: F_SETFL = 4 ! Set file status flags.

    public :: c_fcntl
    public :: c_open

    interface
        ! int fcntl(int fd, int cmd, ...)
        function c_fcntl(fd, cmd, arg) bind(c, name='c_fcntl')
            import :: c_int, c_ptr
            implicit none
            integer(c_int), intent(in), value :: fd
            integer(c_int), intent(in), value :: cmd
            integer(c_int), intent(in), value :: arg
            integer(c_int)                    :: c_fcntl
        end function c_fcntl

        ! int open(const char *pathname, int flags, mode_t mode)
        function c_open(pathname, flags, mode) bind(c, name='c_open')
            import :: c_char, c_int, c_mode_t
            implicit none
            character(c_char), intent(in)        :: pathname
            integer(c_int),    intent(in), value :: flags
            integer(c_mode_t), intent(in), value :: mode
            integer(c_int)                       :: c_open
        end function c_open
    end interface
end module unix_fcntl
