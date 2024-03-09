! unix_time.F90
!
! Author:  Philipp Engel
! Licence: ISC
module unix_time
    use, intrinsic :: iso_c_binding
    use :: unix_types
    implicit none
    private

#if defined (__linux__)

    integer(kind=c_int), parameter, public :: CLOCK_REALTIME           = 0
    integer(kind=c_int), parameter, public :: CLOCK_MONOTONIC          = 1
    integer(kind=c_int), parameter, public :: CLOCK_PROCESS_CPUTIME_ID = 2
    integer(kind=c_int), parameter, public :: CLOCK_THREAD_CPUTIME_ID  = 3
    integer(kind=c_int), parameter, public :: CLOCK_MONOTONIC_RAW      = 4
    integer(kind=c_int), parameter, public :: CLOCK_REALTIME_COARSE    = 5
    integer(kind=c_int), parameter, public :: CLOCK_MONOTONIC_COARSE   = 6
    integer(kind=c_int), parameter, public :: CLOCK_BOOTTIME           = 7
    integer(kind=c_int), parameter, public :: CLOCK_REALTIME_ALARM     = 8
    integer(kind=c_int), parameter, public :: CLOCK_BOOTTIME_ALARM     = 9
    integer(kind=c_int), parameter, public :: CLOCK_TAI                = 11

    integer(kind=c_int), parameter, public :: TIMER_ABSTIME = 1

#elif defined (__FreeBSD__)

    integer(kind=c_int), parameter, public :: CLOCK_REALTIME           = 0
    integer(kind=c_int), parameter, public :: CLOCK_VIRTUAL            = 1
    integer(kind=c_int), parameter, public :: CLOCK_PROF               = 2
    integer(kind=c_int), parameter, public :: CLOCK_MONOTONIC          = 4
    integer(kind=c_int), parameter, public :: CLOCK_UPTIME             = 5
    integer(kind=c_int), parameter, public :: CLOCK_UPTIME_PRECISE     = 7
    integer(kind=c_int), parameter, public :: CLOCK_UPTIME_FAST        = 8
    integer(kind=c_int), parameter, public :: CLOCK_REALTIME_PRECISE   = 9
    integer(kind=c_int), parameter, public :: CLOCK_REALTIME_FAST      = 10
    integer(kind=c_int), parameter, public :: CLOCK_MONOTONIC_PRECISE  = 11
    integer(kind=c_int), parameter, public :: CLOCK_MONOTONIC_FAST     = 12
    integer(kind=c_int), parameter, public :: CLOCK_SECOND             = 13
    integer(kind=c_int), parameter, public :: CLOCK_THREAD_CPUTIME_ID  = 14
    integer(kind=c_int), parameter, public :: CLOCK_PROCESS_CPUTIME_ID = 15

    integer(kind=c_int), parameter, public :: TIMER_RELTIME = 0
    integer(kind=c_int), parameter, public :: TIMER_ABSTIME = 1

