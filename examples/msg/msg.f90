! msg.f90
!
! Author:  Philipp Engel
! Licence: ISC
module ipc
    !! IPC abstraction module.
    use :: unix
    implicit none
    private

    public :: ipc_receive
    public :: ipc_send

    integer(kind=c_size_t), parameter, public :: MESSAGE_LEN  = 512 !! Message length.
    integer(kind=c_long),   parameter, public :: MESSAGE_TYPE = 1   !! Message type id.

    type, bind(c), public :: c_message_type
        !! Our message type implementation.
        integer(kind=c_long)   :: type
        character(kind=c_char) :: text(MESSAGE_LEN)
    end type c_message_type
contains
    integer(kind=c_size_t) function ipc_receive(msqid, type, text, flag) result(nbytes)
        !! Waits for message of given type and returns message text. Calling the
        !! function is blocking, unless `flag` is set to `IPC_NOWAIT`.
        integer,              intent(in)  :: msqid
        integer(kind=c_long), intent(in)  :: type
        character(len=*),     intent(out) :: text
        integer,              intent(in)  :: flag

        type(c_message_type), target :: message

        nbytes = c_msgrcv(msqid, c_loc(message), c_sizeof(message%text), type, flag)

        ! Copy C char array to Fortran character.
        if (nbytes > 0) then
            call c_f_str_chars(message%text, text)
        end if
    end function ipc_receive

    integer function ipc_send(msqid, type, text, flag) result(stat)
        !! Converts Fortran string to C char array, and then sends message of
        !! given type by calling `c_msgsnd()`.
        integer,              intent(in) :: msqid
        integer(kind=c_long), intent(in) :: type
        character(len=*),     intent(in) :: text
        integer,              intent(in) :: flag

        type(c_message_type), target :: message

        message%type = type
        call f_c_str_chars(text, message%text)
        stat = c_msgsnd(msqid, c_loc(message), c_sizeof(message%text), flag)
    end function ipc_send
end module ipc

program main
    !! Example that sends and receives a message with UNIX System V message
    !! queues.
    use, intrinsic :: iso_fortran_env, only: stderr => error_unit, stdout => output_unit
    use :: unix
    use :: ipc
    implicit none

    character(len=*), parameter :: MSG  = 'Hello, World!' ! Sample message.
    integer,          parameter :: PERM = int(o'0666')    ! Permissions (octal).

    character(len=MESSAGE_LEN) :: buf   ! Message text buffer.
    integer                    :: msqid ! Message queue id.
    integer                    :: stat  ! Return code.
    integer(kind=c_size_t)     :: nbytes

    ! Create new message queue.
    msqid = c_msgget(IPC_PRIVATE, ior(IPC_CREAT, PERM))

    if (msqid < 0) then
        call c_perror('msgget()' // c_null_char)
        stop
    end if

    print '("Message Queue ID: ", i0, /)', msqid

    ! Send message to message queue.
    print '("Sending message ...")'

    nbytes = ipc_send(msqid, MESSAGE_TYPE, MSG, IPC_NOWAIT)

    if (nbytes < 0) then
        call c_perror('ipc_send()' // c_null_char)
    else
        print '("Done.")'
    end if

    ! Receive message from message queue (blocking I/O).
    print '("Receiving message ...")'

    nbytes = ipc_receive(msqid, MESSAGE_TYPE, buf, 0)

    if (nbytes < 0) then
        call c_perror('ipc_receive()' // c_null_char)
    else
        print '("Received: ", a)', trim(buf)
    end if

    ! Remove message queue.
    print '("Closing message queue ...")'

    stat = c_msgctl(msqid, IPC_RMID, c_null_ptr)
    if (stat < 0) call c_perror('msgctl()' // c_null_char)
end program main
