! unix_time.f90
module unix_time
    use, intrinsic :: iso_c_binding
    implicit none
    private

    public :: c_asctime
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

    interface
        ! char *asctime(const struct tm *timeptr)
        function c_asctime(timeptr) bind(c, name='asctime')
            import :: c_ptr, c_tm
            implicit none
            type(c_tm), intent(in) :: timeptr
            type(c_ptr)            :: c_asctime
        end function c_asctime

        ! time_t time(time_t *tloc)
        function c_time(tloc) bind(c, name='time')
            import :: c_long
            implicit none
            integer(kind=c_long), intent(in), value :: tloc
            integer(kind=c_long)                    :: c_time
        end function c_time
    end interface
end module unix_time
