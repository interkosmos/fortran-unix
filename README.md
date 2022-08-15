# fortran-unix
A work-in-progress collection of Fortran 2008 ISO C binding interfaces to
selected POSIX and SysV types, functions, and routines on 64-bit Unix-like
operating systems:

* standard input/output,
* directory access,
* clocks and timers,
* signals,
* processes,
* pipes,
* serial port input/output,
* terminal control,
* POSIX threads,
* POSIX mutexes and semaphores,
* POSIX regular expressions,
* BSD sockets,
* UNIX System V message queues,
* POSIX message queues.

Similar libraries for modern Fortran:

* [fortyxima](https://bitbucket.org/aradi/fortyxima/),
* [M_process](https://github.com/urbanjost/M_process),
* [M_system](https://github.com/urbanjost/M_system).

Currently, only Linux (glibc) and FreeBSD are supported. The library has been
tested on:

* FreeBSD 13 (GNU Fortran 12),
* CentOS 8 (GNU Fortran 8, Intel Fortran Compiler 19).

Preprocessor macros are used to achieve platform-independent interoperability.
Therefore, your Fortran compiler has to support at least GNU preprocessor
conditionals (`#ifdef` …).

## Build Instructions
Run either GNU/BSD make or [fpm](https://github.com/fortran-lang/fpm) to build
the static library `libfortran-unix.a`. On FreeBSD:

```
$ make freebsd
```

On Linux:

```
$ make linux
```

Or, instead, set parameter `OS` to either `linux` or `FreeBSD`, and `PREFIX` to
`/usr` or `/usr/local`, for instance:

```
$ make FC=gfortran OS=linux PREFIX=/usr
```

Using fpm, preprocessor flags have to be passed to GNU Fortran:

```
$ fpm build --profile=release --flag="-D__linux__"
```

Or:

```
$ fpm build --profile=release --flag="-D__FreeBSD__"
```

Link your Fortran application with `libfortran-unix.a`, and optionally with
`-lpthread` to access POSIX threads or `-lrt` to access POSIX message queues.

## Examples
Examples are provided in directory `examples/`:

* **dirent** prints the contents of a file system directory.
* **fifo** creates a named pipe for IPC.
* **fork** forks a process and uses anonymous pipes for IPC.
* **irc** implements a basic IRC bot, based on BSD sockets.
* **mqueue** creates a POSIX message queue.
* **msg** shows message passing with UNIX System V message queues.
* **mutex** demonstrates threaded access to variable using a mutex.
* **os** returns the name of the operating system (Linux, macOS, FreeBSD, ...).
* **pid** outputs the process id.
* **pipe** creates anonymous pipes for bidirectional IPC.
* **pthread** runs a Fortran subroutine inside multiple POSIX threads.
* **regex** calls POSIX regex functions.
* **semaphore** tests POSIX semaphores.
* **serial** shows some basic serial port input reading (requires *socat(1)* and *minicom(1)*).
* **signal** catches SIGINT (`CTRL` + `C`).
* **socket** creates a TCP/IP connection to a local netcat server (requires *nc(1)*).
* **time** prints out the results of time functions.
* **uname** prints OS information from `uname()`.
* **uptime** outputs system uptime.

The example programs are built by default. Otherwise, run:

```
$ make OS=linux PREFIX=/usr examples
```

Or, call `make` with the name of a particular example.

## Licence
ISC
