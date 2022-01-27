! unix_stat.F90
module unix_stat
    use, intrinsic :: iso_c_binding
    use :: unix_types
    implicit none
    private

    public :: c_mkdir
    public :: c_mkfifo
    public :: c_umask

#if defined (__linux__)

    integer(kind=c_int), parameter, public :: S_IRUSR = int(o'0400')
    integer(kind=c_int), parameter, public :: S_IWUSR = int(o'0200')
    integer(kind=c_int), parameter, public :: S_IXUSR = int(o'0100')
    integer(kind=c_int), parameter, public :: S_IRWXU = ior(ior(S_IRUSR, S_IWUSR), S_IXUSR)

    integer(kind=c_int), parameter, public :: S_IRWXG = shiftr(S_IRWXU, 3)
    integer(kind=c_int), parameter, public :: S_IRGRP = shiftr(S_IRUSR, 3)
    integer(kind=c_int), parameter, public :: S_IWGRP = shiftr(S_IWUSR, 3)
    integer(kind=c_int), parameter, public :: S_IXGRP = shiftr(S_IXUSR, 3)

    integer(kind=c_int), parameter, public :: S_IRWXO = shiftr(S_IRWXG, 3)
    integer(kind=c_int), parameter, public :: S_IROTH = shiftr(S_IRGRP, 3)
    integer(kind=c_int), parameter, public :: S_IWOTH = shiftr(S_IWGRP, 3)
    integer(kind=c_int), parameter, public :: S_IXOTH = shiftr(S_IXGRP, 3)

    integer(kind=c_int), parameter, public :: S_IFMT   = int(o'0170000')
    integer(kind=c_int), parameter, public :: S_IFSOCK = int(o'0140000')
    integer(kind=c_int), parameter, public :: S_IFLNK  = int(o'0120000')
    integer(kind=c_int), parameter, public :: S_IFREG  = int(o'0100000')
    integer(kind=c_int), parameter, public :: S_IFBLK  = int(o'0060000')
    integer(kind=c_int), parameter, public :: S_IFDIR  = int(o'0040000')
    integer(kind=c_int), parameter, public :: S_IFCHR  = int(o'0020000')
    integer(kind=c_int), parameter, public :: S_IFIFO  = int(o'0010000')
    integer(kind=c_int), parameter, public :: S_ISUID  = int(o'0004000')
    integer(kind=c_int), parameter, public :: S_ISGID  = int(o'0002000')
    integer(kind=c_int), parameter, public :: S_ISVTX  = int(o'0001000')


#elif defined (__FreeBSD__)

    integer(kind=c_int), parameter, public :: S_IRWXU = int(o'0000700')
    integer(kind=c_int), parameter, public :: S_IRUSR = int(o'0000400')
    integer(kind=c_int), parameter, public :: S_IWUSR = int(o'0000200')
    integer(kind=c_int), parameter, public :: S_IXUSR = int(o'0000100')

    integer(kind=c_int), parameter, public :: S_IRWXG = int(o'0000070')
    integer(kind=c_int), parameter, public :: S_IRGRP = int(o'0000040')
    integer(kind=c_int), parameter, public :: S_IWGRP = int(o'0000020')
    integer(kind=c_int), parameter, public :: S_IXGRP = int(o'0000010')

    integer(kind=c_int), parameter, public :: S_IRWXO = int(o'0000007')
    integer(kind=c_int), parameter, public :: S_IROTH = int(o'0000004')
    integer(kind=c_int), parameter, public :: S_IWOTH = int(o'0000002')
    integer(kind=c_int), parameter, public :: S_IXOTH = int(o'0000001')

    integer(kind=c_int), parameter, public :: S_IFMT   = int(o'0170000') ! type of file mask
    integer(kind=c_int), parameter, public :: S_IFIFO  = int(o'0010000') ! named pipe (fifo)
    integer(kind=c_int), parameter, public :: S_IFCHR  = int(o'0020000') ! character special
    integer(kind=c_int), parameter, public :: S_IFDIR  = int(o'0040000') ! directory
    integer(kind=c_int), parameter, public :: S_IFBLK  = int(o'0060000') ! block special
    integer(kind=c_int), parameter, public :: S_IFREG  = int(o'0100000') ! regular
    integer(kind=c_int), parameter, public :: S_IFLNK  = int(o'0120000') ! symbolic link
    integer(kind=c_int), parameter, public :: S_IFSOCK = int(o'0140000') ! socket
    integer(kind=c_int), parameter, public :: S_ISVTX  = int(o'0001000') ! save swapped text even after use
    integer(kind=c_int), parameter, public :: S_IFWHT  = int(o'0160000') ! whiteout

#endif

    interface
        ! int mkdir(const char *path, mode_t mode)
        function c_mkdir(path, mode) bind(c, name='mkdir')
            import :: c_char, c_int, c_mode_t
            implicit none
            character(kind=c_char), intent(in)        :: path
            integer(kind=c_mode_t), intent(in), value :: mode
            integer(kind=c_int)                       :: c_mkdir
        end function c_mkdir

        ! int mkfifo(const char *path, mode_t mode)
        function c_mkfifo(path, mode) bind(c, name='mkfifo')
            import :: c_char, c_int, c_mode_t
            implicit none
            character(kind=c_char), intent(in)        :: path
            integer(kind=c_mode_t), intent(in), value :: mode
            integer(kind=c_int)                       :: c_mkfifo
        end function c_mkfifo

        ! mode_t umask(mode_t numask)
        function c_umask(numask) bind(c, name='umask')
            import :: c_mode_t
            implicit none
            integer(kind=c_mode_t), intent(in), value :: numask
            integer(kind=c_mode_t)                    :: c_umask
        end function c_umask
    end interface
end module unix_stat
