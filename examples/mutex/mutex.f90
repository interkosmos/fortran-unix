! mutex.f90
!
! Author:  Philipp Engel
! Licence: ISC
module mutex
    !! Mutex module.
    use :: unix
    implicit none

    type(c_pthread_mutex_t), save :: mutex_sample
    integer,                 save :: value_sample = 0
contains
    recursive subroutine mutex_update(arg) bind(c)
        type(c_ptr), intent(in), value :: arg ! Client data.

        integer, pointer :: n    ! Fortran pointer to client data.
        integer          :: stat ! Return code.

        if (.not. c_associated(arg)) return
        call c_f_pointer(arg, n)

        stat = c_pthread_mutex_lock(mutex_sample)

        print '("Thread ", i2, " changes value from ", i2, " to ", i2)', n, value_sample, n
        value_sample = n

        stat = c_pthread_mutex_unlock(mutex_sample)
    end subroutine mutex_update
end module mutex

program main
    !! Example that shows threaded access to a global variable, using a mutex.
    use :: unix
    use :: mutex
    implicit none
    integer, parameter :: NTHREADS = 16

    integer           :: i, stat
    integer, target   :: routines(NTHREADS) = [ (i, i = 1, NTHREADS) ]
    type(c_pthread_t) :: threads(NTHREADS)
    type(c_ptr)       :: ptr

    stat = c_pthread_mutex_init(mutex_sample, c_null_ptr)

    print '("Starting threads ...")'

    do i = 1, NTHREADS
        stat = c_pthread_create(thread        = threads(i), &
                                attr          = c_null_ptr, &
                                start_routine = c_funloc(mutex_update), &
                                arg           = c_loc(routines(i)))
    end do

    print '("Joining threads ...")'

    do i = 1, NTHREADS
        stat = c_pthread_join(threads(i), ptr)
    end do

    stat = c_pthread_mutex_destroy(mutex_sample)
end program main
