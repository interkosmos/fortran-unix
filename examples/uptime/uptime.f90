! uptime.f90
!
! Author:  Philipp Engel
! Licence: ISC
program main
    !! Prints system uptime to standard output, similar to uptime(1).
    use, intrinsic :: iso_fortran_env, only: i8 => int64
    use :: unix
    implicit none

    integer          :: days, hrs, mins, secs
    integer(kind=i8) :: delta

    call system_uptime(delta)
    call time_delta_from_seconds(delta, days, hrs, mins, secs)

    print '(i0, " days ", i0, " hrs ", i0, " mins ", i0, " secs")', days, hrs, mins, secs
contains
    subroutine system_uptime(time)
        integer(kind=i8), intent(out) :: time

        type(c_timespec) :: tp

        time = 0_i8
        if (c_clock_gettime(CLOCK_MONOTONIC, tp) /= 0) return
        time = tp%tv_sec
        if (time > 60) time = time + 30
    end subroutine system_uptime

    elemental subroutine time_delta_from_seconds(delta, days, hrs, mins, secs)
        integer(kind=i8), intent(out) :: delta
        integer,          intent(out) :: days
        integer,          intent(out) :: hrs
        integer,          intent(out) :: mins
        integer,          intent(out) :: secs

        integer(kind=i8) :: t

        t = delta
        days = int(t / 86400)
        t = modulo(t, 86400_i8)
        hrs  = int(t / 3600)
        t = modulo(t, 3600_i8)
        mins = int(t / 60)
        secs = int(modulo(t, 60_i8))
    end subroutine time_delta_from_seconds
end program main
