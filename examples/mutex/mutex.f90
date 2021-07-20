! mutex.f90
!
! Example that shows threaded access to a global variable, using a mutex.
!
! Author:  Philipp Engel
! Licence: ISC
module util
    use, intrinsic :: iso_c_binding
    use :: unix
    implicit none

    type(c_pthread_mutex_t), save :: foo_mutex
    integer,                 save :: foo_value = 0
contains
    recursive subroutine foo(arg) bind(c)
        type(c_ptr), intent(in), value :: arg   ! Client data.
        integer, pointer               :: n     ! Fortran pointer to client data.
        integer                        :: rc

        if (.not. c_associated(arg)) return
        call c_f_pointer(arg, n)

        rc = c_pthread_mutex_lock(foo_mutex)

        print '("Thread ", i2, " changes value from ", i2, " to ", i2)', n, foo_value, n
        foo_value = n

        rc = c_pthread_mutex_unlock(foo_mutex)
    end subroutine foo
end module util

program main
    use, intrinsic :: iso_c_binding
    use :: unix
    use :: util
    implicit none
    integer, parameter :: NTHREADS = 16
    integer            :: i, rc
    type(c_pthread_t)  :: threads(NTHREADS)
    integer, target    :: routines(NTHREADS) = [ (i, i = 1, NTHREADS) ]

    rc = c_pthread_mutex_init(foo_mutex, c_null_ptr)

    print '(a)', 'Starting threads ...'

    do i = 1, NTHREADS
        rc = c_pthread_create(thread        = threads(i), &
                              attr          = c_null_ptr, &
                              start_routine = c_funloc(foo), &
                              arg           = c_loc(routines(i)))
    end do

    print '(a)', 'Joining threads ...'

    do i = 1, NTHREADS
        rc = c_pthread_join(threads(i), c_loc(routines(i)))
    end do

    rc = c_pthread_mutex_destroy(foo_mutex)
end program main
