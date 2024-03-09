project:        fortran-unix
version:        0.1.0
license:        isc
doc_license:    by
graph:          false
search:         true
display:        public
sort:           alpha
fpp_extensions: F90
macro:          __linux__
preprocess:     true
summary:        **fortran-unix** – A collection of Fortran 2008 ISO C binding
                interfaces to selected POSIX and SysV types, functions, and
                routines on 64-bit Linux and FreeBSD.
author:         Philipp Engel
project_github: https://github.com/interkosmos/fortran-unix

The library covers system calls for:

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

By default, the documentation is based on the Linux API. For the FreeBSD API,
select build target `freebsd_doc`:

```
$ make freebsd_doc
```

## Build Instructions

On Linux, run:

```
$ make linux
```

On FreeBSD, run:

```
$ make freebsd
```

To compile with Intel oneAPI instead of GCC:

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

## Fortran Package Manager

Using the Fortran Package Manager, a preprocessor flag has to be passed to GNU
Fortran. On Linux:

```
$ fpm build --profile release --flag "-D__linux__"
```

On FreeBSD:

```
$ fpm build --profile release --flag "-D__FreeBSD__"
```
