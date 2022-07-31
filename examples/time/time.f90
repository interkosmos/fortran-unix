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
    character(len=32)             :: iso
    character(len=:), allocatable :: str
    integer(kind=i8)              :: rc, mk
    integer(kind=c_time_t)        :: ts
    type(c_tm)                    :: tm1, tm2
    type(c_ptr)                   :: ptr, str_ptr

    ! Print UNIX timestamp.
    ts = c_time(int(0, kind=c_time_t))
    print '("UNIX Timestamp: ", i0)', ts

    ! Output date and time in ISO 8601.
    ptr = c_localtime_r(ts, tm1)
    iso = ' '
    rc  = c_strftime(iso, len(iso, kind=c_size_t), '%FT%T' // c_null_char, tm1)
    print '("ISO 8601......: ", a)', iso

    mk = c_mktime(tm1)
    print '("UNIX Timestamp: ", i0)', mk

    ! Print date and time string (of 2020-10-01 12:00:00).
    ! The C function `asctime()` returns a null-terminated string
    ! that is of the form `Thu Oct  1 12:00:00 2020\n`.
    tm2 = c_tm(tm_sec   = 0, &
               tm_min   = 0, &
               tm_hour  = 12, &
               tm_mday  = 1, &
               tm_mon   = 9, &
               tm_year  = 2020 - 1900, &
               tm_wday  = 4, &
               tm_yday  = 0, &
               tm_isdst = 0)
    str_ptr = c_asctime(tm2)

    call c_f_str_ptr(str_ptr, str)
    print '("Date and Time.: ", a)', str(1:24)
end program main
