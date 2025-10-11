! unix_types.F90
!
! Author:  Philipp Engel
! Licence: ISC
module unix_types
    use, intrinsic :: iso_c_binding, only: c_associated, c_f_pointer, c_funloc, c_loc, c_sizeof, &
                                           c_char, c_int, c_int8_t, c_int16_t, c_int32_t, c_int64_t, &
                                           c_long, c_long_long, c_short, c_signed_char, c_size_t, &
                                           c_funptr, c_ptr, c_null_char, c_null_funptr, c_null_ptr
#if HAS_UNSIGNED

    use, intrinsic :: iso_c_binding, only: c_uint16_t, c_uint32_t, c_uint64_t, c_unsigned, &
                                           c_unsigned_char, c_unsigned_short, c_unsigned_long

#endif
    implicit none
    private

    public :: c_associated
    public :: c_f_pointer
    public :: c_funloc
    public :: c_loc
    public :: c_sizeof

    public ::  c_char
    public ::  c_int
    public ::  c_int8_t
    public ::  c_int16_t
    public ::  c_int32_t
    public ::  c_int64_t
    public ::  c_long
    public ::  c_long_long
    public ::  c_short
    public ::  c_signed_char
    public ::  c_size_t
    public ::  c_funptr
    public ::  c_ptr
    public ::  c_null_char
    public ::  c_null_funptr
    public ::  c_null_ptr

#if HAS_UNSIGNED

    public :: c_uint16_t
    public :: c_uint32_t
    public :: c_uint64_t

    public :: c_unsigned
    public :: c_unsigned_char
    public :: c_unsigned_short
    public :: c_unsigned_long

#else

    integer, parameter, public :: c_uint16_t = c_int16_t
    integer, parameter, public :: c_uint32_t = c_int32_t
    integer, parameter, public :: c_uint64_t = c_int64_t

    integer, parameter, public :: c_unsigned       = c_int
    integer, parameter, public :: c_unsigned_char  = c_signed_char
    integer, parameter, public :: c_unsigned_short = c_short
    integer, parameter, public :: c_unsigned_long  = c_long

#endif

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
    integer, parameter, public :: c_speed_t     = c_unsigned
    integer, parameter, public :: c_suseconds_t = c_int
    integer, parameter, public :: c_tcflag_t    = c_unsigned
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
    integer, parameter, public :: c_speed_t     = c_unsigned
    integer, parameter, public :: c_suseconds_t = c_long
    integer, parameter, public :: c_tcflag_t    = c_unsigned
    integer, parameter, public :: c_time_t      = c_int64_t
    integer, parameter, public :: c_uid_t       = c_uint32_t
    integer, parameter, public :: c_useconds_t  = c_unsigned

#endif
end module unix_types
