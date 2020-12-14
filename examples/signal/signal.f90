! signal.f90
!
! Example program that registers a signal handler for SIGINT.
!
! Author:  Philipp Engel
! Licence: ISC
program main
    use, intrinsic :: iso_c_binding
    use :: unix
    implicit none
    integer        :: rc
    type(c_funptr) :: ptr

    ! Register signal handler.
    ptr = c_signal(SIGINT, c_funloc(sigint_handler))

    print '(a)', 'Press CTRL + C to send SIGINT.'

    do
        print '(a)', 'zzz ...'
        rc = c_usleep(10**6)
    end do
contains
    subroutine sigint_handler(signum) bind(c)
        !! Signal handler for SIGINT.
        integer(kind=c_int), intent(in), value :: signum

        print '(a, i0, a)', 'Received SIGINT (', signum, '). Terminating ...'
        stop
    end subroutine sigint_handler
end program main
