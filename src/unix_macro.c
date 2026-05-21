/* unix_macro.c */
#include <errno.h>
#include <fcntl.h>
#include <spawn.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/utsname.h>
#include <syslog.h>
#include <unistd.h>

#ifdef __cplusplus
extern "C" {
#endif

int c_errno(void);
int c_execl(const char *, const char *, const char *, const char *, void *);
int c_fcntl(int, int, int);
int c_fprintf(void *, const char *, const char *);
int c_ioctl(int, unsigned long, void *);
int c_open(const char *, int, mode_t);
int c_posix_spawn_file_actions_destroy(void *);
int c_posix_spawn_file_actions_init(void **);
int c_scanf(const char *, const char *);
int c_uname(void *);
void c_syslog(int, const char *, const char *);

/*******************************************************************************
 *** Macro replacements.                                                     ***
 *******************************************************************************/

/* Returns variable `errno` from `errno.h`. */
int c_errno(void)
{
    return errno;
}

/* int uname(struct utsname *name) */
int c_uname(void *name)
{
    return uname((struct utsname *) name);
}

/*******************************************************************************
 *** Non-variadic and other wrapper procedures.                              ***
 *******************************************************************************/

/* int execl(const char *path, const char *arg, ...) */
int c_execl(const char *path, const char *arg1, const char *arg2, const char *arg3, void *ptr)
{
    return execl(path, arg1, arg2, arg3, ptr, NULL);
}

/* int fcntl(int fd, int cmd, ...) */
int c_fcntl(int fd, int cmd, int arg)
{
    return fcntl(fd, cmd, arg);
}

/* int fprintf(FILE *stream, const char *format, ...) */
int c_fprintf(void *stream, const char *format, const char *arg)
{
    return fprintf((FILE *) stream, format, arg);
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

/* int posix_spawn_file_actions_destroy(posix_spawn_file_actions_t *file_actions) */
int c_posix_spawn_file_actions_destroy(void *file_actions)
{
    int rc;

    rc = posix_spawn_file_actions_destroy((posix_spawn_file_actions_t *) file_actions);
    free(file_actions);
    return rc;
}

/* int posix_spawn_file_actions_init(posix_spawn_file_actions_t *file_actions) */
int c_posix_spawn_file_actions_init(void **file_actions)
{
    *file_actions = NULL;

    posix_spawn_file_actions_t *actions;
    actions = malloc(sizeof(posix_spawn_file_actions_t));

    if (!actions)
    {
        return -1;
    }

    int rc = posix_spawn_file_actions_init(actions);

    if (rc != 0)
    {
        free(actions);
        return rc;
    }

    *file_actions = (void *) actions;
    return rc;
}

/* int scanf(const char *format, ...) */
int c_scanf(const char *format, const char *arg)
{
    return scanf(format, arg);
}

/* void syslog(int priority, const char *format, ...) */
void c_syslog(int priority, const char *format, const char *arg)
{
    syslog(priority, format, arg);
}

#ifdef __cplusplus
}
#endif
