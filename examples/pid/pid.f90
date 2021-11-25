! pid.f90
!
! Example program that outputs the process id.
!
! Author:  Philipp Engel
! Licence: ISC
program main
    use, intrinsic :: iso_c_binding
    use :: unix
    implicit none

    print '("PID: ", i0)', c_getpid()
end program main
