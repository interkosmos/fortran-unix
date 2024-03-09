! unix.f90
!
! A collection of Fortran 2008 ISO C binding interfaces to selected POSIX and
! SysV routines on 64-bit Unix-like operating systems.
!
! Author:  Philipp Engel
! Licence: ISC
module unix
    use, intrinsic :: iso_c_binding
    use :: unix_dirent
    use :: unix_errno
    use :: unix_fcntl
    use :: unix_inet
    use :: unix_ipc
    use :: unix_ioctl
    use :: unix_mqueue
    use :: unix_msg
    use :: unix_netdb
    use :: unix_pthread
    use :: unix_regex
    use :: unix_semaphore
    use :: unix_signal
    use :: unix_socket
    use :: unix_stat
    use :: unix_stdio
    use :: unix_stdlib
    use :: unix_string
    use :: unix_syslog
    use :: unix_termios
    use :: unix_time
    use :: unix_types
    use :: unix_unistd
    use :: unix_utsname
    use :: unix_wait
    implicit none

    interface c_int_to_uint
        !! Converts signed integer to unsigned integer.
        module procedure :: c_int32_to_uint16
        module procedure :: c_int64_to_uint32
    end interface

    interface c_uint_to_int
        !! Converts unsigned integer to signed integer.
        module procedure :: c_uint16_to_int32
        module procedure :: c_uint32_to_int64
    end interface

    public :: c_f_str_chars
    public :: c_f_str_ptr
    public :: c_int32_to_uint16
    public :: c_int64_to_uint32
    public :: c_int_to_uint
    public :: c_uint16_to_int32
    public :: c_uint32_to_int64
    public :: c_uint_to_int
    public :: f_c_str_chars
    public :: f_readdir
    public :: f_strerror
contains
    pure elemental function c_int32_to_uint16(s) result(u)
        !! Converts signed `c_int32_t` integer to unsigned `c_uint16_t` integer.
        integer(kind=c_int32_t), intent(in) :: s !! Signed integer.
        integer(kind=c_uint16_t)            :: u !! Unsigned integer.

        integer(kind=c_int32_t) :: i

        i = modulo(s, 65536_c_int32_t)

        if (i < 32768_c_int32_t) then
            u = int(i, kind=c_uint16_t)
        else
            u = int(i - 65536_c_int32_t, kind=c_uint16_t)
        end if
    end function c_int32_to_uint16

    pure elemental function c_int64_to_uint32(s) result(u)
        !! Converts signed `c_int64_t` integer to unsigned `c_uint32_t` integer.
        integer(kind=c_int64_t), intent(in) :: s !! Signed integer.
        integer(kind=c_uint32_t)            :: u !! Unsigned integer.

        integer(kind=c_int64_t) :: i

        i = modulo(s, 4294967296_c_int64_t)

        if (i < 2147483648_c_int64_t) then
            u = int(i, kind=c_uint32_t)
        else
            u = int(i - 4294967296_c_int64_t, kind=c_uint32_t)
        end if
    end function c_int64_to_uint32

    pure elemental function c_uint16_to_int32(u) result(s)
        !! Converts unsigned `uint16_t` integer to signed `int32_t` integer.
        integer(kind=c_uint16_t), intent(in) :: u !! Unsigned integer.
        integer(kind=c_int32_t)              :: s !! Signed integer.

        if (u > 0) then
            s = int(u, kind=c_int32_t)
        else
            s = 65536_c_int32_t + int(u, kind=c_int32_t)
        end if
    end function c_uint16_to_int32

    pure elemental function c_uint32_to_int64(u) result(s)
        !! Converts unsigned `uint32_t` integer to signed `int64_t` integer.
        integer(kind=c_uint32_t), intent(in) :: u !! Unsigned integer.
        integer(kind=c_int64_t)              :: s !! Signed integer.

        if (u > 0) then
            s = int(u, kind=c_int64_t)
        else
            s = 4294967296_c_int64_t + int(u, kind=c_int64_t)
        end if
    end function c_uint32_to_int64

    function f_readdir(dirp)
        !! Wrapper function that calls `c_readdir()` and converts the returned
        !! C pointer to Fortran pointer.
        type(c_ptr), intent(in) :: dirp

        type(c_dirent), pointer :: f_readdir
        type(c_ptr)             :: ptr

        f_readdir => null()
        ptr = c_readdir(dirp)
        if (.not. c_associated(ptr)) return
        call c_f_pointer(ptr, f_readdir)
    end function f_readdir

    function f_strerror(errnum) result(str)
        !! Wrapper function for `c_strerr()` that converts the returned C char
        !! array pointer to Fortran string.
        integer, intent(in)           :: errnum
        character(len=:), allocatable :: str

        type(c_ptr) :: ptr

        ptr = c_strerror(errnum)
        call c_f_str_ptr(ptr, str)
    end function f_strerror

    subroutine c_f_str_chars(c_str, f_str)
        !! Copies a C string, passed as a C char array, to a Fortran string.
        character(kind=c_char),     intent(inout) :: c_str(:)
        character(len=size(c_str)), intent(out)   :: f_str

        integer :: i

        f_str = ' '

        do i = 1, size(c_str)
            if (c_str(i) == c_null_char) exit
            f_str(i:i) = c_str(i)
        end do
    end subroutine c_f_str_chars

    subroutine c_f_str_ptr(c_str, f_str)
        !! Copies a C string, passed as a C pointer, to a Fortran string.
        type(c_ptr),                   intent(in)  :: c_str
        character(len=:), allocatable, intent(out) :: f_str

        character(kind=c_char), pointer :: ptrs(:)
        integer(kind=c_size_t)          :: i, sz

        copy_block: block
            if (.not. c_associated(c_str)) exit copy_block
            sz = c_strlen(c_str)
            if (sz < 0) exit copy_block
            call c_f_pointer(c_str, ptrs, [ sz ])
            allocate (character(len=sz) :: f_str)

            do i = 1, sz
                f_str(i:i) = ptrs(i)
            end do

            return
        end block copy_block

        if (.not. allocated(f_str)) f_str = ''
    end subroutine c_f_str_ptr

    subroutine f_c_str_chars(f_str, c_str)
        !! Copies a Fortran string to a C char array.
        character(len=*),       intent(in)  :: f_str
        character(kind=c_char), intent(out) :: c_str(len(f_str))

        integer :: i

        c_str = c_null_char

        do i = 1, len(f_str)
            c_str(i) = f_str(i:i)
        end do
    end subroutine f_c_str_chars
end module unix
