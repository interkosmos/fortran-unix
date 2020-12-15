! pthread.f90
!
! Example that shows how to run a routine inside several POSIX threads.
!
! Author:  Philipp Engel
! Licence: ISC
program main
    use, intrinsic :: iso_c_binding
    use :: unix
    integer, parameter :: NTHREADS = 3
    integer            :: i, rc
    type(c_pthread_t)  :: threads(NTHREADS)
    integer, target    :: routines(NTHREADS) = [ (i, i = 1, NTHREADS) ]

    print '(a)', 'Starting threads ...'

    do i = 1, NTHREADS
        rc = c_pthread_create(thread        = threads(i), &
                              attr          = c_null_ptr, &
                              start_routine = c_funloc(hello), &
                              arg           = c_loc(routines(i)))
    end do

    print '(a)', 'Joining threads ...'

    do i = 1, NTHREADS
        rc = c_pthread_join(threads(i), c_loc(routines(i)))
    end do
contains
    recursive subroutine hello(arg) bind(c)
        type(c_ptr), intent(in), value :: arg   ! Client data.
        integer, pointer               :: n     ! Fortran pointer to client data.
        integer                        :: i, rc

        if (.not. c_associated(arg)) return
        call c_f_pointer(arg, n)

        do i = 1, 5
            print '("--- Thread #", i0, " - Loop iteration ", i0)', n, i
            rc = c_usleep(10**6)
        end do
    end subroutine hello
end program main
