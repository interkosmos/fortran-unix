! unix_regex.F90
!
! Author:  Philipp Engel
! Licence: ISC
module unix_regex
    use, intrinsic :: iso_c_binding
    use :: unix_types
    implicit none
    private

#if defined (__linux__)

    integer(kind=c_int), parameter, public :: REG_EXTENDED = 1
    integer(kind=c_int), parameter, public :: REG_ICASE    = shiftl(1, 1)
    integer(kind=c_int), parameter, public :: REG_NEWLINE  = shiftl(1, 2)
    integer(kind=c_int), parameter, public :: REG_NOSUB    = shiftl(1, 3)
    integer(kind=c_int), parameter, public :: REG_NOTBOL   = 1
    integer(kind=c_int), parameter, public :: REG_NOTEOL   = shiftl(1, 1)
    integer(kind=c_int), parameter, public :: REG_STARTEND = shiftl(1, 2)

    integer(kind=c_int), parameter, public :: REG_ENOSYS   = -1
    integer(kind=c_int), parameter, public :: REG_NOERROR  = 0
    integer(kind=c_int), parameter, public :: REG_NOMATCH  = 1
    integer(kind=c_int), parameter, public :: REG_BADPAT   = 2
    integer(kind=c_int), parameter, public :: REG_ECOLLATE = 3
    integer(kind=c_int), parameter, public :: REG_ECTYPE   = 4
    integer(kind=c_int), parameter, public :: REG_EESCAPE  = 5
    integer(kind=c_int), parameter, public :: REG_ESUBREG  = 6
    integer(kind=c_int), parameter, public :: REG_EBRACK   = 7
    integer(kind=c_int), parameter, public :: REG_EPAREN   = 8
    integer(kind=c_int), parameter, public :: REG_EBRACE   = 9
    integer(kind=c_int), parameter, public :: REG_BADBR    = 10
    integer(kind=c_int), parameter, public :: REG_ERANGE   = 11
    integer(kind=c_int), parameter, public :: REG_ESPACE   = 12
    integer(kind=c_int), parameter, public :: REG_BADRPT   = 13
    integer(kind=c_int), parameter, public :: REG_EEND     = 14
    integer(kind=c_int), parameter, public :: REG_ESIZE    = 15
    integer(kind=c_int), parameter, public :: REG_ERPAREN  = 16

    ! struct regex_t
    type, bind(c), public :: c_regex_t
        private
        character(kind=c_char) :: hidden(64)
    end type c_regex_t

