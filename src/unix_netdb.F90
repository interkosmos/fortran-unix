! unix_netdb.F90
!
! Author:  Philipp Engel
! Licence: ISC
module unix_netdb
    use, intrinsic :: iso_c_binding
    use :: unix_fcntl
    use :: unix_types
    implicit none
    private

    integer(kind=c_int), parameter, public :: AF_LOCAL = 1
    integer(kind=c_int), parameter, public :: AF_UNIX  = 1
    integer(kind=c_int), parameter, public :: AF_INET  = 2

    integer(kind=c_int), parameter, public :: SOCK_STREAM    = 1
    integer(kind=c_int), parameter, public :: SOCK_DGRAM     = 2
    integer(kind=c_int), parameter, public :: SOCK_RAW       = 3
    integer(kind=c_int), parameter, public :: SOCK_RDM       = 4
    integer(kind=c_int), parameter, public :: SOCK_SEQPACKET = 5

    integer(kind=c_int), parameter, public :: AI_PASSIVE     = int(z'00000001')
    integer(kind=c_int), parameter, public :: AI_CANONNAME   = int(z'00000002')
    integer(kind=c_int), parameter, public :: AI_NUMERICHOST = int(z'00000004')
    integer(kind=c_int), parameter, public :: AI_NUMERICSERV = int(z'00000008')

    integer(kind=c_in_addr_t), parameter, public :: INADDR_ANY = int(z'00000000')

    ! struct in_addr
    type, bind(c), public :: c_in_addr
        integer(kind=c_int32_t) :: s_addr = 0_c_int32_t
    end type c_in_addr

#if defined (__linux__)

    integer(kind=c_int), parameter, public :: AF_INET6 = 10

    integer(kind=c_int), parameter, public :: SOCK_CLOEXEC  = O_CLOEXEC
    integer(kind=c_int), parameter, public :: SOCK_NONBLOCK = O_NONBLOCK

    integer(kind=c_int), parameter, public :: c_sa_family_t = c_signed_char

    ! struct sockaddr
    type, bind(c), public :: c_sockaddr
        integer(kind=c_sa_family_t) :: sa_family     = 0_c_sa_family_t
        character(kind=c_char)      :: sa_data(0:13) = c_null_char
    end type c_sockaddr

    ! struct addrinfo
    type, bind(c), public :: c_addrinfo
        integer(kind=c_int)       :: ai_flags     = 0
        integer(kind=c_int)       :: ai_family    = 0
        integer(kind=c_int)       :: ai_socktype  = 0
        integer(kind=c_int)       :: ai_protocol  = 0
        integer(kind=c_socklen_t) :: ai_addrlen   = 0_c_socklen_t
        type(c_ptr)               :: ai_addr      = c_null_ptr
        type(c_ptr)               :: ai_canonname = c_null_ptr
        type(c_ptr)               :: ai_next      = c_null_ptr
    end type c_addrinfo

    ! struct sockaddr_in
    type, bind(c), public :: c_sockaddr_in
        integer(kind=c_sa_family_t) :: sin_family = 0_c_sa_family_t
        integer(kind=c_int16_t)     :: sin_port   = 0_c_int16_t
        type(c_in_addr)             :: sin_addr
    end type c_sockaddr_in

#elif defined (__FreeBSD__)

    integer(kind=c_int), parameter, public :: AF_INET6 = 28

    integer(kind=c_int), parameter, public :: SOCK_CLOEXEC  = int(z'10000000')
    integer(kind=c_int), parameter, public :: SOCK_NONBLOCK = int(z'20000000')

    ! struct sockaddr
    type, bind(c), public :: c_sockaddr
        character(kind=c_char) :: sa_len        = c_null_char
        integer(kind=c_int)    :: sa_family     = 0
        character(kind=c_char) :: sa_data(0:13) = c_null_char
    end type c_sockaddr

    ! struct addrinfo
    type, bind(c), public :: c_addrinfo
        integer(kind=c_int)       :: ai_flags     = 0
        integer(kind=c_int)       :: ai_family    = 0
        integer(kind=c_int)       :: ai_socktype  = 0
        integer(kind=c_int)       :: ai_protocol  = 0
        integer(kind=c_socklen_t) :: ai_addrlen   = 0_c_socklen_t
        type(c_ptr)               :: ai_canonname = c_null_ptr
        type(c_ptr)               :: ai_addr      = c_null_ptr
        type(c_ptr)               :: ai_next      = c_null_ptr
    end type c_addrinfo

    ! struct sockaddr_in
    type, bind(c), public :: c_sockaddr_in
        integer(kind=c_int8_t)  :: sin_len       = 0_c_int8_t
        integer(kind=c_int)     :: sin_family    = 0
        integer(kind=c_int16_t) :: sin_port      = 0_c_int16_t
        type(c_in_addr)         :: sin_addr
        character(kind=c_char)  :: sin_zero(0:7) = c_null_char
    end type c_sockaddr_in

#endif

    public :: c_gai_strerror
    public :: c_getaddrinfo
    public :: c_freeaddrinfo

    interface
        ! const char *gai_strerror(int ecode)
        function c_gai_strerror(ecode) bind(c, name='gai_strerror')
            import :: c_int, c_ptr
            implicit none
            integer(kind=c_int), intent(in), value :: ecode
            type(c_ptr)                            :: c_gai_strerror
        end function c_gai_strerror

        ! int getaddrinfo(const char *node, const char *service, const struct addrinfo *hints, struct addrinfo **res)
        function c_getaddrinfo(node, service, hints, res) bind(c, name='getaddrinfo')
            import :: c_int, c_ptr
            implicit none
            type(c_ptr), intent(in), value :: node
            type(c_ptr), intent(in), value :: service
            type(c_ptr), intent(in), value :: hints
            type(c_ptr), intent(in)        :: res
            integer(kind=c_int)            :: c_getaddrinfo
        end function c_getaddrinfo

        ! void freeaddrinfo(struct addrinfo *res)
        subroutine c_freeaddrinfo(res) bind(c, name='freeaddrinfo')
            import :: c_ptr
            implicit none
            type(c_ptr), intent(in), value :: res
        end subroutine c_freeaddrinfo
    end interface
end module unix_netdb
