! semaphore.f90
!
! Author:  Philipp Engel
! Licence: ISC
program main
    !! Basic example that demonstrates the use of an unnamed POSIX semaphore.
    !! In contrast to named semaphores, unnamed ones have to be passed as C
    !! pointers to POSIX function interfaces other than `c_sem_init()` and
    !! `c_sem_destroy()`.
    use :: unix
    implicit none

    integer, parameter :: NTHREADS = 2

    type(c_funptr)        :: procs(NTHREADS)
    type(c_pthread_t)     :: threads(NTHREADS)
    type(c_sem_t), target :: sem
    type(c_ptr)           :: ptr

    integer         :: i, stat
    integer, target :: routines(NTHREADS) = [ (i, i = 1, NTHREADS) ]

    procs(1) = c_funloc(thread_fetch)
    procs(2) = c_funloc(thread_process)

    print '("--- Creating semaphore ...")'
    stat = c_sem_init(sem, 0)
    if (stat /= 0) stop 'Error: sem_init() failed'

    print '("--- Creating threads ...")'

    do i = 1, NTHREADS
        stat = c_pthread_create(thread        = threads(i), &
                                attr          = c_null_ptr, &
                                start_routine = procs(i), &
                                arg           = c_loc(routines(i)))
    end do

    print '("--- Joining threads ...")'

    do i = 1, NTHREADS
        stat = c_pthread_join(threads(i), ptr)
    end do

    stat = c_sem_destroy(sem)
    if (stat == 0) print '("--- Semaphore destroyed")'
contains
    recursive subroutine thread_fetch(arg) bind(c)
        type(c_ptr), intent(in), value :: arg ! Client data.

        integer :: i, stat

        do i = 1, 5
            print '(">>> Simulating data fetching ...")'
            stat = c_usleep(2 * 10**6)
            print '(">>> Incrementing semaphore value ...")'
            stat = c_sem_post(c_loc(sem))
        end do
    end subroutine thread_fetch

    recursive subroutine thread_process(arg) bind(c)
        type(c_ptr), intent(in), value :: arg ! Client data.

        integer :: i, stat

        do i = 1, 5
            print '("--- Waiting for semaphore ...")'
            stat = c_sem_wait(c_loc(sem))

            if (stat == 0) then
                print '("--- Simulating data processing ...")'
                stat = c_usleep(3 * 10**6)
            end if
        end do
    end subroutine thread_process
end program main
