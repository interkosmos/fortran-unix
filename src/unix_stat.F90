! unix_stat.F90
!
! Author:  Philipp Engel
! Licence: ISC
module unix_stat
    use :: unix_time
    use :: unix_types
    implicit none
    private

#if defined (__linux__)

    integer(c_int), parameter, public :: S_IRUSR = int(o'0400')
    integer(c_int), parameter, public :: S_IWUSR = int(o'0200')
    integer(c_int), parameter, public :: S_IXUSR = int(o'0100')
    integer(c_int), parameter, public :: S_IRWXU = ior(ior(S_IRUSR, S_IWUSR), S_IXUSR)

    integer(c_int), parameter, public :: S_IRWXG = shiftr(S_IRWXU, 3)
    integer(c_int), parameter, public :: S_IRGRP = shiftr(S_IRUSR, 3)
    integer(c_int), parameter, public :: S_IWGRP = shiftr(S_IWUSR, 3)
    integer(c_int), parameter, public :: S_IXGRP = shiftr(S_IXUSR, 3)

    integer(c_int), parameter, public :: S_IRWXO = shiftr(S_IRWXG, 3)
    integer(c_int), parameter, public :: S_IROTH = shiftr(S_IRGRP, 3)
    integer(c_int), parameter, public :: S_IWOTH = shiftr(S_IWGRP, 3)
    integer(c_int), parameter, public :: S_IXOTH = shiftr(S_IXGRP, 3)

    integer(c_int), parameter, public :: S_IFMT   = int(o'0170000')
    integer(c_int), parameter, public :: S_IFSOCK = int(o'0140000')
    integer(c_int), parameter, public :: S_IFLNK  = int(o'0120000')
    integer(c_int), parameter, public :: S_IFREG  = int(o'0100000')
    integer(c_int), parameter, public :: S_IFBLK  = int(o'0060000')
    integer(c_int), parameter, public :: S_IFDIR  = int(o'0040000')
    integer(c_int), parameter, public :: S_IFCHR  = int(o'0020000')
    integer(c_int), parameter, public :: S_IFIFO  = int(o'0010000')
    integer(c_int), parameter, public :: S_ISUID  = int(o'0004000')
    integer(c_int), parameter, public :: S_ISGID  = int(o'0002000')
    integer(c_int), parameter, public :: S_ISVTX  = int(o'0001000')

#if defined(__aarch64__)

    ! struct stat (aarch64)
    type, bind(c), public :: c_stat_type
        integer(c_dev_t)          :: st_dev      = 0             ! ID of device containing file.
        integer(c_ino_t)          :: st_ino      = 0             ! Inode number.
        integer(c_mode_t)         :: st_mode     = 0             ! Protection.
        integer(c_nlink_t)        :: st_nlink    = 0             ! Number of hard links.
        integer(c_uid_t)          :: st_uid      = 0             ! User ID of owner.
        integer(c_gid_t)          :: st_gid      = 0             ! Group ID of owner.
        integer(c_dev_t)          :: st_rdev     = 0             ! Device ID (if special file).
        integer(c_dev_t), private :: padding0    = 0
        integer(c_off_t)          :: st_size     = 0             ! Total size, in bytes.
        integer(c_blksize_t)      :: st_blksize  = 0             ! Blocksize for file system I/O.
        integer(c_int),   private :: paddding1   = 0
        integer(c_blkcnt_t)       :: st_blocks   = 0             ! Number of 512B blocks allocated.
        type(c_timespec)          :: st_atim     = c_timespec()  ! Time of last access.
        type(c_timespec)          :: st_mtim     = c_timespec()  ! Time of last modification.
        type(c_timespec)          :: st_ctim     = c_timespec()  ! Time of last status change.
        integer(c_long),  private :: reserved(2) = 0
    end type c_stat_type

#else

    ! struct stat (x86-64)
    type, bind(c), public :: c_stat_type
        integer(c_dev_t)         :: st_dev      = 0            ! ID of device containing file.
        integer(c_ino_t)         :: st_ino      = 0            ! Inode number.
        integer(c_nlink_t)       :: st_nlink    = 0            ! Number of hard links.
        integer(c_mode_t)        :: st_mode     = 0            ! Protection.
        integer(c_uid_t)         :: st_uid      = 0            ! User ID of owner.
        integer(c_gid_t)         :: st_gid      = 0            ! Group ID of owner.
        integer(c_int), private  :: padding0    = 0
        integer(c_dev_t)         :: st_rdev     = 0            ! Device ID (if special file).
        integer(c_off_t)         :: st_size     = 0            ! Total size, in bytes.
        integer(c_blksize_t)     :: st_blksize  = 0            ! Blocksize for file system I/O.
        integer(c_blkcnt_t)      :: st_blocks   = 0            ! Number of 512B blocks allocated.
        type(c_timespec)         :: st_atim     = c_timespec() ! Time of last access.
        type(c_timespec)         :: st_mtim     = c_timespec() ! Time of last modification.
        type(c_timespec)         :: st_ctim     = c_timespec() ! Time of last status change.
        integer(c_long), private :: reserved(3) = 0
    end type c_stat_type

#endif

