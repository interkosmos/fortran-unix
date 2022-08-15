/* unix_macro.c */
#include <errno.h>

/* Returns variable `errno` from `errno.h`. */
int error_number()
{
    return errno;
}
