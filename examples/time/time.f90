! time.f90
!
! Author:  Philipp Engel
! Licence: ISC
program main
    !! Example that calls POSIX time functions.
    use :: unix
    implicit none

    call timestamp()
    call strftime()
    call mktime()
    call asctime()
    call iso8601()
contains
    subroutine asctime()
        !! Prints date and time string (of 2020-10-01 12:00:00).
        !! The C function `asctime()` returns a null-terminated string
        !! that is of the form `Thu Oct  1 12:00:00 2020\n`.
        character(len=:), allocatable :: str
        type(c_tm)                    :: tm
        type(c_ptr)                   :: ptr

        tm = c_tm(tm_sec   = 0, &
                  tm_min   = 0, &
                  tm_hour  = 12, &
                  tm_mday  = 1, &
                  tm_mon   = 9, &
                  tm_year  = 2020 - 1900, &
                  tm_wday  = 4, &
                  tm_yday  = 0, &
                  tm_isdst = 0)
        ptr = c_asctime(tm)

        call c_f_str_ptr(ptr, str)
        print '("Date and Time.: ", a)', str(1:24)
    end subroutine asctime

    subroutine iso8601()
        character(len=*), parameter :: FMT_ISO = &
            '(i0.4, 2("-", i0.2), "T", 2(i0.2, ":"), i0.2, ".", i0.6, sp, i0.2, ss, ":", i0.2)'

        character(len=32) :: iso

        integer :: stat
        integer :: year, month, day
        integer :: hour, minute, second, usecond
        integer :: zone_hour, zone_min

        type(c_ptr)      :: ptr
        type(c_timeval)  :: tv
        type(c_timezone) :: tz
        type(c_tm)       :: tm

        stat = c_gettimeofday(tv, tz)
        ptr  = c_localtime_r(tv%tv_sec, tm)

        year    = tm%tm_year + 1900
        month   = tm%tm_mon + 1
        day     = tm%tm_mday
        hour    = tm%tm_hour
        minute  = tm%tm_min
        second  = tm%tm_sec
        usecond = int(tv%tv_usec)

        zone_hour = int(tm%tm_gmtoff) / 3600
        zone_min  = modulo(int(tm%tm_gmtoff) / 60, 60)

        write (iso, FMT_ISO) year, month, day, hour, minute, second, usecond, &
                             zone_hour, zone_min
        print '("ISO 8601......: ", a)', iso
    end subroutine iso8601

    subroutine mktime()
        !! Prints UNIX timestamp.
        integer(kind=c_time_t) :: mk, ts
        type(c_ptr)            :: ptr
        type(c_tm)             :: tm

        ts  = c_time(0_c_time_t)
        ptr = c_localtime_r(ts, tm)
        mk  = c_mktime(tm)
        print '("UNIX Timestamp: ", i0)', mk
    end subroutine mktime

    subroutine strftime()
        !! Outputs date and time in ISO 8601.
        character(len=32)      :: iso
        integer(kind=c_size_t) :: sz
        integer(kind=c_time_t) :: ts
        type(c_ptr)            :: ptr
        type(c_tm)             :: tm

        iso = ' '
        ts  = c_time(0_c_time_t)
        ptr = c_localtime_r(ts, tm)
        sz  = c_strftime(iso, len(iso, kind=c_size_t), '%FT%T' // c_null_char, tm)
        print '("ISO 8601......: ", a)', iso
    end subroutine strftime

    subroutine timestamp()
        !! Prints UNIX timestamp.
        integer(kind=c_time_t) :: ts

        ts = c_time(0_c_time_t)
        print '("UNIX Timestamp: ", i0)', ts
    end subroutine timestamp
end program main
