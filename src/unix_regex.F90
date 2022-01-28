! unix_regex.F90
module unix_regex
    use, intrinsic :: iso_c_binding
    use :: unix_types
    implicit none
    private

#if defined (__linux__)

    integer, parameter, public :: c_regoff_t = c_size_t

    type, bind(c), public :: c_regex_t
        character(kind=c_char) :: hidden(64)
    end type c_regex_t

    integer(kind=c_int), parameter, public :: REG_EXTENDED = 1
    integer(kind=c_int), parameter, public :: REG_ICASE    = shiftl(1, 1)
    integer(kind=c_int), parameter, public :: REG_NEWLINE  = shiftl(1, 2)
    integer(kind=c_int), parameter, public :: REG_NOSUB    = shiftl(1, 3)
    integer(kind=c_int), parameter, public :: REG_NOTBOL   = 1
    integer(kind=c_int), parameter, public :: REG_NOTEOL   = shiftl(1, 1)
    integer(kind=c_int), parameter, public :: REG_STARTEND = shiftl(1, 2)

    public :: REG_ENOSYS
    public :: REG_NOERROR
    public :: REG_NOMATCH
    public :: REG_BADPAT
    public :: REG_ECOLLATE
    public :: REG_ECTYPE
    public :: REG_EESCAPE
    public :: REG_ESUBREG
    public :: REG_EBRACK
    public :: REG_EPAREN
    public :: REG_EBRACE
    public :: REG_BADBR
    public :: REG_ERANGE
    public :: REG_ESPACE
    public :: REG_BADRPT
    public :: REG_EEND
    public :: REG_ESIZE
    public :: REG_ERPAREN

    enum, bind(c)
        enumerator :: REG_ENOSYS  = -1
        enumerator :: REG_NOERROR = 0
        enumerator :: REG_NOMATCH
        enumerator :: REG_BADPAT
        enumerator :: REG_ECOLLATE
        enumerator :: REG_ECTYPE
        enumerator :: REG_EESCAPE
        enumerator :: REG_ESUBREG
        enumerator :: REG_EBRACK
        enumerator :: REG_EPAREN
        enumerator :: REG_EBRACE
        enumerator :: REG_BADBR
        enumerator :: REG_ERANGE
        enumerator :: REG_ESPACE
        enumerator :: REG_BADRPT
        enumerator :: REG_EEND
        enumerator :: REG_ESIZE
        enumerator :: REG_ERPAREN
    end enum

#elif defined (__FreeBSD__)

    integer, parameter, public :: c_regoff_t = c_int64_t

    type, bind(c), public :: c_regex_t
        integer(kind=c_int)    :: re_magic
        integer(kind=c_size_t) :: re_nsub
        type(c_ptr)            :: re_endp
        type(c_ptr)            :: re_g
    end type c_regex_t

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

#endif

    type, bind(c), public :: c_regmatch_t
        integer(kind=c_regoff_t) :: rm_so ! Start of match.
        integer(kind=c_regoff_t) :: rm_eo ! End of match.
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
