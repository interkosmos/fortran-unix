! unix_wait.F90
module unix_wait
    use, intrinsic :: iso_c_binding
    use :: unix_types
    implicit none
    private

    public :: c_wait

    interface
        ! pid_t wait(int *stat_loc)
        function c_wait(stat_loc) bind(c, name='wait')
            import :: c_int, c_pid_t
            implicit none
            integer(kind=c_int), intent(out) :: stat_loc
            integer(kind=c_pid_t)            :: c_wait
        end function c_wait
    end interface
end module unix_wait
