! os.f90
!
! Prints the name of the operating system to stdout, using pre-processor macros.
! Compile the source code with parameter `-cpp` (GNU Fortran) or `-fpp` (IFORT)
! and `-D__<OS identifier>__`, for example:
!
!   $ gfortran -cpp -D__linux__   -o os os.f90
!   $ gfortran -cpp -D__FreeBSD__ -o os os.f90
!   $ gfortran -cpp -D__APPLE__   -o os os.f90
!   $ ifort -fpp -o os os.f90
!
! Author:  Philipp Engel
! Licence: ISC
module os
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
    use :: os
    implicit none
    integer :: current_os

    print '(a)', 'Current Operating System'
    print '(a)', repeat('-', 24)

    current_os = os_type()

    select case (current_os)
        case (OS_UNKNOWN)
            print '("Name: ", a)', 'Unknown OS'

        case (OS_WINDOWS)
            print '("Name: ", a)', 'Microsoft Windows (Cygwin, MSYS2)'

        case (OS_MACOS)
            print '("Name: ", a)', 'macOS'

        case (OS_LINUX)
            print '("Name: ", a)', 'GNU/Linux'

        case (OS_FREEBSD)
            print '("Name: ", a)', 'FreeBSD'

        case default
            print '(a)', 'Error'
    end select
end program main

