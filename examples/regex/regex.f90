! regex.f90
!
! Example that does basic pattern matching with POSIX regular expressions.
!
! Author:  Philipp Engel
! Licence: ISC
program main
    use, intrinsic :: iso_c_binding
    use :: unix
    implicit none
    character(len=*), parameter :: STRING  = 'fortran'
    character(len=*), parameter :: PATTERN = '^[:lower:]*'

    character(len=32), target :: err_str
    integer                   :: rc
    integer(kind=c_size_t)    :: sz
    type(c_regex_t)           :: regex

    ! Compile regular expression.
    rc = c_regcomp(preg   = regex, &
                   regex  = PATTERN // c_null_char, &
                   cflags = 0)

    ! Check for errors.
    if (rc /= 0) then
        sz = c_regerror(errcode     = rc, &
                        preg        = regex, &
                        errbuf      = c_loc(err_str), &
                        errbuf_size = len(err_str, kind=c_size_t))

        if (sz > 0) then
            print '("regcomp(): ", a)', trim(err_str)
        else
            call c_perror('regerror()' // c_null_char)
        end if
    end if

    ! Execute regular expression. Returns 0 if pattern matches.
    rc = c_regexec(preg   = regex, &
                   string = STRING // c_null_char, &
                   nmatch = 0_c_size_t, &
                   pmatch = c_null_ptr, &
                   eflags = 0)

    if (rc == 0) then
        print '("Pattern matches!")'
    else if (rc == REG_NOMATCH) then
        print '("Pattern does not match.")'
    end if

    ! Does not free `regex` itself.
    call c_regfree(regex)
end program main
