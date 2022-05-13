! unix_string.F90
module unix_string
    use, intrinsic :: iso_c_binding
    implicit none
    private

    public :: c_memcpy
    public :: c_memset
    public :: c_strerror
    public :: c_strlen

    interface
        ! void *memset(void *dst, const void *src, size_t len)
        function c_memcpy(dst, src, len) bind(c, name='memset')
            import :: c_ptr, c_size_t
            implicit none
            type(c_ptr),            intent(in), value :: dst
            type(c_ptr),            intent(in), value :: src
            integer(kind=c_size_t), intent(in), value :: len
            type(c_ptr)                               :: c_memcpy
        end function c_memcpy

        ! void *memset(void *dest, int c, size_t len)
        function c_memset(dest, c, len) bind(c, name='memset')
            import :: c_int, c_ptr, c_size_t
            implicit none
            type(c_ptr),            intent(in), value :: dest
            integer(kind=c_int),    intent(in), value :: c
            integer(kind=c_size_t), intent(in), value :: len
            type(c_ptr)                               :: c_memset
        end function c_memset

        ! char *strerror(int errnum)
        function c_strerror(errnum) bind(c, name='strerror')
            import :: c_int, c_ptr
            implicit none
            integer(kind=c_int), intent(in), value :: errnum
            type(c_ptr)                            :: c_strerror
        end function c_strerror

        ! size_t strlen(const char *str)
        function c_strlen(str) bind(c, name='strlen')
            import :: c_ptr, c_size_t
            implicit none
            type(c_ptr), intent(in), value :: str
            integer(kind=c_size_t)         :: c_strlen
        end function c_strlen
    end interface
end module unix_string
