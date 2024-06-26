! unix_stat.F90
!
! Author:  Philipp Engel
! Licence: ISC
module unix_stat
    use, intrinsic :: iso_c_binding
    use :: unix_time
    use :: unix_types
    implicit none
    private

#if defined (__linux__)

    integer(kind=c_int), parameter, public :: S_IRUSR = int(o'0400')
    integer(kind=c_int), parameter, public :: S_IWUSR = int(o'0200')
    integer(kind=c_int), parameter, public :: S_IXUSR = int(o'0100')
    integer(kind=c_int), parameter, public :: S_IRWXU = ior(ior(S_IRUSR, S_IWUSR), S_IXUSR)

    integer(kind=c_int), parameter, public :: S_IRWXG = shiftr(S_IRWXU, 3)
    integer(kind=c_int), parameter, public :: S_IRGRP = shiftr(S_IRUSR, 3)
    integer(kind=c_int), parameter, public :: S_IWGRP = shiftr(S_IWUSR, 3)
    integer(kind=c_int), parameter, public :: S_IXGRP = shiftr(S_IXUSR, 3)

    integer(kind=c_int), parameter, public :: S_IRWXO = shiftr(S_IRWXG, 3)
    integer(kind=c_int), parameter, public :: S_IROTH = shiftr(S_IRGRP, 3)
    integer(kind=c_int), parameter, public :: S_IWOTH = shiftr(S_IWGRP, 3)
    integer(kind=c_int), parameter, public :: S_IXOTH = shiftr(S_IXGRP, 3)

    integer(kind=c_int), parameter, public :: S_IFMT   = int(o'0170000')
    integer(kind=c_int), parameter, public :: S_IFSOCK = int(o'0140000')
    integer(kind=c_int), parameter, public :: S_IFLNK  = int(o'0120000')
    integer(kind=c_int), parameter, public :: S_IFREG  = int(o'0100000')
    integer(kind=c_int), parameter, public :: S_IFBLK  = int(o'0060000')
    integer(kind=c_int), parameter, public :: S_IFDIR  = int(o'0040000')
    integer(kind=c_int), parameter, public :: S_IFCHR  = int(o'0020000')
    integer(kind=c_int), parameter, public :: S_IFIFO  = int(o'0010000')
    integer(kind=c_int), parameter, public :: S_ISUID  = int(o'0004000')
    integer(kind=c_int), parameter, public :: S_ISGID  = int(o'0002000')
    integer(kind=c_int), parameter, public :: S_ISVTX  = int(o'0001000')

#if defined(__aarch64__)

    ! struct stat (aarch64)
    type, bind(c), public :: c_stat_type
        integer(kind=c_dev_t)          :: st_dev      = 0 ! ID of device containing file
        integer(kind=c_ino_t)          :: st_ino      = 0 ! inode number
        integer(kind=c_mode_t)         :: st_mode     = 0 ! protection
        integer(kind=c_nlink_t)        :: st_nlink    = 0 ! number of hard links
        integer(kind=c_uid_t)          :: st_uid      = 0 ! user ID of owner
        integer(kind=c_gid_t)          :: st_gid      = 0 ! group ID of owner
        integer(kind=c_dev_t)          :: st_rdev     = 0 ! device ID (if special file)
        integer(kind=c_dev_t), private :: pad0        = 0
        integer(kind=c_off_t)          :: st_size     = 0 ! total size, in bytes
        integer(kind=c_blksize_t)      :: st_blksize  = 0 ! blocksize for file system I/O
        integer(kind=c_int),   private :: pad1        = 0
        integer(kind=c_blkcnt_t)       :: st_blocks   = 0 ! number of 512B blocks allocated
        type(c_timespec)               :: st_atim         ! time of last access
        type(c_timespec)               :: st_mtim         ! time of last modification
        type(c_timespec)               :: st_ctim         ! time of last status change
        integer(kind=c_long),  private :: reserved(2) = 0
    end type c_stat_type

#else

    ! struct stat (x86-64)
    type, bind(c), public :: c_stat_type
        integer(kind=c_dev_t)         :: st_dev      = 0 ! ID of device containing file
        integer(kind=c_ino_t)         :: st_ino      = 0 ! inode number
        integer(kind=c_nlink_t)       :: st_nlink    = 0 ! number of hard links
        integer(kind=c_mode_t)        :: st_mode     = 0 ! protection
        integer(kind=c_uid_t)         :: st_uid      = 0 ! user ID of owner
        integer(kind=c_gid_t)         :: st_gid      = 0 ! group ID of owner
        integer(kind=c_int), private  :: pad0        = 0
        integer(kind=c_dev_t)         :: st_rdev     = 0 ! device ID (if special file)
        integer(kind=c_off_t)         :: st_size     = 0 ! total size, in bytes
        integer(kind=c_blksize_t)     :: st_blksize  = 0 ! blocksize for file system I/O
        integer(kind=c_blkcnt_t)      :: st_blocks   = 0 ! number of 512B blocks allocated
        type(c_timespec)              :: st_atim         ! time of last access
        type(c_timespec)              :: st_mtim         ! time of last modification
        type(c_timespec)              :: st_ctim         ! time of last status change
        integer(kind=c_long), private :: reserved(3) = 0
    end type c_stat_type

