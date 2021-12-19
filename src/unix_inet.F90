! unix_inet.F90
module unix_inet
    use, intrinsic :: iso_c_binding
    implicit none
    private

    public :: c_htons
    public :: c_inet_addr

    interface
        ! uint16_t htons(uint16_t host)
        function c_htons(host) bind(c, name='htons')
            import :: c_int16_t
            implicit none
            integer(kind=c_int16_t), intent(in), value :: host
            integer(kind=c_int16_t)                    :: c_htons
        end function c_htons

         ! in_addr_t inet_addr(const char *cp)
        function c_inet_addr(cp) bind(c, name='inet_addr')
            import :: c_char, c_int32_t
            implicit none
            character(kind=c_char), intent(in) :: cp
            integer(kind=c_int32_t)            :: c_inet_addr
        end function c_inet_addr
    end interface
end module unix_inet
