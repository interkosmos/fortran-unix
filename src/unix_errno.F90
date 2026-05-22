! unix_errno.F90
!
! Author:  Philipp Engel
! Licence: ISC
module unix_errno
    use :: unix_types
    implicit none
    private

#if defined (__linux__)

    integer(c_int), parameter, public :: EPERM           = 1
    integer(c_int), parameter, public :: ENOENT          = 2
    integer(c_int), parameter, public :: ESRCH           = 3
    integer(c_int), parameter, public :: EINTR           = 4
    integer(c_int), parameter, public :: EIO             = 5
    integer(c_int), parameter, public :: ENXIO           = 6
    integer(c_int), parameter, public :: E2BIG           = 7
    integer(c_int), parameter, public :: ENOEXEC         = 8
    integer(c_int), parameter, public :: EBADF           = 9
    integer(c_int), parameter, public :: ECHILD          = 10
    integer(c_int), parameter, public :: EAGAIN          = 11
    integer(c_int), parameter, public :: ENOMEM          = 12
    integer(c_int), parameter, public :: EACCES          = 13
    integer(c_int), parameter, public :: EFAULT          = 14
    integer(c_int), parameter, public :: ENOTBLK         = 15
    integer(c_int), parameter, public :: EBUSY           = 16
    integer(c_int), parameter, public :: EEXIST          = 17
    integer(c_int), parameter, public :: EXDEV           = 18
    integer(c_int), parameter, public :: ENODEV          = 19
    integer(c_int), parameter, public :: ENOTDIR         = 20
    integer(c_int), parameter, public :: EISDIR          = 21
    integer(c_int), parameter, public :: EINVAL          = 22
    integer(c_int), parameter, public :: ENFILE          = 23
    integer(c_int), parameter, public :: EMFILE          = 24
    integer(c_int), parameter, public :: ENOTTY          = 25
    integer(c_int), parameter, public :: ETXTBSY         = 26
    integer(c_int), parameter, public :: EFBIG           = 27
    integer(c_int), parameter, public :: ENOSPC          = 28
    integer(c_int), parameter, public :: ESPIPE          = 29
    integer(c_int), parameter, public :: EROFS           = 30
    integer(c_int), parameter, public :: EMLINK          = 31
    integer(c_int), parameter, public :: EPIPE           = 32
    integer(c_int), parameter, public :: EDOM            = 33
    integer(c_int), parameter, public :: ERANGE          = 34
    integer(c_int), parameter, public :: EDEADLK         = 35
    integer(c_int), parameter, public :: ENAMETOOLONG    = 36
    integer(c_int), parameter, public :: ENOLCK          = 37
    integer(c_int), parameter, public :: ENOSYS          = 38
    integer(c_int), parameter, public :: ENOTEMPTY       = 39
    integer(c_int), parameter, public :: ELOOP           = 40
    integer(c_int), parameter, public :: EWOULDBLOCK     = EAGAIN
    integer(c_int), parameter, public :: ENOMSG          = 42
    integer(c_int), parameter, public :: EIDRM           = 43
    integer(c_int), parameter, public :: ECHRNG          = 44
    integer(c_int), parameter, public :: EL2NSYNC        = 45
    integer(c_int), parameter, public :: EL3HLT          = 46
    integer(c_int), parameter, public :: EL3RST          = 47
    integer(c_int), parameter, public :: ELNRNG          = 48
    integer(c_int), parameter, public :: EUNATCH         = 49
    integer(c_int), parameter, public :: ENOCSI          = 50
    integer(c_int), parameter, public :: EL2HLT          = 51
    integer(c_int), parameter, public :: EBADE           = 52
    integer(c_int), parameter, public :: EBADR           = 53
    integer(c_int), parameter, public :: EXFULL          = 54
    integer(c_int), parameter, public :: ENOANO          = 55
    integer(c_int), parameter, public :: EBADRQC         = 56
    integer(c_int), parameter, public :: EBADSLT         = 57
    integer(c_int), parameter, public :: EDEADLOCK       = EDEADLK
    integer(c_int), parameter, public :: EBFONT          = 59
    integer(c_int), parameter, public :: ENOSTR          = 60
    integer(c_int), parameter, public :: ENODATA         = 61
    integer(c_int), parameter, public :: ETIME           = 62
    integer(c_int), parameter, public :: ENOSR           = 63
    integer(c_int), parameter, public :: ENONET          = 64
    integer(c_int), parameter, public :: ENOPKG          = 65
    integer(c_int), parameter, public :: EREMOTE         = 66
    integer(c_int), parameter, public :: ENOLINK         = 67
    integer(c_int), parameter, public :: EADV            = 68
    integer(c_int), parameter, public :: ESRMNT          = 69
    integer(c_int), parameter, public :: ECOMM           = 70
    integer(c_int), parameter, public :: EPROTO          = 71
    integer(c_int), parameter, public :: EMULTIHOP       = 72
    integer(c_int), parameter, public :: EDOTDOT         = 73
    integer(c_int), parameter, public :: EBADMSG         = 74
    integer(c_int), parameter, public :: EOVERFLOW       = 75
    integer(c_int), parameter, public :: ENOTUNIQ        = 76
    integer(c_int), parameter, public :: EBADFD          = 77
    integer(c_int), parameter, public :: EREMCHG         = 78
    integer(c_int), parameter, public :: ELIBACC         = 79
    integer(c_int), parameter, public :: ELIBBAD         = 80
    integer(c_int), parameter, public :: ELIBSCN         = 81
    integer(c_int), parameter, public :: ELIBMAX         = 82
    integer(c_int), parameter, public :: ELIBEXEC        = 83
    integer(c_int), parameter, public :: EILSEQ          = 84
    integer(c_int), parameter, public :: ERESTART        = 85
    integer(c_int), parameter, public :: ESTRPIPE        = 86
    integer(c_int), parameter, public :: EUSERS          = 87
    integer(c_int), parameter, public :: ENOTSOCK        = 88
    integer(c_int), parameter, public :: EDESTADDRREQ    = 89
    integer(c_int), parameter, public :: EMSGSIZE        = 90
    integer(c_int), parameter, public :: EPROTOTYPE      = 91
    integer(c_int), parameter, public :: ENOPROTOOPT     = 92
    integer(c_int), parameter, public :: EPROTONOSUPPORT = 93
    integer(c_int), parameter, public :: ESOCKTNOSUPPORT = 94
    integer(c_int), parameter, public :: EOPNOTSUPP      = 95
    integer(c_int), parameter, public :: EPFNOSUPPORT    = 96
    integer(c_int), parameter, public :: EAFNOSUPPORT    = 97
    integer(c_int), parameter, public :: EADDRINUSE      = 98
    integer(c_int), parameter, public :: EADDRNOTAVAIL   = 99
    integer(c_int), parameter, public :: ENETDOWN        = 100
    integer(c_int), parameter, public :: ENETUNREACH     = 101
    integer(c_int), parameter, public :: ENETRESET       = 102
    integer(c_int), parameter, public :: ECONNABORTED    = 103
    integer(c_int), parameter, public :: ECONNRESET      = 104
    integer(c_int), parameter, public :: ENOBUFS         = 105
    integer(c_int), parameter, public :: EISCONN         = 106
    integer(c_int), parameter, public :: ENOTCONN        = 107
    integer(c_int), parameter, public :: ESHUTDOWN       = 108
    integer(c_int), parameter, public :: ETOOMANYREFS    = 109
    integer(c_int), parameter, public :: ETIMEDOUT       = 110
    integer(c_int), parameter, public :: ECONNREFUSED    = 111
    integer(c_int), parameter, public :: EHOSTDOWN       = 112
    integer(c_int), parameter, public :: EHOSTUNREACH    = 113
    integer(c_int), parameter, public :: EALREADY        = 114
    integer(c_int), parameter, public :: EINPROGRESS     = 115
    integer(c_int), parameter, public :: ESTALE          = 116
    integer(c_int), parameter, public :: EUCLEAN         = 117
    integer(c_int), parameter, public :: ENOTNAM         = 118
    integer(c_int), parameter, public :: ENAVAIL         = 119
    integer(c_int), parameter, public :: EISNAM          = 120
    integer(c_int), parameter, public :: EREMOTEIO       = 121
    integer(c_int), parameter, public :: EDQUOT          = 122
    integer(c_int), parameter, public :: ENOMEDIUM       = 123
    integer(c_int), parameter, public :: EMEDIUMTYPE     = 124
    integer(c_int), parameter, public :: ECANCELED       = 125
    integer(c_int), parameter, public :: ENOKEY          = 126
    integer(c_int), parameter, public :: EKEYEXPIRED     = 127
    integer(c_int), parameter, public :: EKEYREVOKED     = 128
    integer(c_int), parameter, public :: EKEYREJECTED    = 129
    integer(c_int), parameter, public :: EOWNERDEAD      = 130
    integer(c_int), parameter, public :: ENOTRECOVERABLE = 131
    integer(c_int), parameter, public :: ERFKILL         = 132
    integer(c_int), parameter, public :: EHWPOISON       = 133

