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
    use :: unix_ipc
    use :: unix_mqueue
    use :: unix_msg
    use :: unix_netdb
    use :: unix_pthread
    use :: unix_regex
    use :: unix_signal
    use :: unix_socket
    use :: unix_stat
    use :: unix_stdio
    use :: unix_stdlib
    use :: unix_string
    use :: unix_time
    use :: unix_types
    use :: unix_unistd
    use :: unix_wait
    implicit none

    public :: f_readdir
    public :: f_strerror

    public :: c_f_str_chars
    public :: c_f_str_ptr
    public :: f_c_str_chars
contains
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

    function f_strerror(errnum)
        !! Wrapper function for `c_strerr()` that converts the returned C char
        !! array pointer to Fortran string.
        integer,           intent(in) :: errnum
        character(len=:), allocatable :: f_strerror
        type(c_ptr)                   :: ptr
        integer(kind=8)               :: size

        ptr = c_strerror(errnum)
        if (.not. c_associated(ptr)) return
        size = c_strlen(ptr)
        allocate (character(len=size) :: f_strerror)
        call c_f_str_ptr(ptr, f_strerror)
    end function f_strerror

    subroutine c_f_str_chars(c_str, f_str)
        !! Copies a C string, passed as a C char array, to a Fortran string.
        character(len=1, kind=c_char), intent(in)  :: c_str(*)
        character(len=*),              intent(out) :: f_str
        integer                                    :: i

        i = 1

        do while (c_str(i) /= c_null_char .and. i <= len(f_str))
            f_str(i:i) = c_str(i)
            i = i + 1
        end do

        if (i < len(f_str)) f_str(i:) = ' '
    end subroutine c_f_str_chars

    subroutine c_f_str_ptr(c_str, f_str)
        !! Copies a C string, passed as a C pointer, to a Fortran string.
        type(c_ptr),      intent(in)    :: c_str
        character(len=*), intent(out)   :: f_str
        character(kind=c_char), pointer :: ptrs(:)
        integer                         :: i

        if (c_associated(c_str)) then
            call c_f_pointer(c_str, ptrs, [ huge(0) ])

            i = 1

            do while (ptrs(i) /= c_null_char .and. i <= len(f_str))
                f_str(i:i) = ptrs(i)
                i = i + 1
            end do

            if (i < len(f_str)) f_str(i:) = ' '
            return
        end if

        f_str = ' '
    end subroutine c_f_str_ptr

    subroutine f_c_str_chars(f_str, c_str)
        !! Copies a Fortran string to a C char array.
        character(len=*),       intent(in)    :: f_str
        character(kind=c_char), intent(inout) :: c_str(:)
        integer(kind=8)                       :: i

        i = 1

        do while (i <= len(f_str) .and. i <= size(c_str))
            c_str(i) = f_str(i:i)
            i = i + 1
        end do

        if (i < size(c_str)) c_str(i:) = c_null_char
    end subroutine f_c_str_chars
end module unix
