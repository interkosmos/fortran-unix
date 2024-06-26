.POSIX:
.SUFFIXES:

# Parameters:
#
#   OS      - Set to either `FreeBSD` or `linux`:
#   PREFIX  - Change to `/usr` on Linux.
#   FC      - Fortran compiler.
#   CC      - C compiler.
#   AR      - Archiver.
#   MAKE    - Make tool.
#   FORD    - FORD documentation generator.
#   FFLAGS  - Fortran compiler flags.
#   CFLAGS  - C compiler flags.
#   PPFLAGS - Pre-processor flags. Change to `-fpp` for Intel IFORT.
#   ARFLAGS - Archiver flags.
#   LDFLAGS - Linker flags.
#   LDLIBS  - Linker libraries.
#   TARGET  - Output library name. #
#
OS      = FreeBSD
PREFIX  = /usr/local
FC      = gfortran
CC      = gcc
AR      = ar
MAKE    = make
FORD    = ford

DEBUG   = -g -O0 -Wall -fmax-errors=1
RELEASE = -O2 -march=native

FFLAGS  = $(RELEASE)
CFLAGS  = $(RELEASE)
PPFLAGS = -cpp -D__$(OS)__
ARFLAGS = rcs
LDFLAGS = -I$(PREFIX)/include -L$(PREFIX)/lib
LDLIBS  =
INCDIR  = $(PREFIX)/include/libfortran-unix
LIBDIR  = $(PREFIX)/lib
DOCDIR  = ./doc

TARGET  = libfortran-unix.a

SRC = src/unix.f90 src/unix_dirent.F90 src/unix_errno.F90 src/unix_fcntl.F90 \
      src/unix_inet.F90 src/unix_ioctl.F90 src/unix_ipc.F90 src/unix_mqueue.F90 \
      src/unix_msg.F90 src/unix_netdb.F90 src/unix_pthread.F90 \
      src/unix_regex.F90 src/unix_semaphore.F90 src/unix_signal.F90 \
      src/unix_socket.F90 src/unix_stat.F90 src/unix_stdio.F90 \
      src/unix_stdlib.F90 src/unix_string.F90 src/unix_syslog.F90 \
      src/unix_termios.F90 src/unix_time.F90 src/unix_types.F90 \
      src/unix_unistd.F90 src/unix_utsname.F90 src/unix_wait.F90

OBJ = unix.o unix_dirent.o unix_errno.o unix_fcntl.o \
      unix_inet.o unix_ioctl.o unix_ipc.o unix_mqueue.o unix_msg.o \
      unix_netdb.o unix_pthread.o unix_regex.o unix_semaphore.o \
      unix_signal.o unix_socket.o unix_stat.o unix_stdio.o \
      unix_stdlib.o unix_string.o unix_syslog.o unix_termios.o \
      unix_time.o unix_types.o unix_unistd.o unix_utsname.o \
      unix_wait.o unix_macro.o

.PHONY: all clean doc examples install \
        freebsd freebsd_doc freebsd_examples \
        linux linux_aarch64 linux_doc linux_examples

all: $(TARGET)

# Library
$(TARGET): $(SRC)
	$(CC) $(CFLAGS) -c src/unix_macro.c
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_types.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_dirent.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_errno.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_fcntl.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_inet.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_ioctl.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_ipc.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_time.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_mqueue.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_msg.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_netdb.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_pthread.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_regex.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_semaphore.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_signal.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_socket.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_stat.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_stdio.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_stdlib.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_string.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_syslog.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_termios.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_unistd.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_utsname.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_wait.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix.f90
	$(AR) $(ARFLAGS) $(TARGET) $(OBJ)

freebsd:
	$(MAKE) $(TARGET) OS=FreeBSD

linux:
	$(MAKE) $(TARGET) OS=linux

linux_aarch64:
	$(MAKE) $(TARGET) PPFLAGS="-cpp -D__linux__ -D__aarch64__"

freebsd_examples:
	$(MAKE) examples OS=FreeBSD

linux_examples:
	$(MAKE) examples OS=linux

# Examples
examples: dirent fifo fork irc key mqueue mutex msg os pid pipe pthread regex \
          semaphore serial signal socket stat time uname uptime

dirent: $(TARGET) examples/dirent/dirent.f90
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o dirent examples/dirent/dirent.f90 $(TARGET) $(LDLIBS)

fifo: $(TARGET) examples/fifo/fifo.f90
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o fifo examples/fifo/fifo.f90 $(TARGET) $(LDLIBS)

fork: $(TARGET) examples/fork/fork.f90
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o fork examples/fork/fork.f90 $(TARGET) $(LDLIBS)

irc: $(TARGET) examples/irc/irc.f90
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o irc examples/irc/irc.f90 $(TARGET) $(LDLIBS)

