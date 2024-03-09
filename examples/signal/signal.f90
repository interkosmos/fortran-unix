! signal.f90
!
! Author:  Philipp Engel
! Licence: ISC
program main
    !! Example program that registers a signal handler for SIGINT.
    use :: unix
    implicit none
    integer        :: stat
    type(c_funptr) :: ptr

    ! Register signal handler.
    ptr = c_signal(SIGINT, c_funloc(sigint_handler))

    print '("Press CTRL + C to send SIGINT.")'

    do
        print '("zzz ...")'
        stat = c_usleep(10**6)
    end do
contains
    subroutine sigint_handler(signum) bind(c)
        !! Signal handler for SIGINT.
        integer(kind=c_int), intent(in), value :: signum

        print '("Received SIGINT (", i0, "). Terminating ...")', signum
        stop
    end subroutine sigint_handler
end program main