#elif defined (__FreeBSD__)

    ! regcomp() flags
    integer(kind=c_int), parameter, public :: REG_BASIC    = int(o'0000')
    integer(kind=c_int), parameter, public :: REG_EXTENDED = int(o'0001')
    integer(kind=c_int), parameter, public :: REG_ICASE    = int(o'0002')
    integer(kind=c_int), parameter, public :: REG_NOSUB    = int(o'0004')
    integer(kind=c_int), parameter, public :: REG_NEWLINE  = int(o'0010')
    integer(kind=c_int), parameter, public :: REG_NOSPEC   = int(o'0020')
    integer(kind=c_int), parameter, public :: REG_PEND     = int(o'0040')
    integer(kind=c_int), parameter, public :: REG_DUMP     = int(o'0200')

    ! regerror() flags
    integer(kind=c_int), parameter, public :: REG_ENOSYS   = -1
    integer(kind=c_int), parameter, public :: REG_NOMATCH  = 1
    integer(kind=c_int), parameter, public :: REG_BADPAT   = 2
    integer(kind=c_int), parameter, public :: REG_ECOLLATE = 3
    integer(kind=c_int), parameter, public :: REG_ECTYPE   = 4
    integer(kind=c_int), parameter, public :: REG_EESCAPE  = 5
    integer(kind=c_int), parameter, public :: REG_ESUBREG  = 6
    integer(kind=c_int), parameter, public :: REG_EBRACK   = 7
    integer(kind=c_int), parameter, public :: REG_EPAREN   = 8
    integer(kind=c_int), parameter, public :: REG_EBRACE   = 9
    integer(kind=c_int), parameter, public :: REG_BADBR    = 10
    integer(kind=c_int), parameter, public :: REG_ERANGE   = 11
    integer(kind=c_int), parameter, public :: REG_ESPACE   = 12
    integer(kind=c_int), parameter, public :: REG_BADRPT   = 13
    integer(kind=c_int), parameter, public :: REG_EMPTY    = 14
    integer(kind=c_int), parameter, public :: REG_ASSERT   = 15
    integer(kind=c_int), parameter, public :: REG_INVARG   = 16
    integer(kind=c_int), parameter, public :: REG_ILLSEQ   = 17
    integer(kind=c_int), parameter, public :: REG_ATOI     = 255
    integer(kind=c_int), parameter, public :: REG_ITOA     = int(o'0400')

    ! regexec() flags
    integer(kind=c_int), parameter, public :: REG_NOTBOL   = int(o'00001')
    integer(kind=c_int), parameter, public :: REG_NOTEOL   = int(o'00002')
    integer(kind=c_int), parameter, public :: REG_STARTEND = int(o'00004')
    integer(kind=c_int), parameter, public :: REG_TRACE    = int(o'00400')
    integer(kind=c_int), parameter, public :: REG_LARGE    = int(o'01000')
    integer(kind=c_int), parameter, public :: REG_BACKR    = int(o'02000')

    ! struct regex_t
    type, bind(c), public :: c_regex_t
        integer(kind=c_int)    :: re_magic = 0
        integer(kind=c_size_t) :: re_nsub  = 0_c_size_t
        type(c_ptr)            :: re_endp  = c_null_ptr
        type(c_ptr)            :: re_g     = c_null_ptr
    end type c_regex_t

#endif

    type, bind(c), public :: c_regmatch_t
        integer(kind=c_regoff_t) :: rm_so = 0_c_regoff_t ! Start of match.
        integer(kind=c_regoff_t) :: rm_eo = 0_c_regoff_t ! End of match.
    end type c_regmatch_t

    public :: c_regcomp
    public :: c_regerror
    public :: c_regexec
    public :: c_regfree

    interface
        ! int regcomp(regex_t *preg, const char *regex, int cflags);
        function c_regcomp(preg, regex, cflags) bind(c, name='regcomp')
            import :: c_char, c_int, c_regex_t
            implicit none
            type(c_regex_t),        intent(in)        :: preg
            character(kind=c_char), intent(in)        :: regex
            integer(kind=c_int),    intent(in), value :: cflags
            integer(kind=c_int)                       :: c_regcomp
        end function c_regcomp

        ! size_t regerror(int errcode, const regex_t *preg, char *errbuf, size_t errbuf_size);
        function c_regerror(errcode, preg, errbuf, errbuf_size) bind(c, name='regerror')
            import :: c_int, c_ptr, c_regex_t, c_size_t
            implicit none
            integer(kind=c_int),    intent(in), value :: errcode
            type(c_regex_t),        intent(in)        :: preg
            type(c_ptr),            intent(in), value :: errbuf
            integer(kind=c_size_t), intent(in), value :: errbuf_size
            integer(kind=c_size_t)                    :: c_regerror
        end function c_regerror

        ! int regexec(const regex_t *preg, const char *string, size_t nmatch, regmatch_t pmatch[], int eflags);
        function c_regexec(preg, string, nmatch, pmatch, eflags) bind(c, name='regexec')
            import :: c_char, c_int, c_ptr, c_regex_t, c_size_t
            implicit none
            type(c_regex_t),        intent(in)        :: preg
            character(kind=c_char), intent(in)        :: string
            integer(kind=c_size_t), intent(in), value :: nmatch
            type(c_ptr),            intent(in), value :: pmatch
            integer(kind=c_int),    intent(in), value :: eflags
            integer(kind=c_int)                       :: c_regexec
        end function c_regexec

        ! void regfree(regex_t *preg)
        subroutine c_regfree(preg) bind(c, name='regfree')
            import :: c_regex_t
            implicit none
            type(c_regex_t), intent(inout) :: preg
        end subroutine c_regfree
    end interface
end module unix_regex
