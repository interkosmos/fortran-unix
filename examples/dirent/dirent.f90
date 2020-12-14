! dirent.f90
!
! Prints the contents of a file system directory to stdout (unsorted).
!
! Author:  Philipp Engel
! Licence: ISC
program main
    use, intrinsic :: iso_fortran_env, only: stderr => error_unit
    use, intrinsic :: iso_c_binding
    use :: unix
    implicit none
    character(len=*), parameter :: PATH = '/'
    character(len=256)          :: entry_name
    type(c_dirent), pointer     :: dirent_ptr
    type(c_ptr)                 :: dir_ptr
    integer                     :: rc

    ! Open directory.
    dir_ptr = c_opendir(PATH // c_null_char)

    if (.not. c_associated(dir_ptr)) then
        write (stderr, '("Cannot open directory ", a)') PATH
        stop
    end if

    print '("Contents of directory ", a, ":")', PATH

    ! Read in directory entries and output file names.
    do
        ! Get next directory entry.
        dirent_ptr => f_readdir(dir_ptr)

        ! Exit if pointer is null.
        if (.not. associated(dirent_ptr)) exit

        ! Convert C char array to Fortran string.
        call c_f_str_chars(dirent_ptr%d_name, entry_name)

        select case (dirent_ptr%d_type)
            case (DT_DIR)
                ! Entry is directory.
                print '(2a)', trim(entry_name), '/'
            case default
                ! Entry is file.
                print '(a)', trim(entry_name)
        end select
    end do

    ! Close directory.
    rc = c_closedir(dir_ptr)
end program main