key: $(TARGET) examples/key/key.f90
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o key examples/key/key.f90 $(TARGET) $(LDLIBS)

mqueue: $(TARGET) examples/mqueue/mqueue.f90
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o mqueue examples/mqueue/mqueue.f90 $(TARGET) $(LDLIBS) -lrt

msg: $(TARGET) examples/msg/msg.f90
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o msg examples/msg/msg.f90 $(TARGET) $(LDLIBS)

mutex: $(TARGET) examples/mutex/mutex.f90
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o mutex examples/mutex/mutex.f90 $(TARGET) $(LDLIBS) -lpthread

os: $(TARGET) examples/os/os.F90
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o os examples/os/os.F90 $(TARGET) $(LDLIBS)

pid: $(TARGET) examples/pid/pid.f90
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o pid examples/pid/pid.f90 $(TARGET) $(LDLIBS)

pipe: $(TARGET) examples/pipe/pipe.f90
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o pipe examples/pipe/pipe.f90 $(TARGET) $(LDLIBS)

pthread: $(TARGET) examples/pthread/pthread.f90
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o pthread examples/pthread/pthread.f90 $(TARGET) $(LDLIBS) -lpthread

regex: $(TARGET) examples/regex/regex.f90
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o regex examples/regex/regex.f90 $(TARGET) $(LDLIBS)

semaphore: $(TARGET) examples/semaphore/semaphore.f90
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o semaphore examples/semaphore/semaphore.f90 $(TARGET) $(LDLIBS) -lpthread

serial: $(TARGET) examples/serial/serial.f90
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o serial examples/serial/serial.f90 $(TARGET) $(LDLIBS)

signal: $(TARGET) examples/signal/signal.f90
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o signal examples/signal/signal.f90 $(TARGET) $(LDLIBS)

socket: $(TARGET) examples/socket/socket.f90
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o socket examples/socket/socket.f90 $(TARGET) $(LDLIBS)

stat: $(TARGET) examples/stat/stat.f90
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o stat examples/stat/stat.f90 $(TARGET) $(LDLIBS)

time: $(TARGET) examples/time/time.f90
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o time examples/time/time.f90 $(TARGET) $(LDLIBS)

uname: $(TARGET) examples/uname/uname.f90
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o uname examples/uname/uname.f90 $(TARGET) $(LDLIBS)

uptime: $(TARGET) examples/uptime/uptime.f90
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o uptime examples/uptime/uptime.f90 $(TARGET) $(LDLIBS)

# Documentation
doc: ford.md
	$(FORD) -d ./src ford.md

freebsd_doc: ford.md
	$(FORD) -m "__FreeBSD__" -d ./src ford.md

linux_doc: ford.md
	$(FORD) -m "__linux__" -d ./src ford.md

# Installation.
install: $(TARGET)
	@echo "--- Installing $(TARGET) to $(LIBDIR)/ ..."
	install -d $(LIBDIR)
	install -m 644 $(TARGET) $(LIBDIR)/
	@echo "--- Installing module files to $(INCDIR)/ ..."
	install -d $(INCDIR)
	install -m 644 unix*.mod $(INCDIR)/

# Clean-up.
clean:
	if [ `ls -1 *.mod 2>/dev/null | wc -l` -gt 0 ]; then rm *.mod; fi
	if [ `ls -1 *.o 2>/dev/null | wc -l` -gt 0 ]; then rm *.o; fi
	if [ -e $(DOCDIR) ]; then rm -r $(DOCDIR); fi
	if [ -e $(TARGET) ]; then rm $(TARGET); fi
	if [ -e dirent ]; then rm dirent; fi
	if [ -e fifo ]; then rm fifo; fi
	if [ -e fork ]; then rm fork; fi
	if [ -e irc ]; then rm irc; fi
	if [ -e key ]; then rm key; fi
	if [ -e mqueue ]; then rm mqueue; fi
	if [ -e msg ]; then rm msg; fi
	if [ -e mutex ]; then rm mutex; fi
	if [ -e os ]; then rm os; fi
	if [ -e pid ]; then rm pid; fi
	if [ -e pipe ]; then rm pipe; fi
	if [ -e pthread ]; then rm pthread; fi
	if [ -e regex ]; then rm regex; fi
	if [ -e semaphore ]; then rm semaphore; fi
	if [ -e serial ]; then rm serial; fi
	if [ -e signal ]; then rm signal; fi
	if [ -e socket ]; then rm socket; fi
	if [ -e stat ]; then rm stat; fi
	if [ -e time ]; then rm time; fi
	if [ -e uname ]; then rm uname; fi
	if [ -e uptime ]; then rm uptime; fi
