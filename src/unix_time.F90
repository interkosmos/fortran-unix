! unix_time.F90
module unix_time
    use, intrinsic :: iso_c_binding
    use :: unix_types
    implicit none
    private

    public :: c_asctime
    public :: c_localtime_r
    public :: c_strftime
    public :: c_time

    type, bind(c), public :: c_tm
        integer(kind=c_int) :: tm_sec   ! Seconds after minute (0 - 59).
        integer(kind=c_int) :: tm_min   ! Minutes after hour (0 - 59).
        integer(kind=c_int) :: tm_hour  ! Hours since midnight (0 - 23).
        integer(kind=c_int) :: tm_mday  ! Day of month (1 - 31).
        integer(kind=c_int) :: tm_mon   ! Month (0 - 11).
        integer(kind=c_int) :: tm_year  ! Year (current year minus 1900).
        integer(kind=c_int) :: tm_wday  ! Day of week (0 - 6; Sunday = 0).
        integer(kind=c_int) :: tm_yday  ! Day of year (0 - 365).
        integer(kind=c_int) :: tm_isdst ! Positive if daylight saving time is in effect.
    end type c_tm

    type, bind(c), public :: c_timespec
        integer(kind=c_time_t) :: tv_sec
        integer(kind=c_long)   :: tv_nsec
    end type c_timespec

    interface
        ! char *asctime(const struct tm *timeptr)
        function c_asctime(timeptr) bind(c, name='asctime')
            import :: c_ptr, c_tm
            implicit none
            type(c_tm), intent(in) :: timeptr
            type(c_ptr)            :: c_asctime
        end function c_asctime

        ! struct tm *localtime_r(const time_t *restrict timer, struct tm *restrict result)
        function c_localtime_r(timer, result) bind(c, name='localtime_r')
            import :: c_ptr, c_time_t, c_tm
            integer(kind=c_time_t), intent(in)    :: timer
            type(c_tm),             intent(inout) :: result
            type(c_ptr)                           :: c_localtime_r
        end function c_localtime_r

        ! size_t strftime(char *restrict s, size_t max, const char *restrict format, const struct tm *restrict tm)
        function c_strftime(s, max, format, tm) bind(c, name='strftime')
            import :: c_char, c_size_t, c_tm
            implicit none
            character(kind=c_char), intent(in)        :: s
            integer(kind=c_size_t), intent(in), value :: max
            character(kind=c_char), intent(in)        :: format
            type(c_tm),             intent(in)        :: tm
            integer(kind=c_size_t)                    :: c_strftime
        end function c_strftime

        ! time_t time(time_t *tloc)
        function c_time(tloc) bind(c, name='time')
            import :: c_time_t
            implicit none
            integer(kind=c_time_t), intent(in), value :: tloc
            integer(kind=c_time_t)                    :: c_time
        end function c_time
    end interface
end module unix_time
