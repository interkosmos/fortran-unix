! unix_ipc.F90
module unix_ipc
    use, intrinsic :: iso_c_binding
    use :: unix_types
    implicit none
    private

    integer(kind=c_int), parameter, public :: IPC_CREAT  = int(o'001000')
    integer(kind=c_int), parameter, public :: IPC_EXCL   = int(o'002000')
    integer(kind=c_int), parameter, public :: IPC_NOWAIT = int(o'004000')

    integer(kind=c_int), parameter, public :: IPC_RMID   = 0
    integer(kind=c_int), parameter, public :: IPC_SET    = 1
    integer(kind=c_int), parameter, public :: IPC_STAT   = 2

    integer(kind=c_key_t), parameter, public :: IPC_PRIVATE = 0

    public :: c_ftok

    interface
        ! key_t ftok(const char *pathname, int proj_id)
        function c_ftok(pathname, proj_id) bind(c, name='ftok')
            import :: c_char, c_int, c_key_t
            character(kind=c_char), intent(in)        :: pathname
            integer(kind=c_int),    intent(in), value :: proj_id
            integer(kind=c_key_t)                     :: c_ftok
        end function c_ftok
    end interface
end module unix_ipc
