! unix_dirent.F90
module unix_dirent
    use, intrinsic :: iso_c_binding
    implicit none
    private

    public :: c_closedir
    public :: c_opendir
    public :: c_readdir

    integer(kind=c_int), parameter, public :: DT_UNKNOWN = 0
    integer(kind=c_int), parameter, public :: DT_FIFO    = 1
    integer(kind=c_int), parameter, public :: DT_CHR     = 2
    integer(kind=c_int), parameter, public :: DT_DIR     = 4
    integer(kind=c_int), parameter, public :: DT_BLK     = 6
    integer(kind=c_int), parameter, public :: DT_REG     = 8
    integer(kind=c_int), parameter, public :: DT_LNK     = 10
    integer(kind=c_int), parameter, public :: DT_SOCK    = 12
    integer(kind=c_int), parameter, public :: DT_WHT     = 14

#if defined (__linux__)

    type, bind(c), public :: c_dirent
        integer(kind=c_int64_t) :: d_ino
        integer(kind=c_int64_t) :: d_off
        integer(kind=c_int16_t) :: d_reclen
        integer(kind=c_int8_t)  :: d_type
        character(kind=c_char)  :: d_name(256)
    end type c_dirent

#elif defined (__FreeBSD__)

    type, bind(c), public :: c_dirent
        integer(kind=c_int64_t) :: d_fileno
        integer(kind=c_int64_t) :: d_off
        integer(kind=c_int16_t) :: d_reclen
        integer(kind=c_int8_t)  :: d_type
        integer(kind=c_int8_t)  :: d_namlen
        integer(kind=c_int32_t) :: d_pad0
        character(kind=c_char)  :: d_name(256)
    end type c_dirent

#endif

    interface
        ! int closedir(DIR *dirp)
        function c_closedir(dirp) bind(c, name='closedir')
            import :: c_int, c_ptr
            implicit none
            type(c_ptr), intent(in), value :: dirp
            integer(kind=c_int)            :: c_closedir
        end function c_closedir

        ! DIR *opendir(const char *filename)
        function c_opendir(filename) bind(c, name='opendir')
            import :: c_char, c_ptr
            implicit none
            character(kind=c_char), intent(in) :: filename
            type(c_ptr)                        :: c_opendir
        end function c_opendir

        ! struct dirent *readdir(DIR *dirp)
        function c_readdir(dirp) bind(c, name='readdir')
            import :: c_ptr
            implicit none
            type(c_ptr), intent(in), value :: dirp
            type(c_ptr)                    :: c_readdir
        end function c_readdir
    end interface
end module unix_dirent
