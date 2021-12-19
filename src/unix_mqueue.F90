! unix_mqueues.F90
module unix_mqueue
    use, intrinsic :: iso_c_binding
    use :: unix_time
    use :: unix_types
    implicit none
    private

    public :: c_mq_close
    public :: c_mq_getattr
    public :: c_mq_open
    public :: c_mq_receive
    public :: c_mq_send
    public :: c_mq_setattr
    public :: c_mq_timedreceive
    public :: c_mq_unlink

    type, bind(c), public :: c_mq_attr
        integer(kind=c_long) :: mq_flags    = 0 ! Flags (ignored for mq_open()).
        integer(kind=c_long) :: mq_maxmsg   = 0 ! Max. # of messages on queue.
        integer(kind=c_long) :: mq_msgsize  = 0 ! Max. message size (bytes).
        integer(kind=c_long) :: mq_curmsgs  = 0 ! # of messages currently in queue.
        integer(kind=c_long) :: reserved(4) = 0
    end type c_mq_attr

    interface
        ! int mq_close(mqd_t mqdes)
        function c_mq_close(mqdes) bind(c, name='mq_close')
            import :: c_int, c_mqd_t
            implicit none
            integer(kind=c_mqd_t), intent(in), value :: mqdes
            integer(kind=c_int)                      :: c_mq_close
        end function c_mq_close

        ! int mq_getattr(mqd_t mqdes, struct mq_attr *attr)
        function c_mq_getattr(mqdes, attr) bind(c, name='mq_getattr')
            import :: c_int, c_mq_attr, c_mqd_t
            implicit none
            integer(kind=c_mqd_t), intent(in), value :: mqdes
            type(c_mq_attr),       intent(out)       :: attr
            integer(kind=c_int)                      :: c_mq_getattr
        end function c_mq_getattr

        ! mqd_t c_mq_open(const char *name, int oflag, mode_t mode, struct mq_attr *attr)
        function c_mq_open(name, oflag, mode, attr) bind(c, name='mq_open')
            import :: c_char, c_int, c_mode_t, c_mqd_t, c_ptr
            implicit none
            character(kind=c_char), intent(in)        :: name
            integer(kind=c_int),    intent(in), value :: oflag
            integer(kind=c_mode_t), intent(in), value :: mode
            type(c_ptr),            intent(in), value :: attr
            integer(kind=c_mqd_t)                     :: c_mq_open
        end function c_mq_open

        ! ssize_t mq_receive(mqd_t mqdes, char *msg_ptr, size_t msg_len, unsigned int *msg_prio)
        function c_mq_receive(mqdes, msg_ptr, msg_len, msg_prio) bind(c, name='mq_receive')
            import :: c_char, c_int, c_mqd_t, c_size_t
            implicit none
            integer(kind=c_mqd_t),  intent(in), value :: mqdes
            character(kind=c_char), intent(in)        :: msg_ptr
            integer(kind=c_size_t), intent(in), value :: msg_len
            integer(kind=c_int),    intent(inout)     :: msg_prio
            integer(kind=c_size_t)                    :: c_mq_receive
        end function c_mq_receive

        ! int mq_send(mqd_t mqdes, const char *msg_ptr, size_t msg_len, unsigned int msg_prio)
        function c_mq_send(mqdes, msg_ptr, msg_len, msg_prio) bind(c, name='mq_send')
            import :: c_char, c_int, c_mqd_t, c_size_t
            implicit none
            integer(kind=c_mqd_t),  intent(in), value :: mqdes
            character(kind=c_char), intent(in)        :: msg_ptr
            integer(kind=c_size_t), intent(in), value :: msg_len
            integer(kind=c_int),    intent(in), value :: msg_prio
            integer(kind=c_int)                       :: c_mq_send
        end function c_mq_send

        ! int mq_setattr(mqd_t mqdes, const struct mq_attr *attr, struct mq_attr *oldattr)
        function c_mq_setattr(mqdes, attr, oldattr) bind(c, name='mq_setattr')
            import :: c_int, c_mq_attr, c_mqd_t, c_ptr
            implicit none
            integer(kind=c_mqd_t), intent(in), value :: mqdes
            type(c_mq_attr),       intent(in)        :: attr
            type(c_mq_attr),       intent(out)       :: oldattr
            integer(kind=c_int)                      :: c_mq_setattr
        end function c_mq_setattr

        ! ssize_t mq_timedreceive(mqd_t mqdes, char *restrict msg_ptr, size_t msg_len, unsigned int *restrict msg_prio, const struct timespec *restrict abs_timeout)
        function c_mq_timedreceive(mqdes, msg_ptr, msg_len, msg_prio, abs_timeout) bind(c, name='mq_timedreceive')
            import :: c_char, c_int, c_mqd_t, c_size_t, c_timespec
            implicit none
            integer(kind=c_mqd_t),  intent(in), value :: mqdes
            character(kind=c_char), intent(in)        :: msg_ptr
            integer(kind=c_size_t), intent(in), value :: msg_len
            integer(kind=c_int),    intent(inout)     :: msg_prio
            type(c_timespec),       intent(in)        :: abs_timeout
            integer(kind=c_size_t)                    :: c_mq_timedreceive
        end function c_mq_timedreceive

        ! int mq_unlink(const char *name)
        function c_mq_unlink(name) bind(c, name='mq_unlink')
            import :: c_char, c_int
            implicit none
            character(kind=c_char), intent(in) :: name
            integer(kind=c_int)                :: c_mq_unlink
        end function c_mq_unlink
    end interface
end module unix_mqueue
