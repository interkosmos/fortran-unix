! unix_socket.F90
module unix_socket
    use, intrinsic :: iso_c_binding
    use :: unix_types
    implicit none
    private

    public :: c_connect
    public :: c_send
    public :: c_socket

    interface
        ! int connect(int s, const struct sockaddr *name, socklen_t namelen)
        function c_connect(s, name, namelen) bind(c, name='connect')
            import :: c_int, c_ptr, c_size_t, c_socklen_t
            implicit none
            integer(kind=c_int),       intent(in), value :: s
            type(c_ptr),               intent(in), value :: name
            integer(kind=c_socklen_t), intent(in), value :: namelen
            integer(kind=c_int)                          :: c_connect
        end function c_connect

        ! ssize_t send(int sockfd, const void *buf, size_t len, int flags)
        function c_send(sockfd, buf, len, flags) bind(c, name='send')
            import :: c_int, c_ptr, c_size_t
            implicit none
            integer(kind=c_int),    intent(in), value :: sockfd
            type(c_ptr),            intent(in), value :: buf
            integer(kind=c_size_t), intent(in), value :: len
            integer(kind=c_int),    intent(in), value :: flags
            integer(kind=c_size_t)                    :: c_send
        end function c_send

        ! int socket(int domain, int type, int protocol)
        function c_socket(domain, type, protocol) bind(c, name='socket')
            import :: c_int
            implicit none
            integer(kind=c_int), intent(in), value :: domain
            integer(kind=c_int), intent(in), value :: type
            integer(kind=c_int), intent(in), value :: protocol
            integer(kind=c_int)                    :: c_socket
        end function c_socket
    end interface
end module unix_socket
