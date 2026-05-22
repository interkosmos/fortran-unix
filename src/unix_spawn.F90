! unix_spawn.F90
!
! Author:  Philipp Engel
! Licence: ISC
module unix_spawn
    use :: unix_types
    implicit none
    private

    public :: c_posix_spawn
    public :: c_posix_spawn_file_actions_addclose
    public :: c_posix_spawn_file_actions_adddup2
    public :: c_posix_spawn_file_actions_addopen
    public :: c_posix_spawn_file_actions_destroy
    public :: c_posix_spawn_file_actions_init
    public :: c_posix_spawnp

    interface
        ! int posix_spawn(pid_t *pid, const char *path, const posix_spawn_file_actions_t *file_actions, const posix_spawnattr_t *attrp, char *const argv[], char *const envp[])
        function c_posix_spawn(pid, path, file_actions, attrp, argv, envp) bind(c, name='posix_spawn')
            import :: c_char, c_int, c_pid_t, c_ptr
            implicit none
            integer(c_pid_t),  intent(out)       :: pid
            character(c_char), intent(in)        :: path
            type(c_ptr),       intent(in), value :: file_actions
            type(c_ptr),       intent(in), value :: attrp
            type(c_ptr),       intent(in)        :: argv(*)
            type(c_ptr),       intent(in)        :: envp(*)
            integer(c_int)                       :: c_posix_spawn
        end function c_posix_spawn

        ! int posix_spawn_file_actions_addclose(posix_spawn_file_actions_t *file_actions, int fildes)
        function c_posix_spawn_file_actions_addclose(file_actions, fildes) bind(c, name='posix_spawn_file_actions_addclose')
            import :: c_int, c_ptr
            implicit none
            type(c_ptr),    intent(in), value :: file_actions
            integer(c_int), intent(in), value :: fildes
            integer(c_int)                    :: c_posix_spawn_file_actions_addclose
        end function c_posix_spawn_file_actions_addclose

        ! int posix_spawn_file_actions_adddup2(posix_spawn_file_actions_t *file_actions, int fildes, int newfildes)
        function c_posix_spawn_file_actions_adddup2(file_actions, fildes, newfildes) bind(c, name='posix_spawn_file_actions_adddup2')
            import :: c_int, c_ptr
            implicit none
            type(c_ptr),    intent(in), value :: file_actions
            integer(c_int), intent(in), value :: fildes
            integer(c_int), intent(in), value :: newfildes
            integer(c_int)                    :: c_posix_spawn_file_actions_adddup2
        end function c_posix_spawn_file_actions_adddup2

        ! int posix_spawn_file_actions_addopen(posix_spawn_file_actions_t * file_actions, int fildes, const char *path, int oflag, mode_t mode)
        function c_posix_spawn_file_actions_addopen(file_actions, fildes, path, oflag, mode) bind(c, name='posix_spawn_file_actions_addopen')
            import :: c_char, c_int, c_mode_t, c_ptr
            implicit none
            type(c_ptr),       intent(in), value :: file_actions
            integer(c_int),    intent(in), value :: fildes
            character(c_char), intent(in)        :: path
            integer(c_int),    intent(in), value :: oflag
            integer(c_mode_t), intent(in), value :: mode
            integer(c_int)                       :: c_posix_spawn_file_actions_addopen
        end function c_posix_spawn_file_actions_addopen

        ! int posix_spawn_file_actions_destroy(posix_spawn_file_actions_t *file_actions)
        function c_posix_spawn_file_actions_destroy(file_actions) bind(c, name='c_posix_spawn_file_actions_destroy')
            import :: c_int, c_ptr
            implicit none
            type(c_ptr), intent(in), value :: file_actions
            integer(c_int)                 :: c_posix_spawn_file_actions_destroy
        end function c_posix_spawn_file_actions_destroy

        ! int c_posix_spawn_file_actions_init(void **file_actions)
        function c_posix_spawn_file_actions_init(file_actions) bind(c, name='c_posix_spawn_file_actions_init')
            import :: c_int, c_ptr
            implicit none
            type(c_ptr), intent(out) :: file_actions
            integer(c_int)           :: c_posix_spawn_file_actions_init
        end function c_posix_spawn_file_actions_init

        ! int posix_spawnp(pid_t *pid, const char *file, const posix_spawn_file_actions_t *file_actions, const posix_spawnattr_t *attrp, char *const argv[], char *const envp[])
        function c_posix_spawnp(pid, file, file_actions, attrp, argv, envp) bind(c, name='posix_spawnp')
            import :: c_char, c_int, c_pid_t, c_ptr
            implicit none
            integer(c_pid_t),  intent(out)       :: pid
            character(c_char), intent(in)        :: file
            type(c_ptr),       intent(in), value :: file_actions
            type(c_ptr),       intent(in), value :: attrp
            type(c_ptr),       intent(in)        :: argv(*)
            type(c_ptr),       intent(in)        :: envp(*)
            integer(c_int)                       :: c_posix_spawnp
        end function c_posix_spawnp
    end interface
end module unix_spawn
