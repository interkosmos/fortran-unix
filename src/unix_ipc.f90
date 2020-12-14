! unix_ipc.f90
module unix_ipc
    use, intrinsic :: iso_c_binding
    implicit none
    private

    integer(kind=c_int), parameter, public :: IPC_CREAT  = 001000
    integer(kind=c_int), parameter, public :: IPC_EXCL   = 002000
    integer(kind=c_int), parameter, public :: IPC_NOWAIT = 004000

    integer(kind=c_int), parameter, public :: IPC_RMID   = 0
    integer(kind=c_int), parameter, public :: IPC_SET    = 1
    integer(kind=c_int), parameter, public :: IPC_STAT   = 2

    integer(kind=c_long), parameter, public :: IPC_PRIVATE = 0
end module unix_ipc
