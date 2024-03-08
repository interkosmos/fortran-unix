! uname.f90
!
! Author:  Philipp Engel
! Licence: ISC
program main
    !! Example program that outputs uname information.
    use :: unix
    implicit none

    character(len=SYS_NMLN) :: sys_name
    character(len=SYS_NMLN) :: node_name
    character(len=SYS_NMLN) :: release
    character(len=SYS_NMLN) :: version
    character(len=SYS_NMLN) :: machine

    integer         :: stat
    type(c_utsname) :: utsname

    stat = c_uname(utsname)
    if (stat /= 0) stop 'Error: uname() failed'

    call c_f_str_chars(utsname%sysname,  sys_name)
    call c_f_str_chars(utsname%nodename, node_name)
    call c_f_str_chars(utsname%release,  release)
    call c_f_str_chars(utsname%version,  version)
    call c_f_str_chars(utsname%machine,  machine)

    print '("OS name...: ", a)', trim(sys_name)
    print '("Node name.: ", a)', trim(node_name)
    print '("OS release: ", a)', trim(release)
    print '("OS version: ", a)', trim(version)
    print '("Platform..: ", a)', trim(machine)
end program main