#endif

    ! struct timespec
    type, bind(c), public :: c_timespec
        integer(kind=c_time_t) :: tv_sec  = 0_c_time_t
        integer(kind=c_long)   :: tv_nsec = 0_c_long
    end type c_timespec

    ! struct timeval
    type, bind(c), public :: c_timeval
        integer(kind=c_time_t)      :: tv_sec  = 0_c_time_t
        integer(kind=c_suseconds_t) :: tv_usec = 0_c_suseconds_t
    end type c_timeval

    ! struct timezone
    type, bind(c), public :: c_timezone
        integer(kind=c_int) :: tz_minuteswest = 0 ! Minutes west of Greenwich.
        integer(kind=c_int) :: tz_dsttime     = 0 ! Type of DST correction.
    end type c_timezone

    ! struct tm
    type, bind(c), public :: c_tm
        integer(kind=c_int)  :: tm_sec    = 0          ! Seconds after minute (0 - 59).
        integer(kind=c_int)  :: tm_min    = 0          ! Minutes after hour (0 - 59).
        integer(kind=c_int)  :: tm_hour   = 0          ! Hours since midnight (0 - 23).
        integer(kind=c_int)  :: tm_mday   = 0          ! Day of month (1 - 31).
        integer(kind=c_int)  :: tm_mon    = 0          ! Month (0 - 11).
        integer(kind=c_int)  :: tm_year   = 0          ! Year (current year minus 1900).
        integer(kind=c_int)  :: tm_wday   = 0          ! Day of week (0 - 6; Sunday = 0).
        integer(kind=c_int)  :: tm_yday   = 0          ! Day of year (0 - 365).
        integer(kind=c_int)  :: tm_isdst  = 0          ! Positive if daylight saving time is in effect.
        integer(kind=c_long) :: tm_gmtoff = 0_c_long   ! Offset from UTC in seconds.
        type(c_ptr)          :: tm_zone   = c_null_ptr ! Abbreviation of timezone name (const char *).
    end type c_tm

    public :: c_asctime
    public :: c_clock_gettime
    public :: c_ctime
    public :: c_gettimeofday
    public :: c_gmtime
    public :: c_gmtime_r
    public :: c_localtime
    public :: c_localtime_r
    public :: c_mktime
    public :: c_strftime
    public :: c_time
    public :: c_timegm

    interface
        ! char *asctime(const struct tm *timeptr)
        function c_asctime(timeptr) bind(c, name='asctime')
            import :: c_ptr, c_tm
            implicit none
            type(c_tm), intent(in) :: timeptr
            type(c_ptr)            :: c_asctime
        end function c_asctime

        ! int clock_gettime(clockid_t clk_id, struct timespec *tp)
        function c_clock_gettime(clk_id, tp) bind(c, name='clock_gettime')
            import :: c_clockid_t, c_int, c_timespec
            implicit none
            integer(kind=c_clockid_t), intent(in), value :: clk_id
            type(c_timespec),          intent(out)       :: tp
            integer(kind=c_int)                          :: c_clock_gettime
        end function c_clock_gettime

        ! char *ctime(const time_t *clock)
        function c_ctime(clock) bind(c, name='ctime')
            import :: c_ptr, c_time_t
            integer(kind=c_time_t), intent(in) :: clock
            type(c_ptr)                        :: c_ctime
        end function c_ctime

        ! int gettimeofday(struct timeval *tv, struct timezone *tz)
        function c_gettimeofday(tv, tz) bind(c, name='gettimeofday')
            import :: c_int, c_timeval, c_timezone
            implicit none
            type(c_timeval),  intent(out) :: tv
            type(c_timezone), intent(in)  :: tz
            integer(kind=c_int)           :: c_gettimeofday
        end function c_gettimeofday

        ! struct tm *gmtime(const time_t *timer)
        function c_gmtime(timer) bind(c, name='gmtime')
            import :: c_ptr, c_time_t
            implicit none
            integer(kind=c_time_t), intent(in) :: timer
            type(c_ptr)                        :: c_gmtime
        end function c_gmtime

        ! struct tm *gmtime_r(const time_t *timer, struct tm *result)
        function c_gmtime_r(timer, result) bind(c, name='gmtime_r')
            import :: c_ptr, c_time_t, c_tm
            implicit none
            integer(kind=c_time_t), intent(in)    :: timer
            type(c_tm),             intent(inout) :: result
            type(c_ptr)                           :: c_gmtime_r
        end function c_gmtime_r

        ! struct tm *localtime(const time_t *timer)
        function c_localtime(timer) bind(c, name='localtime')
            import :: c_ptr, c_time_t
            implicit none
            integer(kind=c_time_t), intent(in) :: timer
            type(c_ptr)                        :: c_localtime
        end function c_localtime

        ! struct tm *localtime_r(const time_t *timer, struct tm *result)
        function c_localtime_r(timer, result) bind(c, name='localtime_r')
            import :: c_ptr, c_time_t, c_tm
            implicit none
            integer(kind=c_time_t), intent(in)    :: timer
            type(c_tm),             intent(inout) :: result
            type(c_ptr)                           :: c_localtime_r
        end function c_localtime_r

        ! time_t mktime(struct tm *tm)
        function c_mktime(tm) bind(c, name='mktime')
            import :: c_time_t, c_tm
            implicit none
            type(c_tm), intent(inout) :: tm
            integer(kind=c_time_t)    :: c_mktime
        end function c_mktime

        ! size_t strftime(char *s, size_t max, const char *format, const struct tm *tm)
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

        ! time_t timegm(struct tm *tm)
        function c_timegm(tm) bind(c, name='timegm')
            import :: c_time_t, c_tm
            implicit none
            type(c_tm), intent(in) :: tm
            integer(kind=c_time_t) :: c_timegm
        end function c_timegm
    end interface
end module unix_time