#endif
#elif defined (__FreeBSD__)

    integer(kind=c_int), parameter, public :: S_IRWXU = int(o'0000700')
    integer(kind=c_int), parameter, public :: S_IRUSR = int(o'0000400')
    integer(kind=c_int), parameter, public :: S_IWUSR = int(o'0000200')
    integer(kind=c_int), parameter, public :: S_IXUSR = int(o'0000100')

    integer(kind=c_int), parameter, public :: S_IRWXG = int(o'0000070')
    integer(kind=c_int), parameter, public :: S_IRGRP = int(o'0000040')
    integer(kind=c_int), parameter, public :: S_IWGRP = int(o'0000020')
    integer(kind=c_int), parameter, public :: S_IXGRP = int(o'0000010')

    integer(kind=c_int), parameter, public :: S_IRWXO = int(o'0000007')
    integer(kind=c_int), parameter, public :: S_IROTH = int(o'0000004')
    integer(kind=c_int), parameter, public :: S_IWOTH = int(o'0000002')
    integer(kind=c_int), parameter, public :: S_IXOTH = int(o'0000001')

    integer(kind=c_int), parameter, public :: S_IFMT   = int(o'0170000') ! type of file mask
    integer(kind=c_int), parameter, public :: S_IFIFO  = int(o'0010000') ! named pipe (fifo)
    integer(kind=c_int), parameter, public :: S_IFCHR  = int(o'0020000') ! character special
    integer(kind=c_int), parameter, public :: S_IFDIR  = int(o'0040000') ! directory
    integer(kind=c_int), parameter, public :: S_IFBLK  = int(o'0060000') ! block special
    integer(kind=c_int), parameter, public :: S_IFREG  = int(o'0100000') ! regular
    integer(kind=c_int), parameter, public :: S_IFLNK  = int(o'0120000') ! symbolic link
    integer(kind=c_int), parameter, public :: S_IFSOCK = int(o'0140000') ! socket
    integer(kind=c_int), parameter, public :: S_ISVTX  = int(o'0001000') ! save swapped text even after use
    integer(kind=c_int), parameter, public :: S_IFWHT  = int(o'0160000') ! whiteout

    ! struct stat
    type, bind(c), public :: c_stat_type
        integer(kind=c_dev_t)             :: st_dev       = 0 ! ID of device containing file
        integer(kind=c_ino_t)             :: st_ino       = 0 ! inode number
        integer(kind=c_nlink_t)           :: st_nlink     = 0 ! number of hard links
        integer(kind=c_mode_t)            :: st_mode      = 0 ! protection
        integer(kind=c_int16_t),  private :: st_padding0  = 0
        integer(kind=c_uid_t)             :: st_uid       = 0 ! user ID of owner
        integer(kind=c_gid_t)             :: st_gid       = 0 ! group ID of owner
        integer(kind=c_int32_t),  private :: st_padding1  = 0
        integer(kind=c_dev_t)             :: st_rdev      = 0 ! device ID (if special file)
        type(c_timespec)                  :: st_atim          ! time of last access
        type(c_timespec)                  :: st_mtim          ! time of last modification
        type(c_timespec)                  :: st_ctim          ! time of last status change
        type(c_timespec)                  :: st_birthtim
        integer(kind=c_off_t)             :: st_size      = 0 ! total size, in bytes
        integer(kind=c_blkcnt_t)          :: st_blocks    = 0 ! number of 512B blocks allocated
        integer(kind=c_blksize_t)         :: st_blksize   = 0 ! blocksize for file system I/O
        integer(kind=c_fflags_t)          :: st_flags     = 0
        integer(kind=c_uint64_t)          :: st_gen       = 0
        integer(kind=c_uint64_t), private :: st_spare(10) = 0
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
            integer(kind=c_int), intent(in), value :: fd
            type(c_stat_type),   intent(inout)     :: buf
            integer(kind=c_int)                    :: c_fstat
        end function c_fstat

        ! int lstat(const char *path, struct stat *buf)
        function c_lstat(path, buf) bind(c, name='lstat')
            import :: c_char, c_int, c_stat_type
            implicit none
            character(kind=c_char), intent(in)    :: path
            type(c_stat_type),      intent(inout) :: buf
            integer(kind=c_int)                   :: c_lstat
        end function c_lstat

        ! int mkdir(const char *path, mode_t mode)
        function c_mkdir(path, mode) bind(c, name='mkdir')
            import :: c_char, c_int, c_mode_t
            implicit none
            character(kind=c_char), intent(in)        :: path
            integer(kind=c_mode_t), intent(in), value :: mode
            integer(kind=c_int)                       :: c_mkdir
        end function c_mkdir

        ! int mkfifo(const char *path, mode_t mode)
        function c_mkfifo(path, mode) bind(c, name='mkfifo')
            import :: c_char, c_int, c_mode_t
            implicit none
            character(kind=c_char), intent(in)        :: path
            integer(kind=c_mode_t), intent(in), value :: mode
            integer(kind=c_int)                       :: c_mkfifo
        end function c_mkfifo

        ! int stat(const char *path, struct stat *buf)
        function c_stat(path, buf) bind(c, name='stat')
            import :: c_char, c_int, c_stat_type
            implicit none
            character(kind=c_char), intent(in)    :: path
            type(c_stat_type),      intent(inout) :: buf
            integer(kind=c_int)                   :: c_stat
        end function c_stat

        ! mode_t umask(mode_t numask)
        function c_umask(numask) bind(c, name='umask')
            import :: c_mode_t
            implicit none
            integer(kind=c_mode_t), intent(in), value :: numask
            integer(kind=c_mode_t)                    :: c_umask
        end function c_umask
    end interface
end module unix_stat
