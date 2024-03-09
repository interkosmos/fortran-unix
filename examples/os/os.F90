! os.f90
!
! Author:  Philipp Engel
! Licence: ISC
module os
    !! Utility module.
    implicit none
    private

    integer, parameter, public :: OS_UNKNOWN = 0
    integer, parameter, public :: OS_WINDOWS = 1
    integer, parameter, public :: OS_MACOS   = 2
    integer, parameter, public :: OS_LINUX   = 3
    integer, parameter, public :: OS_FREEBSD = 4

    public :: os_type
contains
    function os_type()
        integer :: os_type

#if defined (WIN32) || defined (_WIN32) || defined (__WIN32__) || defined (__NT__)
        os_type = OS_WINDOWS
#elif defined (__APPLE__)
        os_type = OS_MACOS
#elif defined (__linux__)
        os_type = OS_LINUX
#elif defined (__FreeBSD__)
        os_type = OS_FREEBSD
#else
        os_type = OS_UNKNOWN
#endif
    end function os_type
end module os

program main
    !! Prints the name of the operating system to stdout, using pre-processor
    !! macros. Pass the parameter `-D__<OS identifier>__` to GNU Fortran, for
    !! example:
    !!
    !! ```
    !! $ gfortran -D__linux__ -o os os.F90
    !! $ gfortran -D__FreeBSD__ -o os os.F90
    !! $ gfortran -D__APPLE__ -o os os.F90
    !! $ ifort -o os os.F90
    !! ```
    use :: os
    implicit none
    integer :: current_os

    print '("Current Operating System")'
    print '(24("-"))'

    current_os = os_type()

    write (* , '("Name: ")', advance='no')

    select case (current_os)
        case (OS_UNKNOWN)
            print '("Unknown OS")'

        case (OS_WINDOWS)
            print '("Microsoft Windows (Cygwin, MSYS2)")'

        case (OS_MACOS)
            print '("macOS")'

        case (OS_LINUX)
            print '("GNU/Linux")'

        case (OS_FREEBSD)
            print '("FreeBSD")'

        case default
            print '("Error")'
    end select
end program main
