! pipe.f90
!
! Example that demonstrates IPC via bidirectional pipes.
!
! Author:  Philipp Engel
! Licence: ISC
program main
    use, intrinsic :: iso_c_binding
    use :: unix
    implicit none

    character(len=6)  :: message
    character(len=32) :: buffer
    type(c_ptr)       :: stdin, stdout

    call popen2('cat -n', stdin, stdout)

    if (.not. c_associated(stdin) .or. .not. c_associated(stdout)) &
        stop 'Error: popen2() failed'

    ! Send message, equivalent to:
    ! $ echo "Hello!" | cat -n
    message = 'Hello!'
    print '("Parent: ", a)', trim(message)
    call pwrite(stdin, message)

    ! Read from stdout of child process.
    call pread(stdout, buffer)
    print '("Child: ", a)', trim(buffer)
contains
    subroutine popen2(command, stdin, stdout)
        character(len=*), intent(in)  :: command
        type(c_ptr),      intent(out) :: stdin
        type(c_ptr),      intent(out) :: stdout

        integer :: p1(2), p2(2)
        integer :: rc

        rc = c_pipe(p1)
        rc = c_pipe(p2)

        if (c_fork() > 0) then
            ! Parent process.
            rc = c_close(p1(1))
            rc = c_close(p2(2))

            stdin  = c_fdopen(p1(2), 'w' // c_null_char)
            stdout = c_fdopen(p2(1), 'r' // c_null_char)
            return
        else
            ! Child process.
            rc = c_close(p1(2))
            rc = c_close(p2(1))

            rc = c_dup2(p1(1), STDIN_FILENO)
            rc = c_dup2(p2(2), STDOUT_FILENO)

            rc = c_execl('/bin/sh' // c_null_char, &
                         '/bin/sh' // c_null_char, &
                         '-c'      // c_null_char, &
                         command   // c_null_char, &
                         c_null_ptr)
            call c_exit(1)
        end if
    end subroutine popen2

    subroutine pread(pipe, str)
        type(c_ptr),              intent(in)    :: pipe
        character(len=*), target, intent(inout) :: str

        integer          :: rc
        integer(kind=i8) :: sz

        str = ' '

        sz = c_fread(c_loc(str), &
                     int(1, kind=c_size_t), &
                     len(str, kind=c_size_t), &
                     pipe)
        rc = c_fclose(pipe)
    end subroutine pread

    subroutine pwrite(pipe, str)
        type(c_ptr),              intent(in)    :: pipe
        character(len=*), target, intent(inout) :: str

        integer          :: rc
        integer(kind=i8) :: sz

        sz = c_fwrite(c_loc(str), &
                      int(1, kind=c_size_t), &
                      len(str, kind=c_size_t), &
                      pipe)
        rc = c_fclose(pipe)
    end subroutine pwrite
end program main
