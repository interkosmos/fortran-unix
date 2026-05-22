! unix_syslog.F90
!
! Author:  Philipp Engel
! Licence: ISC
module unix_syslog
    use :: unix_types
    implicit none
    private

    integer(c_int), parameter, public :: LOG_EMERG   = 0 ! system is unusable
    integer(c_int), parameter, public :: LOG_ALERT   = 1 ! action must be taken immediately
    integer(c_int), parameter, public :: LOG_CRIT    = 2 ! critical conditions
    integer(c_int), parameter, public :: LOG_ERR     = 3 ! error conditions
    integer(c_int), parameter, public :: LOG_WARNING = 4 ! warning conditions
    integer(c_int), parameter, public :: LOG_NOTICE  = 5 ! normal but significant condition
    integer(c_int), parameter, public :: LOG_INFO    = 6 ! informational
    integer(c_int), parameter, public :: LOG_DEBUG   = 7 ! debug-level messages

    integer(c_int), parameter, public :: LOG_KERN     = shiftl( 0, 3) ! kernel messages
    integer(c_int), parameter, public :: LOG_USER     = shiftl( 1, 3) ! random user-level messages
    integer(c_int), parameter, public :: LOG_MAIL     = shiftl( 2, 3) ! mail system
    integer(c_int), parameter, public :: LOG_DAEMON   = shiftl( 3, 3) ! system daemons
    integer(c_int), parameter, public :: LOG_AUTH     = shiftl( 4, 3) ! security/authorization messages
    integer(c_int), parameter, public :: LOG_SYSLOG   = shiftl( 5, 3) ! messages generated internally by syslogd
    integer(c_int), parameter, public :: LOG_LPR      = shiftl( 6, 3) ! line printer subsystem
    integer(c_int), parameter, public :: LOG_NEWS     = shiftl( 7, 3) ! network news subsystem
    integer(c_int), parameter, public :: LOG_UUCP     = shiftl( 8, 3) ! UUCP subsystem
    integer(c_int), parameter, public :: LOG_CRON     = shiftl( 9, 3) ! clock daemon
    integer(c_int), parameter, public :: LOG_AUTHPRIV = shiftl(10, 3) ! security/authorization messages (private)
    integer(c_int), parameter, public :: LOG_FTP      = shiftl(11, 3) ! ftp daemon

#if defined (__FreeBSD__)

    integer(c_int), parameter, public :: LOG_NTP      = shiftl(12, 3) ! NTP subsystem
    integer(c_int), parameter, public :: LOG_SECURITY = shiftl(13, 3) ! security subsystems (firewalling, etc.)
    integer(c_int), parameter, public :: LOG_CONSOLE  = shiftl(14, 3) ! /dev/console output

#endif

    integer(c_int), parameter, public :: LOG_PID    = int(z'01') ! Log the pid with each message.
    integer(c_int), parameter, public :: LOG_CONS   = int(z'02') ! Log on the console if errors in sending.
    integer(c_int), parameter, public :: LOG_ODELAY = int(z'04') ! Delay open until first syslog() (default).
    integer(c_int), parameter, public :: LOG_NDELAY = int(z'08') ! Don’t delay open.
    integer(c_int), parameter, public :: LOG_NOWAIT = int(z'10') ! Don’t wait for console forks: DEPRECATED.
    integer(c_int), parameter, public :: LOG_PERROR = int(z'20') ! Log to stderr as well:

    public :: c_closelog
    public :: c_openlog
    public :: c_syslog

    interface
       ! void closelog(void)
       subroutine c_closelog() bind(c, name='closelog')
       end subroutine c_closelog

       ! void openlog(const char *ident, int option, int facility)
       subroutine c_openlog(ident, option, facility) bind(c, name='openlog')
           import :: c_char, c_int
           implicit none
           character(c_char), intent(in)        :: ident
           integer(c_int),    intent(in), value :: option
           integer(c_int),    intent(in), value :: facility
       end subroutine c_openlog

       ! void syslog(int priority, const char *format, ...)
       subroutine c_syslog(priority, format, str) bind(c, name='c_syslog')
           import :: c_char, c_int
           implicit none
           integer(c_int),    intent(in), value :: priority
           character(c_char), intent(in)        :: format
           character(c_char), intent(in)        :: str
       end subroutine c_syslog
    end interface
end module unix_syslog
