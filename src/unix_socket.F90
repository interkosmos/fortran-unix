! unix_socket.F90
!
! Author:  Philipp Engel
! Licence: ISC
module unix_socket
    use, intrinsic :: iso_c_binding
    use :: unix_types
    implicit none
    private

#if defined (__linux__)

    integer(kind=c_int), parameter, public :: SOL_SOCKET     = 1

    integer(kind=c_int), parameter, public :: SO_DEBUG       = 1
    integer(kind=c_int), parameter, public :: SO_REUSEADDR   = 2
    integer(kind=c_int), parameter, public :: SO_TYPE        = 3
    integer(kind=c_int), parameter, public :: SO_ERROR       = 4
    integer(kind=c_int), parameter, public :: SO_DONTROUTE   = 5
    integer(kind=c_int), parameter, public :: SO_BROADCAST   = 6
    integer(kind=c_int), parameter, public :: SO_SNDBUF      = 7
    integer(kind=c_int), parameter, public :: SO_RCVBUF      = 8
    integer(kind=c_int), parameter, public :: SO_SNDBUFFORCE = 32
    integer(kind=c_int), parameter, public :: SO_RCVBUFFORCE = 33
    integer(kind=c_int), parameter, public :: SO_KEEPALIVE   = 9
    integer(kind=c_int), parameter, public :: SO_OOBINLINE   = 10
    integer(kind=c_int), parameter, public :: SO_NO_CHECK    = 11
    integer(kind=c_int), parameter, public :: SO_PRIORITY    = 12
    integer(kind=c_int), parameter, public :: SO_LINGER      = 13
    integer(kind=c_int), parameter, public :: SO_BSDCOMPAT   = 14
    integer(kind=c_int), parameter, public :: SO_REUSEPORT   = 15

#elif defined (__FreeBSD__)

    integer(kind=c_int), parameter, public :: SOL_SOCKET    = int(z'ffff')

    integer(kind=c_int), parameter, public :: SO_DEBUG      = int(z'00000001')
    integer(kind=c_int), parameter, public :: SO_ACCEPTCONN = int(z'00000002')
    integer(kind=c_int), parameter, public :: SO_REUSEADDR  = int(z'00000004')
    integer(kind=c_int), parameter, public :: SO_KEEPALIVE  = int(z'00000008')
    integer(kind=c_int), parameter, public :: SO_DONTROUTE  = int(z'00000010')
    integer(kind=c_int), parameter, public :: SO_BROADCAST  = int(z'00000020')

#endif

    public :: c_accept
    public :: c_bind
    public :: c_connect
    public :: c_listen
    public :: c_send
    public :: c_setsockopt
    public :: c_socket

    interface
        ! int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen)
        function c_accept(sockfd, addr, addrlen) bind(c, name='accept')
            import :: c_int, c_ptr, c_size_t, c_socklen_t
            implicit none
            integer(kind=c_int),       intent(in), value :: sockfd
            type(c_ptr),               intent(in), value :: addr
            integer(kind=c_socklen_t), intent(in), value :: addrlen
            integer(kind=c_int)                          :: c_accept
        end function c_accept

        ! int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
        function c_bind(sockfd, addr, addrlen) bind(c, name='bind')
            import :: c_int, c_ptr, c_size_t, c_socklen_t
            implicit none
            integer(kind=c_int),       intent(in), value :: sockfd
            type(c_ptr),               intent(in), value :: addr
            integer(kind=c_socklen_t), intent(in), value :: addrlen
            integer(kind=c_int)                          :: c_bind
        end function c_bind

        ! int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen)
        function c_connect(sockfd, addr, addrlen) bind(c, name='connect')
            import :: c_int, c_ptr, c_size_t, c_socklen_t
            implicit none
            integer(kind=c_int),       intent(in), value :: sockfd
            type(c_ptr),               intent(in), value :: addr
            integer(kind=c_socklen_t), intent(in), value :: addrlen
            integer(kind=c_int)                          :: c_connect
        end function c_connect

        ! int listen(int sockfd, int backlog)
        function c_listen(sockfd, backlog) bind(c, name='listen')
            import :: c_int
            implicit none
            integer(kind=c_int), intent(in), value :: sockfd
            integer(kind=c_int), intent(in), value :: backlog
            integer(kind=c_int)                    :: c_listen
        end function c_listen

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

        ! int setsockopt(int sockfd, int level, int optname, const void *optval, socklen_t optlen)
        function c_setsockopt(sockfd, level, optname, optval, optlen) bind(c, name='setsockopt')
            import :: c_int, c_ptr, c_socklen_t
            implicit none
            integer(kind=c_int),       intent(in), value :: sockfd
            integer(kind=c_int),       intent(in), value :: level
            integer(kind=c_int),       intent(in), value :: optname
            type(c_ptr),               intent(in), value :: optval
            integer(kind=c_socklen_t), intent(in), value :: optlen
            integer(kind=c_int)                          :: c_setsockopt
        end function c_setsockopt

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
