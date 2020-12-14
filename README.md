# fortran-unix
A work-in-progress collection of Fortran 2008 ISO C binding interfaces to
selected POSIX and SysV types, functions, and routines on 64-bit Unix-like
operating systems:

* standard input/output,
* directory listing,
* clocks and timers,
* signals,
* processes,
* POSIX threads,
* BSD sockets,
* UNIX System V message queues,
* POSIX message queues.

Similar libraries for modern Fortran:

* [fortyxima](https://bitbucket.org/aradi/fortyxima/),
* [M_system](https://github.com/urbanjost/M_system),
* [M_process](https://github.com/urbanjost/M_process).

Currently, only Linux and FreeBSD are supported. The library has been tested
on:

* FreeBSD 12 (GNU Fortran 10),
* CentOS 8 (GNU Fortran 8, Intel Fortran Compiler 19).

Preprocessor macros are used to achieve platform-independent interoperability.
Therefore, your Fortran compiler has to support at least GNU preprocessor
conditionals (`#ifdef` …).

## Build Instructions
Run GNU/BSD make to build the static library `libfortran-unix.a`:

```
$ make
```

If you use GNU Fortran, set the parameter `OS` to either `linux` or `FreeBSD`,
for instance:

```
$ make OS=linux PREFIX=/usr
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
* **os** returns the name of the operating system (Linux, macOS, FreeBSD, ...).
* **pthread** runs a Fortran subroutine inside multiple POSIX threads.
* **signal** catches SIGINT (`Ctrl` + `C`).
* **socket** creates a TCP/IP connection to a local netcat server.
* **time** prints out the results of time functions.

Build the examples with:

```
$ make OS=linux examples
```

Or, call `make` with the name of a particular example.

## Licence
ISC
