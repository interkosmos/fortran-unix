! unix_utsname.F90
module unix_utsname
    use, intrinsic :: iso_c_binding
    implicit none
    private

    public :: c_uname

#if defined (__linux__)

    integer(kind=c_int), parameter :: UTS_LEN = 65

    type, bind(c), public :: c_utsname
        character(kind=c_char) :: sysname(UTS_LEN)
        character(kind=c_char) :: nodename(UTS_LEN)
        character(kind=c_char) :: release(UTS_LEN)
        character(kind=c_char) :: version(UTS_LEN)
        character(kind=c_char) :: machine(UTS_LEN)
        character(kind=c_char) :: domainname(UTS_LEN)
    end type c_utsname

#elif defined (__FreeBSD__)

    integer(kind=c_int), parameter :: SYS_NMLN = 32

    type, bind(c), public :: c_utsname
        character(kind=c_char) :: sysname(SYS_NMLN)
        character(kind=c_char) :: nodename(SYS_NMLN)
        character(kind=c_char) :: release(SYS_NMLN)
        character(kind=c_char) :: version(SYS_NMLN)
        character(kind=c_char) :: machine(SYS_NMLN)
    end type c_utsname

#endif

    interface
        ! int uname(struct utsname *name)
        function c_uname(name) bind(c, name='uname')
            import :: c_int, c_utsname
            type(c_utsname), intent(out) :: name
            integer(kind=c_int)          :: c_uname
        end function c_uname
    end interface
end module unix_utsname
