! pthread.f90
!
! Author:  Philipp Engel
! Licence: ISC
program main
    !! Example that shows how to run a routine inside several POSIX threads.
    use :: unix
    implicit none

    integer, parameter :: NTHREADS = 3

    integer           :: i, stat
    integer, target   :: routines(NTHREADS) = [ (i, i = 1, NTHREADS) ]
    type(c_pthread_t) :: threads(NTHREADS)
    type(c_ptr)       :: ptr

    print '("Starting threads ...")'

    do i = 1, NTHREADS
        stat = c_pthread_create(thread        = threads(i), &
                                attr          = c_null_ptr, &
                                start_routine = c_funloc(hello), &
                                arg           = c_loc(routines(i)))
    end do

    print '("Joining threads ...")'

    do i = 1, NTHREADS
        stat = c_pthread_join(threads(i), ptr)
    end do
contains
    recursive subroutine hello(arg) bind(c)
        type(c_ptr), intent(in), value :: arg ! Client data.

        integer, pointer :: n ! Fortran pointer to client data.
        integer          :: i, stat

        if (.not. c_associated(arg)) return
        call c_f_pointer(arg, n)

        do i = 1, 5
            print '("--- Thread #", i0, " - Loop iteration ", i0)', n, i
            stat = c_usleep(10**6)
        end do
    end subroutine hello
end program main
