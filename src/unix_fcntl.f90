! unix_fcntl.f90
module unix_fcntl
    use, intrinsic :: iso_c_binding
    use :: unix_types
    implicit none
    private

    public :: c_open

#if defined (__linux__)

    integer(kind=c_int), parameter, public :: O_ACCMODE  = int(o'0003')
    integer(kind=c_int), parameter, public :: O_RDONLY   = int(o'00')
    integer(kind=c_int), parameter, public :: O_WRONLY   = int(o'01')
    integer(kind=c_int), parameter, public :: O_RDWR     = int(o'02')
    integer(kind=c_int), parameter, public :: O_CREAT    = int(o'0100')
    integer(kind=c_int), parameter, public :: O_EXCL     = int(o'0200')
    integer(kind=c_int), parameter, public :: O_NOCTTY   = int(o'0400')
    integer(kind=c_int), parameter, public :: O_TRUNC    = int(o'01000')
    integer(kind=c_int), parameter, public :: O_APPEND   = int(o'02000')
    integer(kind=c_int), parameter, public :: O_NONBLOCK = int(o'04000')
    integer(kind=c_int), parameter, public :: O_NDELAY   = O_NONBLOCK
    integer(kind=c_int), parameter, public :: O_SYNC     = int(o'04010000')
    integer(kind=c_int), parameter, public :: O_FSYNC    = O_SYNC
    integer(kind=c_int), parameter, public :: O_ASYNC    = int(o'020000')

#elif defined (__FreeBSD__)

    integer(kind=c_int), parameter, public :: O_RDONLY   = int(z'0000') ! Open for reading only.
    integer(kind=c_int), parameter, public :: O_WRONLY   = int(z'0001') ! Open for writing only.
    integer(kind=c_int), parameter, public :: O_RDWR     = int(z'0002') ! Open for reading and writing.
    integer(kind=c_int), parameter, public :: O_ACCMODE  = int(z'0003') ! Mask for above modes.

    integer(kind=c_int), parameter, public :: O_SYNC     = int(z'0008') ! POSIX synonym for O_FSYNC.
    integer(kind=c_int), parameter, public :: O_CREAT    = int(z'0200') ! Create if nonexistent.
    integer(kind=c_int), parameter, public :: O_TRUNC    = int(z'0400') ! Truncate to zero length.
    integer(kind=c_int), parameter, public :: O_EXCL     = int(z'0800') ! Error if already exists.

    integer(kind=c_int), parameter, public :: O_CLOEXEC  = int(z'00100000')
    integer(kind=c_int), parameter, public :: O_NONBLOCK = int(z'0004') ! No delay.
    integer(kind=c_int), parameter, public :: O_APPEND   = int(z'0008') ! Set append mode.

    integer(kind=c_int), parameter, public :: O_NOCTTY   = int(z'8000') ! Don't assign controlling terminal.
#endif

    interface
        ! int open(const char *pathname, int flags, mode_t mode)
        function c_open(pathname, flags, mode) bind(c, name='open')
            import :: c_char, c_int, c_mode_t
            character(kind=c_char), intent(in)        :: pathname
            integer(kind=c_int),    intent(in), value :: flags
            integer(kind=c_mode_t), intent(in), value :: mode
            integer(kind=c_int)                       :: c_open
        end function c_open
    end interface
end module unix_fcntl
