# fortran-unix

[![Build](https://github.com/interkosmos/fortran-unix/actions/workflows/build.yml/badge.svg)](https://github.com/interkosmos/fortran-unix/actions/workflows/build.yml)

A work-in-progress collection of Fortran 2008 ISO C binding interfaces to
selected POSIX and SysV types, functions, and routines on 64-bit Unix-like
operating systems:

* standard input/output,
* file and directory access,
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

* [M_process](https://github.com/urbanjost/M_process),
* [M_system](https://github.com/urbanjost/M_system),
* [forthreads](https://github.com/ohm314/forthreads),
* [fortran-server](https://github.com/lukeasrodgers/fortran-server),
* [fortranposix](https://sourceforge.net/projects/fortranposix/),
* [fortyxima](https://bitbucket.org/aradi/fortyxima/),
* [fsockets](https://github.com/trifling/fsocket),
* [posix90](http://savannah.nongnu.org/projects/posix90/).

Currently, only Linux (glibc) and FreeBSD are supported. The library has been
tested on:

* FreeBSD 14 (GNU Fortran 13),
* Debian 12 (GNU Fortran 12, Intel oneAPI 2024).

Preprocessor macros are used to achieve platform-independent interoperability.
Therefore, your Fortran compiler has to support at least GNU preprocessor
conditionals (`#ifdef` …).

## Build Instructions

Run either GNU/BSD make or [FPM](https://github.com/fortran-lang/fpm) to build
the static library `libfortran-unix.a`. Link your Fortran application with
`libfortran-unix.a`, and optionally with `-lpthread` to access POSIX threads, or
`-lrt` to access POSIX message queues.

### Make

On FreeBSD, run:

```
$ make freebsd
```

On Linux (x86-64), run instead:

```
$ make linux
```

On Linux (aarch64), run:

```
$ make linux_aarch64
```

To build with Intel oneAPI, run:

```
$ make CC=icx FC=ifx PPFLAGS=
```

Optionally, install `libfortran-unix.a` and the associated module files
system-wide:

```
$ make install PREFIX=/opt
--- Installing libfortran-unix.a to /opt/lib/ ...
--- Installing module files to /opt/include/libfortran-unix/ ...
```

### Fortran Package Manager

Using FPM, a preprocessor flag has to be passed to GNU Fortran. On FreeBSD:

```
$ fpm build --profile release --flag "-D__FreeBSD__"
```

On Linux (x86-64):

```
$ fpm build --profile release --flag "-D__linux__"
```

On Linux (aarch64):

```
$ fpm build --profile release --flag "-D__linux__ -D__aarch64__"
```

## Source Code Documentation

The source code documentation of the library has to be created with
[FORD](https://github.com/Fortran-FOSS-Programmers/ford). Install the Python
package with:

```
$ python3 -m pip install -U ford
```

In the source repository, either run:

```
$ make freebsd_doc
```

Or:

```
$ make linux_doc
```

The HTML files will be written to directory `doc/`. Open `index.html` in a web
browser.

## Examples

Examples are provided in directory `examples/`:

* **dirent** prints the contents of a file system directory.
* **fifo** creates a named pipe for IPC.
* **fork** forks a process and uses anonymous pipes for IPC.
* **irc** implements a basic IRC bot, based on BSD sockets.
* **key** reads single key-strokes from standard input.
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
* **stat** reads and outputs status of a file.
* **time** prints out the results of time functions.
* **uname** prints OS information from `uname()`.
* **uptime** outputs system uptime.

To compile the example programs, either run:

```
$ make freebsd_examples
```

Or:

```
$ make linux_examples
```

## Licence

ISC
