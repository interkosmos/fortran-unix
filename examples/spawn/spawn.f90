! spawn.f90
!
! Author:  Philipp Engel
! Licence: ISC
program main
    !! Example program to spawn processes.
    use :: unix
    implicit none

    character(len=80), target :: argv1(2), argv2(2)
    integer(kind=c_pid_t)     :: pid1, pid2
    integer                   :: child_state, stat

    ! First process.
    argv1 = [ character(len=80) ::            &
        'echo'                // c_null_char, &
        'Hello from Fortran!' // c_null_char  &
    ]

    ! Second process.
    argv2 = [ character(len=80) :: &
        'ls' // c_null_char,       &
        '-l' // c_null_char        &
    ]

    print '("Spawning process with output to process1.txt ...")'
    call spawn(pid1, '/bin/echo', argv1, 'process1.txt')

    print '("Spawning process with output to process2.txt ...")'
    call spawn(pid2, '/bin/ls',   argv2, 'process2.txt')

    print '("Waiting for processes to finish ...")'
    stat = c_waitpid(pid1, child_state, 0)

    if (stat == -1) then
        print '("Error: waitpid() failed")'
        stop
    end if

    stat = c_waitpid(pid2, child_state, 0)

    if (stat == -1) then
        print '("Error: waitpid() failed")'
        stop
    end if
contains
    subroutine spawn(pid, path, argv, output)
        integer(kind=c_pid_t),    intent(out)   :: pid
        character(len=*),         intent(in)    :: path
        character(len=*), target, intent(inout) :: argv(:)
        character(len=*),         intent(in)    :: output

        integer                :: i, oflag
        integer(kind=c_mode_t) :: mode
        type(c_ptr)            :: actions
        type(c_ptr)            :: argv_ptr(size(argv) + 1)
        type(c_ptr)            :: env_ptr(1)

        ! Allocate memory.
        stat = c_posix_spawn_file_actions_init(actions)

        if (stat /= 0) then
            print '("Error: posix_spawn_file_actions_init() failed")'
            return
        end if

        ! Flags and permissions.
        oflag = ior(ior(O_CREAT, O_TRUNC), O_WRONLY)
        mode  = int(o'0644', kind=c_mode_t)

        ! Open output file as stdout (fd 1) on the child.
        stat = c_posix_spawn_file_actions_addopen(actions, STDOUT_FILENO, trim(output) // c_null_char, oflag, mode)

        if (stat /= 0) then
            print '("Error: posix_spawn_file_actions_addopen() failed")'
            return
        end if

        ! Convert the argument array into something that C understands.
        ! The last element in each array must be NULL.
        env_ptr  = c_null_ptr
        argv_ptr = c_null_ptr

        do i = 1, size(argv)
            argv_ptr(i) = c_loc(argv(i))
        end do

        ! Spawn the process.
        stat = c_posix_spawn(pid, trim(path) // c_null_char, actions, c_null_ptr, argv_ptr, env_ptr)

        if (stat /= 0) then
            print '("Error: posix_spawn() failed")'
            return
        end if

        ! Clean-up.
        stat = c_posix_spawn_file_actions_destroy(actions)

        if (stat /= 0) then
            print '("Error: posix_spawn_file_actions_destroy() failed")'
            return
        end if
    end subroutine spawn
end program main
