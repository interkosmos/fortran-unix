! unix_utsname.F90
!
! Author:  Philipp Engel
! Licence: ISC
module unix_utsname
    use, intrinsic :: iso_c_binding
    implicit none
    private

#if defined (__linux__)

    integer(kind=c_int), parameter, public :: SYS_NMLN = 65

    ! struct utsname
    type, bind(c), public :: c_utsname
        character(kind=c_char) :: sysname(0:SYS_NMLN - 1)    = c_null_char
        character(kind=c_char) :: nodename(0:SYS_NMLN - 1)   = c_null_char
        character(kind=c_char) :: release(0:SYS_NMLN - 1)    = c_null_char
        character(kind=c_char) :: version(0:SYS_NMLN - 1)    = c_null_char
        character(kind=c_char) :: machine(0:SYS_NMLN - 1)    = c_null_char
        character(kind=c_char) :: domainname(0:SYS_NMLN - 1) = c_null_char
    end type c_utsname

#elif defined (__FreeBSD__)

    integer(kind=c_int), parameter, public :: SYS_NMLN = 256

    ! struct utsname
    type, bind(c), public :: c_utsname
        character(kind=c_char) :: sysname(0:SYS_NMLN - 1)  = c_null_char
        character(kind=c_char) :: nodename(0:SYS_NMLN - 1) = c_null_char
        character(kind=c_char) :: release(0:SYS_NMLN - 1)  = c_null_char
        character(kind=c_char) :: version(0:SYS_NMLN - 1)  = c_null_char
        character(kind=c_char) :: machine(0:SYS_NMLN - 1)  = c_null_char
    end type c_utsname

#endif

    public :: c_uname

    interface
        ! int uname(struct utsname *name)
        function c_uname(name) bind(c, name='c_uname')
            !! Calls wrapper `c_uname()` in `unix_macro.c`, as it is an inline
            !! function on FreeBSD, alternatively to calling `__xuname()`.
            import :: c_int, c_utsname
            implicit none
            type(c_utsname), intent(inout) :: name
            integer(kind=c_int)            :: c_uname
        end function c_uname
    end interface
end module unix_utsname
