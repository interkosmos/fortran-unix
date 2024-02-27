! stat.f90
!
! Example program for file status access.
!
! Author:  Philipp Engel
! Licence: ISC
program main
    use, intrinsic :: iso_c_binding
    use :: unix
    implicit none

    character(len=*), parameter :: FILE_NAME = 'README.md'

    character(len=:), allocatable :: atime, mtime, ctime

    integer           :: rc
    type(c_ptr)       :: ptr
    type(c_stat_type) :: file_stat

    rc = c_stat(FILE_NAME // c_null_char, file_stat)

    if (rc == 0) then
        ptr = c_ctime(file_stat%st_atim%tv_sec)
        call c_f_str_ptr(ptr, atime)

        ptr = c_ctime(file_stat%st_mtim%tv_sec)
        call c_f_str_ptr(ptr, mtime)

        ptr = c_ctime(file_stat%st_ctim%tv_sec)
        call c_f_str_ptr(ptr, ctime)

        print '("File name........: ", a)',   FILE_NAME
        print '("File size........: ", i0)',  file_stat%st_size
        print '("File access time.: ", a24)', atime
        print '("File modify time.: ", a24)', mtime
        print '("File changed time: ", a24)', ctime
    end if
end program main
