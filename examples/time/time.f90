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
    character(len=24) :: str ! Date and time string.
    integer(kind=8)   :: ts  ! UNIX timestamp.
    type(c_tm)        :: tm  ! Broken-down time.
    type(c_ptr)       :: ptr ! C pointer to char.

    ! Print UNIX timestamp.
    ts = c_time(int(0, kind=8))
    print '("UNIX Timestamp: ", i0)', ts

    ! Print date and time string (of 2020-10-01 12:00:00).
    tm  = c_tm(0, 0, 12, 1, 9, 2020 - 1900, 4, 0, 0)
    ptr = c_asctime(tm)
    call c_f_str_ptr(ptr, str)
    print '("Date and Time.: ", a)', str
end program main
