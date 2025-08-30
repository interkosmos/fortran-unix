! unix_ftw.F90
!
! Author:  Philipp Engel
! Licence: ISC
module unix_ftw
    use, intrinsic :: iso_c_binding
    implicit none
    private

#if defined (__linux__)

    integer(kind=c_int), parameter, public :: FTW_F   = 0
    integer(kind=c_int), parameter, public :: FTW_D   = 1
    integer(kind=c_int), parameter, public :: FTW_DNR = 2
    integer(kind=c_int), parameter, public :: FTW_NS  = 3
    integer(kind=c_int), parameter, public :: FTW_SL  = 4
    integer(kind=c_int), parameter, public :: FTW_DP  = 5
    integer(kind=c_int), parameter, public :: FTW_SLN = 6

    integer(kind=c_int), parameter, public :: FTW_PHYS         = 1
    integer(kind=c_int), parameter, public :: FTW_MOUNT        = 2
    integer(kind=c_int), parameter, public :: FTW_CHDIR        = 4
    integer(kind=c_int), parameter, public :: FTW_DEPTH        = 8
    integer(kind=c_int), parameter, public :: FTW_ACTIONRETVAL = 16

#elif defined (__FreeBSD__)

    integer(kind=c_int), parameter, public :: FTW_F   = 0 ! File.
    integer(kind=c_int), parameter, public :: FTW_D   = 1 ! Directory.
    integer(kind=c_int), parameter, public :: FTW_DNR = 2 ! Directory without read permission.
    integer(kind=c_int), parameter, public :: FTW_DP  = 3 ! Directory with subdirectories visited.
    integer(kind=c_int), parameter, public :: FTW_NS  = 4 ! Unknown type; stat() failed.
    integer(kind=c_int), parameter, public :: FTW_SL  = 5 ! Symbolic link.
    integer(kind=c_int), parameter, public :: FTW_SLN = 6 ! Sym link that names a nonexistent file.

    integer(kind=c_int), parameter, public :: FTW_PHYS  = int(z'01') ! Physical walk, don't follow sym links.
    integer(kind=c_int), parameter, public :: FTW_MOUNT = int(z'02') ! The walk does not cross a mount point.
    integer(kind=c_int), parameter, public :: FTW_DEPTH = int(z'04') ! Subdirs visited before the dir itself.
    integer(kind=c_int), parameter, public :: FTW_CHDIR = int(z'08') ! Change to a directory before reading it.

#endif

    ! struct FTW
    type, bind(c), public :: c_ftw_type
        integer(kind=c_int) :: base  = 0
        integer(kind=c_int) :: level = 0
    end type c_ftw_type

    public :: c_nftw

    interface
        ! int nftw(const char *path, int (*fn)(const char *, const struct stat *, int, struct FTW *), int maxfds, int flags)
        function c_nftw(path, fn, maxfds, flags) bind(c, name='ftw')
            import :: c_char, c_funptr, c_int
            implicit none
            character(kind=c_char), intent(in)        :: path
            type(c_funptr),         intent(in), value :: fn
            integer(kind=c_int),    intent(in), value :: maxfds
            integer(kind=c_int),    intent(in), value :: flags
            integer(kind=c_int)                       :: c_nftw
        end function c_nftw
    end interface
end module unix_ftw
