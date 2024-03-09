! pipe.f90
!
! Author:  Philipp Engel
! Licence: ISC
program main
    !! Example that demonstrates IPC via bidirectional pipes.
    use :: unix
    implicit none

    character(len=6)  :: message
    character(len=32) :: buffer
    type(c_ptr)       :: stdin, stdout

    call pipe_open2('cat -n', stdin, stdout)

    if (.not. c_associated(stdin) .or. .not. c_associated(stdout)) then
        stop 'Error: pipe_open2() failed'
    end if

    ! Send message, equivalent to:
    ! $ echo "Hello!" | cat -n
    message = 'Hello!'

    print '("Parent: ", a)', trim(message)
    call pipe_write(stdin, message)

    ! Read from stdout of child process.
    call pipe_read(stdout, buffer)
    print '("Child: ", a)', trim(buffer)
contains
    subroutine pipe_open2(command, stdin, stdout)
        character(len=*), intent(in)  :: command
        type(c_ptr),      intent(out) :: stdin
        type(c_ptr),      intent(out) :: stdout

        integer :: p1(2), p2(2)
        integer :: pid, stat

        stat = c_pipe(p1)
        stat = c_pipe(p2)

        pid = c_fork()

        if (pid < 0) then
            ! Fork error.
            call c_perror('fork()' // c_null_char)
        else if (pid == 0) then
            ! Child process.
            stat = c_close(p1(2))
            stat = c_close(p2(1))

            stat = c_dup2(p1(1), STDIN_FILENO)
            stat = c_dup2(p2(2), STDOUT_FILENO)

            stat = c_execl('/bin/sh' // c_null_char, &
                           '/bin/sh' // c_null_char, &
                           '-c'      // c_null_char, &
                           command   // c_null_char, &
                           c_null_ptr)
            call c_exit(0)
        else
            ! Parent process.
            stat = c_close(p1(1))
            stat = c_close(p2(2))

            stdin  = c_fdopen(p1(2), 'w' // c_null_char)
            stdout = c_fdopen(p2(1), 'r' // c_null_char)
        end if
    end subroutine pipe_open2

    subroutine pipe_read(pipe, str)
        type(c_ptr),              intent(in)    :: pipe
        character(len=*), target, intent(inout) :: str

        integer                :: stat
        integer(kind=c_size_t) :: sz

        str  = ' '
        sz   = c_fread(c_loc(str), 1_c_size_t, len(str, kind=c_size_t), pipe)
        stat = c_fclose(pipe)
    end subroutine pipe_read

    subroutine pipe_write(pipe, str)
        type(c_ptr),              intent(in)    :: pipe
        character(len=*), target, intent(inout) :: str

        integer                :: stat
        integer(kind=c_size_t) :: sz

        sz   = c_fwrite(c_loc(str), 1_c_size_t, len(str, kind=c_size_t), pipe)
        stat = c_fclose(pipe)
    end subroutine pipe_write
end program main
