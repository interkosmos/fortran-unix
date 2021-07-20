! unix_stat.f90
module unix_stat
    use, intrinsic :: iso_c_binding
    use :: unix_types
    implicit none
    private

    public :: c_mkdir
    public :: c_mkfifo

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

#endif

    interface
        ! int mkdir(const char *path, mode_t mode)
        function c_mkdir(path, mode) bind(c, name='mkdir')
            import :: c_char, c_int, c_mode_t
            character(kind=c_char), intent(in)        :: path
            integer(kind=c_mode_t), intent(in), value :: mode
            integer(kind=c_int)                       :: c_mkdir
        end function c_mkdir

        ! int mkfifo(const char *path, mode_t mode)
        function c_mkfifo(path, mode) bind(c, name='mkfifo')
            import :: c_char, c_int, c_mode_t
            character(kind=c_char), intent(in)        :: path
            integer(kind=c_mode_t), intent(in), value :: mode
            integer(kind=c_int)                       :: c_mkfifo
        end function c_mkfifo
    end interface
end module unix_stat
