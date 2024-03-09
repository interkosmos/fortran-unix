! fork.f90
!
! Author:  Philipp Engel
! Licence: ISC
program main
    !! Example program that forks the main process and opens two anonymous pipes
    !! for IPC.
    use :: unix
    implicit none

    integer, parameter :: READ_END  = 1 ! Reader pipe.
    integer, parameter :: WRITE_END = 2 ! Writer pipe.

    character,         target :: buf ! Byte buffer.
    character(len=32), target :: msg ! Message to transmit.

    integer                :: pid     ! Process id.
    integer                :: pfds(2) ! File descriptors (reader/writer).
    integer                :: stat    ! Return code.
    integer(kind=c_size_t) :: nbytes

    ! Open anonymous pipe (read, write).
    stat = c_pipe(pfds)

    if (stat < 0) then
        print '("Creating anonymous pipe failed: ", i0)', stat
        stop
    end if

    ! Fork process.
    pid = c_fork()

    if (pid < 0) then
        !
        ! Fork error.
        !
        call c_perror('fork()' // c_null_char)
    else if (pid == 0) then
        !
        ! Child process.
        !
        print '(">>> child process running ...")'
        stat = c_close(pfds(WRITE_END))

        print '(">>> child process is receiving message ...")'

        ! Read message from pipe, byte by byte.
        do while (c_read(pfds(READ_END), c_loc(buf), 1_c_size_t) > 0)
            write (*, '(a)', advance='no') buf
        end do

        stat = c_close(pfds(READ_END))
        print '(/, ">>> child process done")'

        call c_exit(0)
    else
        !
        ! Parent process.
        !
        stat = c_close(pfds(READ_END))

        ! Write message to pipe.
        print '("<<< parent process is sending message ...")'

        msg    = 'Hi, there!'
        nbytes = c_write(pfds(WRITE_END), c_loc(msg), len(msg, kind=c_size_t))

        if (nbytes < 0) print '("<<< writing to pipe failed")'

        stat = c_close(pfds(WRITE_END))

        print '("<<< waiting for child ", i0, " ...")', pid
        print '("<<< child ", i0, " finished")', c_wait(stat)
    end if
end program main
