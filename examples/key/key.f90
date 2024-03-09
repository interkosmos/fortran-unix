! key.f90
!
! Author:  Philipp Engel
! Licence: ISC
program main
    !! Reads single key-strokes from standard input.
    use :: unix
    implicit none

    integer :: ich

    call set_mode(1)

    print '("Press <q> to quit.")'

    do
        ich = next_char()
        print '("Key pressed: ", i0)', ich
        if (ich == iachar('q')) exit
    end do

    call set_mode(0)
contains
    integer function next_char() result(ich)
        ich = c_getchar()
    end function next_char

    subroutine set_mode(mode)
        integer, intent(in) :: mode

        integer                 :: stat
        integer(kind=c_int64_t) :: c_lflag
        type(c_termios)         :: term_attr
        type(c_termios), save   :: save_attr

        if (mode == 0) then
            stat = c_tcsetattr(STDIN_FILENO, TCSADRAIN, save_attr)
        else
            stat = c_tcgetattr(STDIN_FILENO, term_attr)

            save_attr = term_attr

            c_lflag = c_uint_to_int(term_attr%c_lflag)
            c_lflag = iand(c_lflag, not(int(ior(ICANON, ECHO), kind=c_int64_t)))

            term_attr%c_lflag     = c_int_to_uint(c_lflag)
            term_attr%c_cc(VMIN)  = 1_c_cc_t
            term_attr%c_cc(VTIME) = 0_c_cc_t

            stat = c_tcsetattr(STDIN_FILENO, TCSANOW, term_attr)
        end if
    end subroutine set_mode
end program main
