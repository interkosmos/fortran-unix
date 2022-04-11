! fork.f90
!
! Example program that forks the main process and opens two anonymous pipes
! for IPC.
!
! Author:  Philipp Engel
! Licence: ISC
program main
    use, intrinsic :: iso_c_binding
    use :: unix
    implicit none
    integer, parameter :: READ_END  = 1     ! Reader pipe.
    integer, parameter :: WRITE_END = 2     ! Writer pipe.

    character(len=1),  target :: buf        ! Byte buffer.
    character(len=32), target :: msg        ! Message to transmit.
    integer                   :: pid        ! Process id.
    integer                   :: pfds(2)    ! File descriptors (reader/writer).
    integer                   :: rc         ! Return code.

    ! Open anonymous pipe (read, write).
    rc = c_pipe(pfds)

    if (rc < 0) then
        print '(a, i0)', 'Creating anonymous pipe failed: ', rc
        stop
    end if

    ! Fork process.
    pid = c_fork()

    if (pid < 0) then
        call c_perror('fork()' // c_null_char)
    else if (pid == 0) then
        ! Child process.
        print '(a)', '>>> child process running ...'
        rc = c_close(pfds(WRITE_END))

        print '(a)', '>>> child process is receiving message ...'

        ! Read message from pipe, byte by byte.
        do while (c_read(pfds(READ_END), c_loc(buf), 1_i8) > 0)
            write (*, '(a)', advance='no') buf
        end do

        rc = c_close(pfds(READ_END))
        print '(/, a)', '>>> child process done'
    else
        ! Parent process.
        rc = c_close(pfds(READ_END))

        ! Write message to pipe.
        print '(a)', '<<< parent process is sending message ...'
        msg = 'Hi, there!'

        if (c_write(pfds(WRITE_END), c_loc(msg), len(msg, kind=i8)) < 0) &
            print '(a)', 'writing to pipe failed'

        rc = c_close(pfds(WRITE_END))

        print '("<<< waiting for child ", i0, " ...")', pid
        print '("<<< child ", i0, " finished")', c_wait(rc)
    end if
end program main
