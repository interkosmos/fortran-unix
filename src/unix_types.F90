! unix_types.F90
!
! Author:  Philipp Engel
! Licence: ISC
module unix_types
    use, intrinsic :: iso_c_binding
    implicit none
    private

    integer, parameter, public :: c_unsigned_char  = c_signed_char
    integer, parameter, public :: c_unsigned_short = c_short
    integer, parameter, public :: c_unsigned_int   = c_int
    integer, parameter, public :: c_unsigned_long  = c_long

    integer, parameter, public :: c_uint16_t = c_int16_t
    integer, parameter, public :: c_uint32_t = c_int32_t
    integer, parameter, public :: c_uint64_t = c_int64_t

#if defined (__linux__)

    integer, parameter, public :: c_blkcnt_t    = c_int64_t
    integer, parameter, public :: c_blksize_t   = c_long
    integer, parameter, public :: c_cc_t        = c_unsigned_char
    integer, parameter, public :: c_clockid_t   = c_int32_t
    integer, parameter, public :: c_dev_t       = c_unsigned_long
    integer, parameter, public :: c_gid_t       = c_uint32_t
    integer, parameter, public :: c_in_addr_t   = c_uint32_t
    integer, parameter, public :: c_ino_t       = c_unsigned_long
    integer, parameter, public :: c_key_t       = c_long
    integer, parameter, public :: c_mode_t      = c_uint32_t
    integer, parameter, public :: c_mqd_t       = c_int
    integer, parameter, public :: c_nlink_t     = c_unsigned_long
    integer, parameter, public :: c_off_t       = c_long
    integer, parameter, public :: c_pid_t       = c_int32_t
    integer, parameter, public :: c_regoff_t    = c_size_t
    integer, parameter, public :: c_socklen_t   = c_int64_t
    integer, parameter, public :: c_speed_t     = c_unsigned_int
    integer, parameter, public :: c_suseconds_t = c_int
    integer, parameter, public :: c_tcflag_t    = c_unsigned_int
    integer, parameter, public :: c_time_t      = c_long
    integer, parameter, public :: c_uid_t       = c_uint32_t
    integer, parameter, public :: c_useconds_t  = c_int32_t

#elif defined (__FreeBSD__)

    integer, parameter, public :: c_blkcnt_t    = c_int64_t
    integer, parameter, public :: c_blksize_t   = c_int32_t
    integer, parameter, public :: c_cc_t        = c_unsigned_char
    integer, parameter, public :: c_clockid_t   = c_int32_t
    integer, parameter, public :: c_dev_t       = c_uint64_t
    integer, parameter, public :: c_fflags_t    = c_uint32_t
    integer, parameter, public :: c_gid_t       = c_uint32_t
    integer, parameter, public :: c_in_addr_t   = c_uint32_t
    integer, parameter, public :: c_ino_t       = c_uint64_t
    integer, parameter, public :: c_key_t       = c_long
    integer, parameter, public :: c_mode_t      = c_uint16_t
    integer, parameter, public :: c_mqd_t       = c_long
    integer, parameter, public :: c_nlink_t     = c_uint64_t
    integer, parameter, public :: c_off_t       = c_int64_t
    integer, parameter, public :: c_pid_t       = c_int32_t
    integer, parameter, public :: c_regoff_t    = c_int64_t
    integer, parameter, public :: c_socklen_t   = c_size_t
    integer, parameter, public :: c_speed_t     = c_unsigned_int
    integer, parameter, public :: c_suseconds_t = c_long
    integer, parameter, public :: c_tcflag_t    = c_unsigned_int
    integer, parameter, public :: c_time_t      = c_int64_t
    integer, parameter, public :: c_uid_t       = c_uint32_t
    integer, parameter, public :: c_useconds_t  = c_unsigned_int

#endif
end module unix_types
