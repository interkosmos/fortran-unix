! unix_poll.F90
!
! Author:  Philipp Engel
! Licence: ISC
module unix_poll
    use :: unix_types
    implicit none
    private

#if defined (__linux__)

    integer(kind=c_int), parameter, public :: POLLIN     = int(z'001')    ! There is data to read.
    integer(kind=c_int), parameter, public :: POLLPRI    = int(z'002')    ! There is urgent data to read.
    integer(kind=c_int), parameter, public :: POLLOUT    = int(z'004')    ! Writing now will not block.
    integer(kind=c_int), parameter, public :: POLLRDNORM = int(z'040')    ! Normal data may be read.
    integer(kind=c_int), parameter, public :: POLLRDBAND = int(z'080')    ! Priority data may be read.
    integer(kind=c_int), parameter, public :: POLLWRNORM = int(z'100')    ! Writing now will not block.
    integer(kind=c_int), parameter, public :: POLLWRBAND = int(z'200')    ! Priority data may be written.

    integer(kind=c_int), parameter, public :: POLLMSG    = int(z'0400')
    integer(kind=c_int), parameter, public :: POLLREMOVE = int(z'1000')
    integer(kind=c_int), parameter, public :: POLLRDHUP  = int(z'2000')

    integer(kind=c_int), parameter, public :: POLLERR  = int(z'008')      ! Error condition.
    integer(kind=c_int), parameter, public :: POLLHUP  = int(z'010')      ! Hung up.
    integer(kind=c_int), parameter, public :: POLLNVAL = int(z'020')      ! Invalid polling request.

#elif defined (__FreeBSD__)

    integer(kind=c_int), parameter, public :: POLLIN     = int(z'0001')   ! Any readable data available.
    integer(kind=c_int), parameter, public :: POLLPRI    = int(z'0002')   ! OOB/Urgent readable data.
    integer(kind=c_int), parameter, public :: POLLOUT    = int(z'0004')   ! File descriptor is writeable.
    integer(kind=c_int), parameter, public :: POLLRDNORM = int(z'0040')   ! Non-OOB/URG data available.
    integer(kind=c_int), parameter, public :: POLLWRNORM = POLLOUT        ! No write type differentiation.
    integer(kind=c_int), parameter, public :: POLLRDBAND = int(z'0080')   ! OOB/Urgent readable data.
    integer(kind=c_int), parameter, public :: POLLWRBAND = int(z'0100')   ! OOB/Urgent data can be written.

    integer(kind=c_int), parameter, public :: POLLINIGNEOF = int(z'2000') ! Like POLLIN, except ignore EOF.
    integer(kind=c_int), parameter, public :: POLLRDHUP    = int(z'4000') ! Half shut down.

    integer(kind=c_int), parameter, public :: POLLERR  = int(z'0008')     ! Some poll error occurred.
    integer(kind=c_int), parameter, public :: POLLHUP  = int(z'0010')     ! File descriptor was "hung up".
    integer(kind=c_int), parameter, public :: POLLNVAL = int(z'0020')     ! Requested events "invalid".

#endif

    ! struct pollfd
    type, bind(c), public :: c_pollfd
        integer(kind=c_int)   :: fd      = 0
        integer(kind=c_short) :: events  = 0_c_short
        integer(kind=c_short) :: revents = 0_c_short
    end type c_pollfd

    public :: c_poll

    interface
        ! int poll(struct pollfd fds[], nfds_t nfds, int timeout)
        function c_poll(fds, nfds, timeout) bind(c, name='poll')
            import :: c_int, c_nfds_t, c_pollfd
            implicit none
            type(c_pollfd),         intent(inout)     :: fds(*)
            integer(kind=c_nfds_t), intent(in), value :: nfds
            integer(kind=c_int),    intent(in), value :: timeout
            integer(kind=c_int)                       :: c_poll
        end function c_poll
    end interface
end module unix_poll
