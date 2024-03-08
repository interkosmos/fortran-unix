! pid.f90
!
! Author:  Philipp Engel
! Licence: ISC
program main
    !! Example program that outputs the process id.
    use, intrinsic :: iso_c_binding
    use :: unix
    implicit none

    print '("PID: ", i0)', c_getpid()
end program main