#elif defined (__FreeBSD__)

    integer(c_int), parameter, public :: EPERM           = 1
    integer(c_int), parameter, public :: ENOENT          = 2
    integer(c_int), parameter, public :: ESRCH           = 3
    integer(c_int), parameter, public :: EINTR           = 4
    integer(c_int), parameter, public :: EIO             = 5
    integer(c_int), parameter, public :: ENXIO           = 6
    integer(c_int), parameter, public :: E2BIG           = 7
    integer(c_int), parameter, public :: ENOEXEC         = 8
    integer(c_int), parameter, public :: EBADF           = 9
    integer(c_int), parameter, public :: ECHILD          = 10
    integer(c_int), parameter, public :: EDEADLK         = 11
    integer(c_int), parameter, public :: ENOMEM          = 12
    integer(c_int), parameter, public :: EACCES          = 13
    integer(c_int), parameter, public :: EFAULT          = 14
    integer(c_int), parameter, public :: ENOTBLK         = 15
    integer(c_int), parameter, public :: EBUSY           = 16
    integer(c_int), parameter, public :: EEXIST          = 17
    integer(c_int), parameter, public :: EXDEV           = 18
    integer(c_int), parameter, public :: ENODEV          = 19
    integer(c_int), parameter, public :: ENOTDIR         = 20
    integer(c_int), parameter, public :: EISDIR          = 21
    integer(c_int), parameter, public :: EINVAL          = 22
    integer(c_int), parameter, public :: ENFILE          = 23
    integer(c_int), parameter, public :: EMFILE          = 24
    integer(c_int), parameter, public :: ENOTTY          = 25
    integer(c_int), parameter, public :: ETXTBSY         = 26
    integer(c_int), parameter, public :: EFBIG           = 27
    integer(c_int), parameter, public :: ENOSPC          = 28
    integer(c_int), parameter, public :: ESPIPE          = 29
    integer(c_int), parameter, public :: EROFS           = 30
    integer(c_int), parameter, public :: EMLINK          = 31
    integer(c_int), parameter, public :: EPIPE           = 32
    integer(c_int), parameter, public :: EDOM            = 33
    integer(c_int), parameter, public :: ERANGE          = 34
    integer(c_int), parameter, public :: EAGAIN          = 35
    integer(c_int), parameter, public :: EWOULDBLOCK     = EAGAIN
    integer(c_int), parameter, public :: EINPROGRESS     = 36
    integer(c_int), parameter, public :: EALREADY        = 37
    integer(c_int), parameter, public :: ENOTSOCK        = 38
    integer(c_int), parameter, public :: EDESTADDRREQ    = 39
    integer(c_int), parameter, public :: EMSGSIZE        = 40
    integer(c_int), parameter, public :: EPROTOTYPE      = 41
    integer(c_int), parameter, public :: ENOPROTOOPT     = 42
    integer(c_int), parameter, public :: EPROTONOSUPPORT = 43
    integer(c_int), parameter, public :: ESOCKTNOSUPPORT = 44
    integer(c_int), parameter, public :: EOPNOTSUPP      = 45
    integer(c_int), parameter, public :: ENOTSUP         = EOPNOTSUPP
    integer(c_int), parameter, public :: EPFNOSUPPORT    = 46
    integer(c_int), parameter, public :: EAFNOSUPPORT    = 47
    integer(c_int), parameter, public :: EADDRINUSE      = 48
    integer(c_int), parameter, public :: EADDRNOTAVAIL   = 49
    integer(c_int), parameter, public :: ENETDOWN        = 50
    integer(c_int), parameter, public :: ENETUNREACH     = 51
    integer(c_int), parameter, public :: ENETRESET       = 52
    integer(c_int), parameter, public :: ECONNABORTED    = 53
    integer(c_int), parameter, public :: ECONNRESET      = 54
    integer(c_int), parameter, public :: ENOBUFS         = 55
    integer(c_int), parameter, public :: EISCONN         = 56
    integer(c_int), parameter, public :: ENOTCONN        = 57
    integer(c_int), parameter, public :: ESHUTDOWN       = 58
    integer(c_int), parameter, public :: ETOOMANYREFS    = 59
    integer(c_int), parameter, public :: ETIMEDOUT       = 60
    integer(c_int), parameter, public :: ECONNREFUSED    = 61
    integer(c_int), parameter, public :: ELOOP           = 62
    integer(c_int), parameter, public :: ENAMETOOLONG    = 63
    integer(c_int), parameter, public :: EHOSTDOWN       = 64
    integer(c_int), parameter, public :: EHOSTUNREACH    = 65
    integer(c_int), parameter, public :: ENOTEMPTY       = 66
    integer(c_int), parameter, public :: EPROCLIM        = 67
    integer(c_int), parameter, public :: EUSERS          = 68
    integer(c_int), parameter, public :: EDQUOT          = 69

#endif

    public :: c_errno

    ! Interface to `c_errno()` in `errno.c`
    interface
        ! int c_errno()
        function c_errno() bind(c, name='c_errno')
            import :: c_int
            implicit none
            integer(c_int) :: c_errno
        end function c_errno
    end interface
end module unix_errno
