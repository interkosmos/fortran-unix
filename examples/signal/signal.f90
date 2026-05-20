! signal.f90
!
! Author:  Philipp Engel
! Licence: ISC
program main
    !! Example program that registers a signal handler and terminates the main
    !! loop through a self-pipe.
    use :: unix
    implicit none

    character(32), target :: buffer
    integer               :: self_pipe(2)
    integer               :: i, stat, timeout
    integer(c_size_t)     :: nbytes
    logical               :: has_event, is_done
    type(c_pollfd)        :: pfds(1)

    ! Create pipe.
    if (c_pipe(self_pipe) == -1) then
        print '("Error: pipe() failed")'
        error stop
    end if

    ! Register signal handler.
    call register_signal_handler(SIGINT)
    print '("PID ", i0, " running. Press Ctrl-C to stop.")', c_getpid()

    ! Set pipe parameters.
    pfds(1)%fd      = self_pipe(1)
    pfds(1)%events  = POLLIN
    pfds(1)%revents = 0

    ! Timeout:
    !
    !  -1 => wait forever
    !   0 => do not block
    ! > 0 => max. wait time [ms]
    !
    timeout = 0

    ! Main loop.
    is_done = .false.

    do while (.not. is_done)
        ! Poll the self-pipe.
        stat = c_poll(pfds, size(pfds, kind=c_nfds_t), timeout)

        if (stat == -1) then
            if (c_errno() == EINTR) cycle
            print '("Error: poll() failed")'
            exit
        end if

        ! Timeout: regular worker activity.
        if (stat == 0) then
            call task()
            cycle
        end if

        ! Signal notification available?
        has_event = (iand(int(pfds(1)%revents), POLLIN) == 1)

        if (has_event) then
            ! Drain the self-pipe.
            buffer = ' '
            nbytes = c_read(self_pipe(1), c_loc(buffer), len(buffer, kind=c_size_t))

            if (nbytes == -1) then
                if (c_errno() == EINTR) cycle
                print '("Error: read() failed")'
                exit
            end if

            ! Search for SIGINT.
            do i = 1, int(nbytes)
                select case (ichar(buffer(i:i)))
                    case (SIGINT)
                        print '("Received SIGINT.")'
                        is_done = .true.

                    case default
                        print '("Received signal ", i0, ".")', ichar(buffer(i:i))
                end select
            end do
        end if
    end do

    print '("Exited worker loop.")'

    stat = c_close(self_pipe(1))
    stat = c_close(self_pipe(2))
contains
    subroutine register_signal_handler(signum)
        integer, intent(in) :: signum

        type(c_sigaction_t) :: sa

        sa%sa_handler = c_funloc(signal_handler)
        sa%sa_flags   = 0 ! No SA_RESTART: allow poll() to wake promptly.

        ! Register signal handler.
        if (c_sigaction(signum, sa) == -1) then
            print '("Error: sigaction() failed")'
            error stop
        end if
    end subroutine register_signal_handler

    subroutine signal_handler(signum) bind(c)
        !! Signal handler for SIGINT.
        integer(kind=c_int), intent(in), value :: signum

        character, target      :: sig
        integer(kind=c_size_t) :: nbytes

        print '("Received signal (", i0, "). Terminating ...")', signum

        sig = char(signum)

        ! Ignore errors intentionally. The call to write() is async-signal-safe.
        ! The loop only needs notification that something happened.
        nbytes = c_write(self_pipe(2), c_loc(sig), len(sig, kind=c_size_t))
    end subroutine signal_handler

    subroutine task()
        integer :: stat

        print '("zzz ...")'
        stat = c_usleep(10**6)
    end subroutine task
end program main
