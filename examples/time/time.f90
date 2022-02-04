! time.f90
!
! Example that calls POSIX time functions.
!
! Author:  Philipp Engel
! Licence: ISC
program main
    use, intrinsic :: iso_c_binding
    use :: unix
    implicit none
    character(len=19)             :: iso
    character(len=:), allocatable :: str
    integer(kind=8)               :: rc
    integer(kind=c_time_t)        :: ts
    type(c_tm)                    :: tm
    type(c_ptr)                   :: ptr, str_ptr

    ! Print UNIX timestamp.
    ts = c_time(int(0, kind=c_time_t))
    print '("UNIX Timestamp: ", i0)', ts

    ! Output date and time in ISO 8601.
    ptr = c_localtime_r(ts, tm)
    rc  = c_strftime(iso, len(iso, kind=c_size_t), '%FT%T' // c_null_char, tm)
    print '("ISO 8601......: ", a)', iso

    ! Print date and time string (of 2020-10-01 12:00:00).
    ! The C function `asctime()` returns a null-terminated string
    ! that is of the form `Thu Oct  1 12:00:00 2020\n`.
    tm      = c_tm(0, 0, 12, 1, 9, 2020 - 1900, 4, 0, 0)
    str_ptr = c_asctime(tm)

    call c_f_str_ptr(str_ptr, str)
    print '("Date and Time.: ", a)', str(1:24)
end program main
