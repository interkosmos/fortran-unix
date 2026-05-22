! unix_dirent.F90
!
! Author:  Philipp Engel
! Licence: ISC
module unix_dirent
    use :: unix_types
    implicit none
    private

    integer(c_int), parameter, public :: DT_UNKNOWN = 0
    integer(c_int), parameter, public :: DT_FIFO    = 1
    integer(c_int), parameter, public :: DT_CHR     = 2
    integer(c_int), parameter, public :: DT_DIR     = 4
    integer(c_int), parameter, public :: DT_BLK     = 6
    integer(c_int), parameter, public :: DT_REG     = 8
    integer(c_int), parameter, public :: DT_LNK     = 10
    integer(c_int), parameter, public :: DT_SOCK    = 12
    integer(c_int), parameter, public :: DT_WHT     = 14

#if defined (__linux__)

    ! struct dirent
    type, bind(c), public :: c_dirent
        integer(c_int64_t) :: d_ino         = 0_c_int64_t
        integer(c_int64_t) :: d_off         = 0_c_int64_t
        integer(c_int16_t) :: d_reclen      = 0_c_int16_t
        integer(c_int8_t)  :: d_type        = 0_c_int8_t
        character(c_char)  :: d_name(0:255) = c_null_char
    end type c_dirent

#elif defined (__FreeBSD__)

    ! struct dirent
    type, bind(c), public :: c_dirent
        integer(c_int64_t)          :: d_fileno      = 0_c_int64_t
        integer(c_int64_t)          :: d_off         = 0_c_int64_t
        integer(c_int16_t)          :: d_reclen      = 0_c_int16_t
        integer(c_int8_t)           :: d_type        = 0_c_int8_t
        integer(c_int8_t)           :: d_namlen      = 0_c_int8_t
        integer(c_int32_t), private :: padding       = 0_c_int32_t
        character(c_char)           :: d_name(0:255) = c_null_char
    end type c_dirent

#endif

    public :: c_closedir
    public :: c_opendir
    public :: c_readdir

    interface
        ! int closedir(DIR *dirp)
        function c_closedir(dirp) bind(c, name='closedir')
            import :: c_int, c_ptr
            implicit none
            type(c_ptr), intent(in), value :: dirp
            integer(c_int)                 :: c_closedir
        end function c_closedir

        ! DIR *opendir(const char *filename)
        function c_opendir(filename) bind(c, name='opendir')
            import :: c_char, c_ptr
            implicit none
            character(c_char), intent(in) :: filename
            type(c_ptr)                   :: c_opendir
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
