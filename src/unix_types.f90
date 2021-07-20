! unix_types.f90
module unix_types
    use, intrinsic :: iso_c_binding
    implicit none
    private

    integer, parameter, public :: c_key_t     = c_long
    integer, parameter, public :: c_mode_t    = c_int32_t
    integer, parameter, public :: c_pid_t     = c_int32_t

#if defined (__linux__)

    integer, parameter, public :: c_mqd_t     = c_int
    integer, parameter, public :: c_socklen_t = c_int64_t

#elif defined (__FreeBSD__)

    integer, parameter, public :: c_mqd_t     = c_long
    integer, parameter, public :: c_socklen_t = c_size_t

#endif
end module unix_types