#elif defined (__FreeBSD__)

    integer(c_int), parameter, public :: S_IRWXU = int(o'0000700')
    integer(c_int), parameter, public :: S_IRUSR = int(o'0000400')
    integer(c_int), parameter, public :: S_IWUSR = int(o'0000200')
    integer(c_int), parameter, public :: S_IXUSR = int(o'0000100')

    integer(c_int), parameter, public :: S_IRWXG = int(o'0000070')
    integer(c_int), parameter, public :: S_IRGRP = int(o'0000040')
    integer(c_int), parameter, public :: S_IWGRP = int(o'0000020')
    integer(c_int), parameter, public :: S_IXGRP = int(o'0000010')

    integer(c_int), parameter, public :: S_IRWXO = int(o'0000007')
    integer(c_int), parameter, public :: S_IROTH = int(o'0000004')
    integer(c_int), parameter, public :: S_IWOTH = int(o'0000002')
    integer(c_int), parameter, public :: S_IXOTH = int(o'0000001')

    integer(c_int), parameter, public :: S_IFMT   = int(o'0170000') ! Type of file mask.
    integer(c_int), parameter, public :: S_IFIFO  = int(o'0010000') ! Named pipe (fifo).
    integer(c_int), parameter, public :: S_IFCHR  = int(o'0020000') ! Character special.
    integer(c_int), parameter, public :: S_IFDIR  = int(o'0040000') ! Directory.
    integer(c_int), parameter, public :: S_IFBLK  = int(o'0060000') ! Block special.
    integer(c_int), parameter, public :: S_IFREG  = int(o'0100000') ! Regular.
    integer(c_int), parameter, public :: S_IFLNK  = int(o'0120000') ! Symbolic link.
    integer(c_int), parameter, public :: S_IFSOCK = int(o'0140000') ! Socket.
    integer(c_int), parameter, public :: S_ISVTX  = int(o'0001000') ! Save swapped text even after use.
    integer(c_int), parameter, public :: S_IFWHT  = int(o'0160000') ! Whiteout.

    ! struct stat
    type, bind(c), public :: c_stat_type
        integer(c_dev_t)             :: st_dev       = 0            ! ID of device containing file.
        integer(c_ino_t)             :: st_ino       = 0            ! Inode number.
        integer(c_nlink_t)           :: st_nlink     = 0            ! Number of hard links.
        integer(c_mode_t)            :: st_mode      = 0            ! Protection.
        integer(c_int16_t),  private :: padding0     = 0
        integer(c_uid_t)             :: st_uid       = 0            ! User ID of owner.
        integer(c_gid_t)             :: st_gid       = 0            ! Group ID of owner.
        integer(c_int32_t),  private :: padding1     = 0
        integer(c_dev_t)             :: st_rdev      = 0            ! Device ID (if special file).
        type(c_timespec)             :: st_atim      = c_timespec() ! Time of last access.
        type(c_timespec)             :: st_mtim      = c_timespec() ! Time of last modification.
        type(c_timespec)             :: st_ctim      = c_timespec() ! Time of last status change.
        type(c_timespec)             :: st_birthtim  = c_timespec()
        integer(c_off_t)             :: st_size      = 0            ! Total size, in bytes.
        integer(c_blkcnt_t)          :: st_blocks    = 0            ! Number of 512B blocks allocated.
        integer(c_blksize_t)         :: st_blksize   = 0            ! Blocksize for file system I/O.
        integer(c_fflags_t)          :: st_flags     = 0
        integer(c_uint64_t)          :: st_gen       = 0
        integer(c_uint64_t), private :: st_spare(10) = 0
    end type c_stat_type

#endif

    public :: c_fstat
    public :: c_lstat
    public :: c_mkdir
    public :: c_mkfifo
    public :: c_umask
    public :: c_stat

    interface
        ! int fstat(int fd, struct stat *buf)
        function c_fstat(fd, buf) bind(c, name='fstat')
            import :: c_int, c_stat_type
            implicit none
            integer(c_int),    intent(in), value :: fd
            type(c_stat_type), intent(inout)     :: buf
            integer(c_int)                       :: c_fstat
        end function c_fstat

        ! int lstat(const char *path, struct stat *buf)
        function c_lstat(path, buf) bind(c, name='lstat')
            import :: c_char, c_int, c_stat_type
            implicit none
            character(c_char), intent(in)    :: path
            type(c_stat_type), intent(inout) :: buf
            integer(c_int)                   :: c_lstat
        end function c_lstat

        ! int mkdir(const char *path, mode_t mode)
        function c_mkdir(path, mode) bind(c, name='mkdir')
            import :: c_char, c_int, c_mode_t
            implicit none
            character(c_char), intent(in)        :: path
            integer(c_mode_t), intent(in), value :: mode
            integer(c_int)                       :: c_mkdir
        end function c_mkdir

        ! int mkfifo(const char *path, mode_t mode)
        function c_mkfifo(path, mode) bind(c, name='mkfifo')
            import :: c_char, c_int, c_mode_t
            implicit none
            character(c_char), intent(in)        :: path
            integer(c_mode_t), intent(in), value :: mode
            integer(c_int)                       :: c_mkfifo
        end function c_mkfifo

        ! int stat(const char *path, struct stat *buf)
        function c_stat(path, buf) bind(c, name='stat')
            import :: c_char, c_int, c_stat_type
            implicit none
            character(c_char), intent(in)    :: path
            type(c_stat_type), intent(inout) :: buf
            integer(c_int)                   :: c_stat
        end function c_stat

        ! mode_t umask(mode_t numask)
        function c_umask(numask) bind(c, name='umask')
            import :: c_mode_t
            implicit none
            integer(c_mode_t), intent(in), value :: numask
            integer(c_mode_t)                    :: c_umask
        end function c_umask
    end interface
end module unix_stat
