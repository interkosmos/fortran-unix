! fifo.f90
!
! Basic named pipe example. Creates a new named pipe `/tmp/fifo` and waits for
! input. Just write to the FIFO from another process:
!
!   $ echo "Hello, World!" > /tmp/fifo
!
! Author:  Philipp Engel
! Licence: ISC
program main
    use, intrinsic :: iso_c_binding
    use :: unix
    implicit none
    character(len=*), parameter :: PATH = '/tmp/fifo'  ! Path to the named pipe.
    integer,          parameter :: PERM = int(o'0666') ! Permissions (octal).

    type(c_funptr) :: ptr    ! Signal handler.
    type(c_ptr)    :: stream ! Input stream.
    integer        :: c      ! Single character.
    integer        :: fd     ! File descriptor.
    integer        :: rc     ! Return code.

    ! Create named pipe.
    rc = c_mkfifo(PATH // c_null_char, PERM)

    if (rc < 0) then
        call c_perror('Error' // c_null_char)
        stop
    end if

    ! Add signal handler for SIGINT.
    ptr = c_signal(SIGINT, c_funloc(sigint_handler))

    do
        print '(3a)', 'Waiting for input in "', path, '" ...'

        ! Open file descriptor (read-only) and stream (read-only).
        fd     = c_open(PATH // c_null_char, O_RDONLY, S_IRUSR)
        stream = c_fdopen(fd, 'r' // c_null_char)

        do
            c = c_fgetc(stream)
            if (c == EOF) exit
            write (*, '(a)', advance='no') achar(c)
        end do

        rc = c_fclose(stream)
        rc = c_close(fd)
        rc = c_usleep(10**6)
    end do

    ! Delete named pipe.
    rc = c_unlink(PATH // c_null_char)
contains
    subroutine sigint_handler(signum) bind(c)
        !! Signal handler for SIGINT. Unlinks the named pipe on CTRL + C event.
        integer(kind=c_int), intent(in), value :: signum
        integer                                :: rc

        rc = c_unlink(PATH // c_null_char)
        stop
    end subroutine sigint_handler
end program main


