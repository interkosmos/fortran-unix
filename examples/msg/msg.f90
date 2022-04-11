! msg.f90
!
! Example that sends and receives a message with UNIX System V message queues.
!
! Author:  Philipp Engel
! Licence: ISC
module ipc
    use, intrinsic :: iso_c_binding
    use :: unix
    implicit none
    private

    public :: ipc_receive
    public :: ipc_send

    integer(kind=c_size_t), parameter, public :: MESSAGE_LEN  = 512 ! Message length.
    integer(kind=i8),       parameter, public :: MESSAGE_TYPE = 1   ! Message type id.

    ! Our message type implementation.
    type, bind(c), public :: c_message_type
        integer(kind=c_long)   :: type
        character(kind=c_char) :: text(MESSAGE_LEN)
    end type c_message_type
contains
    function ipc_receive(msqid, type, text, flag)
        !! Waits for message of given type and returns message text. Calling the
        !! function is blocking, unless `flag` is set to `IPC_NOWAIT`.
        integer,          intent(in)  :: msqid
        integer(kind=i8), intent(in)  :: type
        character(len=*), intent(out) :: text
        integer,          intent(in)  :: flag
        integer(kind=i8)              :: ipc_receive
        type(c_message_type), target  :: message

        ipc_receive = c_msgrcv(msqid, c_loc(message), c_sizeof(message%text), type, flag)

        ! Copy C char array to Fortran character.
        if (ipc_receive > 0) &
            call c_f_str_chars(message%text, text)
    end function ipc_receive

    function ipc_send(msqid, type, text, flag)
        !! Converts Fortran string to C char array, and then sends message of
        !! given type by calling `c_msgsnd()`.
        integer,          intent(in) :: msqid
        integer(kind=i8), intent(in) :: type
        character(len=*), intent(in) :: text
        integer,          intent(in) :: flag
        integer                      :: ipc_send
        type(c_message_type), target :: message

        message%type = type
        call f_c_str_chars(text, message%text)
        ipc_send = c_msgsnd(msqid, c_loc(message), c_sizeof(message%text), flag)
    end function ipc_send
end module ipc

program main
    use, intrinsic :: iso_c_binding
    use, intrinsic :: iso_fortran_env, only: stderr => error_unit, stdout => output_unit
    use :: unix
    use :: ipc
    implicit none

    character(len=*), parameter :: MSG  = 'Hello, World!'   ! Sample message.
    integer,          parameter :: PERM = int(o'0666')      ! Permissions (octal).

    character(len=MESSAGE_LEN) :: buf                       ! Message text buffer.
    integer                    :: msqid                     ! Message queue id.

    ! Create new message queue.
    msqid = c_msgget(IPC_PRIVATE, ior(IPC_CREAT, PERM))

    if (msqid < 0) then
        call c_perror('msgget()' // c_null_char)
        stop
    end if

    print '(a, i0, /)', 'Message Queue ID: ', msqid

    ! Send message to message queue.
    print '(a)', 'Sending message ...'

    if (ipc_send(msqid, MESSAGE_TYPE, MSG, IPC_NOWAIT) < 0) then
        call c_perror('ipc_send()' // c_null_char)
    else
        print '(a)', 'Done.'
    end if

    ! Receive message from message queue (blocking I/O).
    print '(a)', 'Receiving message ...'

    if (ipc_receive(msqid, MESSAGE_TYPE, buf, 0) < 0) then
        call c_perror('ipc_receive()' // c_null_char)
    else
        print '(2a)', 'Received: ', trim(buf)
    end if

    ! Wait for user input.
    print '(/, a)', 'Press Enter to quit.'
    read (*, *)

    ! Remove message queue.
    print '(a)', 'Closing message queue ...'

    if (c_msgctl(msqid, IPC_RMID, c_null_ptr) < 0) &
        call c_perror('msgctl()' // c_null_char)
end program main
