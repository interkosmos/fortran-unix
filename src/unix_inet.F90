! unix_inet.F90
!
! Author:  Philipp Engel
! Licence: ISC
module unix_inet
    use, intrinsic :: iso_c_binding
    use :: unix_types
    implicit none
    private

    public :: c_htonl
    public :: c_htons
    public :: c_inet_addr

    interface
        ! uint32_t htonl(uint32_t host)
        function c_htonl(host) bind(c, name='htonl')
            import :: c_uint32_t
            implicit none
            integer(kind=c_uint32_t), intent(in), value :: host
            integer(kind=c_uint32_t)                    :: c_htonl
        end function c_htonl

        ! uint16_t htons(uint16_t host)
        function c_htons(host) bind(c, name='htons')
            import :: c_uint16_t
            implicit none
            integer(kind=c_uint16_t), intent(in), value :: host
            integer(kind=c_uint16_t)                    :: c_htons
        end function c_htons

        ! in_addr_t inet_addr(const char *cp)
        function c_inet_addr(cp) bind(c, name='inet_addr')
            import :: c_char, c_in_addr_t
            implicit none
            character(kind=c_char), intent(in) :: cp
            integer(kind=c_in_addr_t)          :: c_inet_addr
        end function c_inet_addr
    end interface
end module unix_inet
