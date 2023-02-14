! key.f90
!
! Reads single key-strokes from standard input.
!
! Author:  Philipp Engel
! Licence: ISC
program main
    use, intrinsic :: iso_c_binding
    use :: unix
    implicit none
    integer :: key

    call set_mode(1)

    print '("Press <q> to quit.")'

    do
        key = next_char()
        print '("Key pressed: ", i0)', key
        if (key == iachar('q')) exit
    end do

    call set_mode(0)
contains
    integer function next_char() result(i)
        i = c_getchar()
    end function next_char

    subroutine set_mode(mode)
        integer, intent(in) :: mode

        integer               :: rc
        type(c_termios)       :: term_attr
        type(c_termios), save :: save_attr

        if (mode /= 0) then
            rc = c_tcgetattr(0, term_attr)

            save_attr = term_attr

            term_attr%c_lflag     = iand(term_attr%c_lflag, not(ior(ICANON, ECHO)))
            term_attr%c_cc(VMIN)  = 1
            term_attr%c_cc(VTIME) = 0

            rc = c_tcsetattr(0, TCSADRAIN, term_attr)
        else
            rc = c_tcsetattr(0, TCSADRAIN,save_attr)
        end if
    end subroutine set_mode
end program main
