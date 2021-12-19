! unix_msg.F90
module unix_msg
    use, intrinsic :: iso_c_binding
    use :: unix_types
    implicit none
    private

    public :: c_msgctl
    public :: c_msgget
    public :: c_msgrcv
    public :: c_msgsnd

    interface
        ! int msgctl(int msqid, int cmd, struct msqid_ds *buf)
        function c_msgctl(msqid, cmd, buf) bind(c, name='msgctl')
            import :: c_int, c_ptr
            implicit none
            integer(kind=c_int), intent(in), value :: msqid
            integer(kind=c_int), intent(in), value :: cmd
            type(c_ptr),         intent(in), value :: buf
            integer(kind=c_int)                    :: c_msgctl
        end function c_msgctl

        ! int msgget(key_t key, int msgflg)
        function c_msgget(key, msgflg) bind(c, name='msgget')
            import :: c_int, c_key_t
            implicit none
            integer(kind=c_key_t), intent(in), value :: key
            integer(kind=c_int),   intent(in), value :: msgflg
            integer(kind=c_int)                      :: c_msgget
        end function c_msgget

        ! ssize_t msgrcv(int msqid, void *msgp, size_t msgsz, long msgtyp, int msgflg)
        function c_msgrcv(msqid, msgp, msgsz, msgtyp, msgflg) bind(c, name='msgrcv')
            import :: c_int, c_long, c_ptr, c_size_t
            implicit none
            integer(kind=c_int),    intent(in), value :: msqid
            type(c_ptr),            intent(in), value :: msgp
            integer(kind=c_size_t), intent(in), value :: msgsz
            integer(kind=c_long)  , intent(in), value :: msgtyp
            integer(kind=c_int),    intent(in), value :: msgflg
            integer(kind=c_size_t)                    :: c_msgrcv
        end function c_msgrcv

        ! int msgsnd(int msqid, const void *msgp, size_t msgsz, int msgflg)
        function c_msgsnd(msqid, msgp, msgsz, msgflg) bind(c, name='msgsnd')
            import :: c_int, c_ptr, c_size_t
            implicit none
            integer(kind=c_int),    intent(in), value :: msqid
            type(c_ptr),            intent(in), value :: msgp
            integer(kind=c_size_t), intent(in), value :: msgsz
            integer(kind=c_int),    intent(in), value :: msgflg
            integer(kind=c_int)                       :: c_msgsnd
        end function c_msgsnd
    end interface
end module unix_msg
