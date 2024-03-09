! stat.f90
!
! Author:  Philipp Engel
! Licence: ISC
program main
    !! Example program for file status access.
    use :: unix
    implicit none

    character(len=*), parameter :: FILE_NAME = 'README.md'

    character(len=:), allocatable :: atime, mtime, ctime
    integer                       :: file_type, stat
    integer(kind=c_int64_t)       :: file_mode
    type(c_stat_type)             :: file_stat

    ! Get file status.
    stat = c_stat(FILE_NAME // c_null_char, file_stat)
    if (stat /= 0) error stop

    print '("File name........: ", a)',  FILE_NAME
    print '("File size........: ", i0)', file_stat%st_size

    ! Get file type.
    file_mode = c_uint_to_int(file_stat%st_mode)
    file_type = int(iand(file_mode, int(S_IFMT, kind=c_int64_t)))

    write (*, '("File type........: ")', advance='no')

    select case (file_type)
        case (S_IFBLK)
            print '("block device")'
        case (S_IFCHR)
            print '("character device")'
        case (S_IFDIR)
            print '("directory")'
        case (S_IFIFO)
            print '("fifo")'
        case (S_IFLNK)
            print '("symlink")'
        case (S_IFREG)
            print '("file")'
        case (S_IFSOCK)
            print '("socket")'
        case default
            print '("unknown")'
    end select

    ! Get file times.
    call c_f_str_ptr(c_ctime(file_stat%st_atim%tv_sec), atime)
    call c_f_str_ptr(c_ctime(file_stat%st_mtim%tv_sec), mtime)
    call c_f_str_ptr(c_ctime(file_stat%st_ctim%tv_sec), ctime)

    print '("File access time.: ", a24)', atime
    print '("File modify time.: ", a24)', mtime
    print '("File changed time: ", a24)', ctime
end program main
