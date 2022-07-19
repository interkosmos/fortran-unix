! unix_stdio.F90
module unix_stdio
    use, intrinsic :: iso_c_binding
    implicit none
    private

    public :: c_getline
    public :: c_fclose
    public :: c_fdopen
    public :: c_fflush
    public :: c_fgetc
    public :: c_fgets
    public :: c_fopen
    public :: c_fprintf
    public :: c_fputs
    public :: c_fread
    public :: c_fwrite
    public :: c_pclose
    public :: c_perror
    public :: c_popen
    public :: c_putchar
    public :: c_scanf
    public :: c_setbuf
    public :: c_setvbuf

    integer(kind=c_int), parameter, public :: EOF = -1

    interface
        ! ssize_t getline(char **lineptr, size_t *n, FILE *stream)
        function c_getline(lineptr, n, stream) bind(c, name='getline')
            import :: c_char, c_ptr, c_size_t
            implicit none
            character(kind=c_char), intent(in)        :: lineptr(*)
            integer(kind=c_size_t), intent(in)        :: n
            type(c_ptr),            intent(in), value :: stream
            integer(kind=c_size_t)                    :: c_getline
        end function c_getline

        ! int fclose(FILE *stream)
        function c_fclose(stream) bind(c, name='fclose')
            import :: c_int, c_ptr
            implicit none
            type(c_ptr), intent(in), value :: stream
            integer(kind=c_int)            :: c_fclose
        end function c_fclose

        ! FILE *fopen(int fd, const char *mode)
        function c_fdopen(fd, mode) bind(c, name='fdopen')
            import :: c_char, c_int, c_ptr
            implicit none
            integer(kind=c_int),    intent(in), value :: fd
            character(kind=c_char), intent(in)        :: mode
            type(c_ptr)                               :: c_fdopen
        end function c_fdopen

        ! int fflush(FILE *stream)
        function c_fflush(stream) bind(c, name='fflush')
           import :: c_int, c_ptr
            implicit none
            type(c_ptr), intent(in), value :: stream
            integer(kind=c_int)            :: c_fflush
        end function c_fflush

        ! int fgetc(FILE *stream)
        function c_fgetc(stream) bind(c, name='fgetc')
            import :: c_int, c_ptr
            implicit none
            type(c_ptr), intent(in), value :: stream
            integer(kind=c_int)            :: c_fgetc
        end function c_fgetc

        ! char *fgets(char *str, int size, FILE *stream)
        function c_fgets(str, size, stream) bind(c, name='fgets')
            import :: c_char, c_int, c_ptr
            implicit none
            character(kind=c_char), intent(in)        :: str
            integer(kind=c_int),    intent(in), value :: size
            type(c_ptr),            intent(in), value :: stream
            type(c_ptr)                               :: c_fgets
        end function c_fgets

        ! FILE *fopen(const char *path, const char *mode)
        function c_fopen(path, mode) bind(c, name='fopen')
            import :: c_char, c_ptr
            implicit none
            character(kind=c_char), intent(in) :: path
            character(kind=c_char), intent(in) :: mode
            type(c_ptr)                        :: c_fopen
        end function c_fopen

        ! int fprintf(FILE *stream, const char *format, ...)
        function c_fprintf(stream, format) bind(c, name='fprintf')
            import :: c_char, c_int, c_ptr
            implicit none
            type(c_ptr),            intent(in), value :: stream
            character(kind=c_char), intent(in)        :: format
            integer(kind=c_int)                       :: c_fprintf
        end function c_fprintf

        ! int fputs(const char *str, FILE *stream)
        function c_fputs(str, stream) bind(c, name='fputs')
            import :: c_char, c_int, c_ptr
            implicit none
            character(kind=c_char), intent(in)        :: str
            type(c_ptr),            intent(in), value :: stream
            integer(kind=c_int)                       :: c_fputs
        end function c_fputs

        ! size_t fread(void *restrict ptr, size_t size, size_t nmemb, FILE *restrict stream)
        function c_fread(ptr, size, nmemb, stream) bind(c, name='fread')
            import :: c_ptr, c_size_t
            implicit none
            type(c_ptr),            intent(in), value :: ptr
            integer(kind=c_size_t), intent(in), value :: size
            integer(kind=c_size_t), intent(in), value :: nmemb
            type(c_ptr),            intent(in), value :: stream
            integer(kind=c_size_t)                    :: c_fread
        end function c_fread

        ! size_t fwrite(const void *restrict ptr, size_t size, size_t nmemb, FILE *restrict stream)
        function c_fwrite(ptr, size, nmemb, stream) bind(c, name='fwrite')
            import :: c_ptr, c_size_t
            implicit none
            type(c_ptr),            intent(in), value :: ptr
            integer(kind=c_size_t), intent(in), value :: size
            integer(kind=c_size_t), intent(in), value :: nmemb
            type(c_ptr),            intent(in), value :: stream
            integer(kind=c_size_t)                    :: c_fwrite
        end function c_fwrite

        ! int pclose(FILE *stream)
        function c_pclose(stream) bind(c, name='pclose')
            import :: c_int, c_ptr
            implicit none
            type(c_ptr), intent(in), value :: stream
            integer(kind=c_int)            :: c_pclose
        end function c_pclose

        ! void perror(const char *s)
        subroutine c_perror(s) bind(c, name='perror')
            import :: c_char
            implicit none
            character(kind=c_char), intent(in) :: s
        end subroutine c_perror

        ! FILE *popen(const char *command, const char *type)
        function c_popen(command, type) bind(c, name='popen')
            import :: c_char, c_ptr
            implicit none
            character(kind=c_char), intent(in) :: command
            character(kind=c_char), intent(in) :: type
            type(c_ptr)                        :: c_popen
        end function c_popen

        ! int putchar(int char)
        function c_putchar(char) bind(c, name='putchar')
            import :: c_int
            implicit none
            integer(kind=c_int), intent(in), value :: char
            integer(kind=c_int)                    :: c_putchar
        end function c_putchar

        ! int scanf(const char *format, ...)
        function c_scanf(format, str) bind(c, name='scanf')
            import :: c_char, c_int
            implicit none
            character(kind=c_char), intent(in) :: format
            character(kind=c_char), intent(in) :: str
            integer(kind=c_int)                :: c_scanf
        end function c_scanf

        ! void setbuf(FILE *stream, char *buf)
        subroutine c_setbuf(stream, buf) bind(c, name='setbuf')
            import :: c_int, c_ptr
            implicit none
            integer(kind=c_int), intent(in)        :: stream
            type(c_ptr),         intent(in), value :: buf
        end subroutine c_setbuf

        ! int setvbuf(FILE *stream, char *buf, int mode, size_t size)
        function c_setvbuf(stream, buf, mode, size) bind(c, name='setvbuf')
            import :: c_int, c_ptr, c_size_t
            implicit none
            integer(kind=c_int),    intent(in)        :: stream
            type(c_ptr),            intent(in), value :: buf
            integer(kind=c_int),    intent(in), value :: mode
            integer(kind=c_size_t), intent(in), value :: size
            integer(kind=c_int)                       :: c_setvbuf
        end function c_setvbuf
    end interface
end module unix_stdio
