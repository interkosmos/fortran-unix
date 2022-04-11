! mqueue.f90
!
! Example that sends and receives a message with POSIX message queues.
!
! On FreeBSD, make sure the kernel module `mqueuefs` is loaded and the message
! queue file system is mounted:
!
!   # kldload mqueuefs
!   # mkdir -p /mnt/mqueue
!   # mount -t mqueuefs null /mnt/mqueue
!
! To load the module at boot time, add to `/etc/rc.conf`:
!
!   kld_list+="mqueuefs"
!
! You may want to define an entry in `/etc/fstab`:
!
!   null    /mnt/mqueue     mqueuefs       rw      0       0
!
! Zombie message queues are deleted with `unlink`:
!
!   $ unlink /mnt/mqueue/<name>
!
! You can get/set the system limits with `sysctl` on FreeBSD:
!
!   $ sysctl kern.mqueue.maxmsg
!   $ sysctl kern.mqueue.maxmsgsize
!
! By default, new message queues are limited to 10 messages with a message size
! of 1024 bytes.
!
! On Linux, mount the message queue file system with:
!
!   $ mkdir -p /dev/mqueue
!   $ mount -t mqueue none /dev/mqueue
!
! This example runs in a single process. For inter-process communication, each
! thread or process may connect individually to the message queue, but make sure
! only one of them creates the message queue.
!
! The size of the buffer passed to `c_mq_receive()` must be greater than the MQ
! message size given by `mq_getattr()`. We may set the max. message size with
! `mq_setattr()` beforehand.
!
! Author:  Philipp Engel
! Licence: ISC
program main
    use, intrinsic :: iso_c_binding
    use :: unix
    implicit none
    character(len=*), parameter :: MQ_NAME = '/fortran'   ! New MQ in, e.g., `/mnt/mqueue/<name>`.
    integer,          parameter :: MQ_PERM = int(o'0644') ! MQ permissions (octal).

    character(len=32)     :: msg    ! Sample message.
    character(len=16384)  :: buf    ! Input buffer (must be greater than the MQ max. message size).
    integer(kind=c_mqd_t) :: mqds   ! MQ file descriptor.
    integer               :: prio   ! Priority.
    integer               :: rc     ! Return code.
    integer(kind=i8)      :: sz     ! Bytes received.
    type(c_mq_attr)       :: attr   ! MQ attributes.

    ! Unlink, if MQ already exists.
    rc = c_mq_unlink(MQ_NAME // c_null_char)

    ! Create new message queue `/fortran`.
    mqds = c_mq_open(name  = MQ_NAME // c_null_char, &
                     oflag = ior(O_CREAT, O_RDWR), &
                     mode  = MQ_PERM, &
                     attr  = c_null_ptr)

    if (mqds < 0) then
        call c_perror('mq_open()' // c_null_char)
        stop
    end if

    ! Get message queue attributes.
    if (c_mq_getattr(mqds, attr) < 0) &
        call c_perror('mq_getattr()' // c_null_char)

    print '(/, a, i0)', 'MQ file descriptor...: ', mqds
    print '(a, i0)',    'MQ flags.............: ', attr%mq_flags
    print '(a, i0)',    'MQ max. # of messages: ', attr%mq_maxmsg
    print '(a, i0)',    'MQ max. message size.: ', attr%mq_msgsize
    print '(a, i0, /)', 'Current # of messages: ', attr%mq_curmsgs

    ! Send message.
    print '(a)', '>>> Sending message ...'

    msg = 'Hello, World!'

    if (c_mq_send(mqds, msg, len(msg, 8), 1) < 0) &
        call c_perror('mq_send()')

    ! Receive message.
    print '(a)', 'Waiting for message ...'

    buf = ' ' ! Make sure to clear buffer!
    sz  = c_mq_receive(mqds, buf, len(buf, 8), prio)

    if (sz < 0) then
        call c_perror('mq_receive()' // c_null_char)
    else if (sz > 0) then
        print '(2a)', 'Received: ', trim(buf)
    else
        print '(a)', 'No message received'
    end if

    ! Close message queue.
    print '(a)', 'Closing message queue ...'

    if (c_mq_close(mqds) < 0) &
        call c_perror('mq_close()' // c_null_char)

    ! Unlink.
    rc = c_mq_unlink(MQ_NAME // c_null_char)
end program main
