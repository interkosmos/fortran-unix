/* unix_macro.c */
#include <errno.h>
#include <fcntl.h>
#include <sys/ioctl.h>

/* Returns variable `errno` from `errno.h`. */
int c_errno()
{
    return errno;
}

/* int fcntl(int fd, int cmd, ...) */
int c_fcntl(int fd, int cmd, int arg)
{
    return fcntl(fd, cmd, arg);
}

/* int ioctl(int fd, unsigned long request, ...) */
int c_ioctl(int fd, unsigned long request, void *arg)
{
    return ioctl(fd, request, arg);
}

/* int open(const char *pathname, int flags, ...) */
int c_open(const char *pathname, int flags, mode_t mode)
{
    return open(pathname, flags, mode);
}
