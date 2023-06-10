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

DEBUG   = #-g -O0 -fmax-errors=1 -fcheck=all -Wall
FFLAGS  = $(DEBUG) -std=f2008
CFLAGS  = $(DEBUG)
PPFLAGS = -cpp -D__$(OS)__
ARFLAGS = rcs
LDFLAGS = -I$(PREFIX)/include/ -L$(PREFIX)/lib/
LDLIBS  =
TARGET  = libfortran-unix.a

.PHONY: all clean dirent examples fifo fork freebsd freebsd_examples \
        irc key linux linux_examples mqueue msg mutex os pid pipe pthread \
        regex serial signal socket time

all: $(TARGET)

# Library
$(TARGET):
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
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix.F90
	$(CC) $(CFLAGS) -c src/unix_macro.c
	$(AR) $(ARFLAGS) $(TARGET) unix.o unix_dirent.o unix_errno.o unix_fcntl.o \
                               unix_inet.o unix_ioctl.o unix_ipc.o unix_mqueue.o unix_msg.o \
                               unix_netdb.o unix_pthread.o unix_regex.o unix_semaphore.o \
                               unix_signal.o unix_socket.o unix_stat.o unix_stdio.o \
                               unix_stdlib.o unix_string.o unix_syslog.o unix_termios.o \
                               unix_time.o unix_types.o unix_unistd.o unix_utsname.o \
                               unix_wait.o unix_macro.o

freebsd:
	$(MAKE) $(TARGET) OS=FreeBSD

linux:
	$(MAKE) $(TARGET) OS=linux

freebsd_examples:
	$(MAKE) examples OS=FreeBSD

linux_examples:
	$(MAKE) examples OS=linux

# Examples
dirent: $(TARGET)
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o dirent examples/dirent/dirent.f90 $(TARGET) $(LDLIBS)

fifo: $(TARGET)
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o fifo examples/fifo/fifo.f90 $(TARGET) $(LDLIBS)

fork: $(TARGET)
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o fork examples/fork/fork.f90 $(TARGET) $(LDLIBS)

irc: $(TARGET)
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o irc examples/irc/irc.f90 $(TARGET) $(LDLIBS)

key: $(TARGET)
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o key examples/key/key.f90 $(TARGET) $(LDLIBS)

mqueue: $(TARGET)
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o mqueue examples/mqueue/mqueue.f90 $(TARGET) $(LDLIBS) -lrt

msg: $(TARGET)
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o msg examples/msg/msg.f90 $(TARGET) $(LDLIBS)

mutex: $(TARGET)
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o mutex examples/mutex/mutex.f90 $(TARGET) $(LDLIBS) -lpthread

os: $(TARGET)
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o os examples/os/os.F90 $(TARGET) $(LDLIBS)

pid: $(TARGET)
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o pid examples/pid/pid.f90 $(TARGET) $(LDLIBS)

pipe: $(TARGET)
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o pipe examples/pipe/pipe.f90 $(TARGET) $(LDLIBS)

pthread: $(TARGET)
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o pthread examples/pthread/pthread.f90 $(TARGET) $(LDLIBS) -lpthread

regex: $(TARGET)
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o regex examples/regex/regex.f90 $(TARGET) $(LDLIBS)

semaphore: $(TARGET)
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o semaphore examples/semaphore/semaphore.f90 $(TARGET) $(LDLIBS) -lpthread

serial: $(TARGET)
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o serial examples/serial/serial.f90 $(TARGET) $(LDLIBS)

signal: $(TARGET)
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o signal examples/signal/signal.f90 $(TARGET) $(LDLIBS)

socket: $(TARGET)
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o socket examples/socket/socket.f90 $(TARGET) $(LDLIBS)

time: $(TARGET)
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o time examples/time/time.f90 $(TARGET) $(LDLIBS)

uname: $(TARGET)
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o uname examples/uname/uname.f90 $(TARGET) $(LDLIBS)

uptime: $(TARGET)
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o uptime examples/uptime/uptime.f90 $(TARGET) $(LDLIBS)

examples: dirent fifo fork irc key mqueue mutex msg os pid pipe pthread regex \
          semaphore serial signal socket time uname uptime

clean:
	if [ `ls -1 *.mod 2>/dev/null | wc -l` -gt 0 ]; then rm *.mod; fi
	if [ `ls -1 *.o 2>/dev/null | wc -l` -gt 0 ]; then rm *.o; fi
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
	if [ -e time ]; then rm time; fi
	if [ -e uname ]; then rm uname; fi
	if [ -e uptime ]; then rm uptime; fi
