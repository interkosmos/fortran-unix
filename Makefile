.POSIX:
.SUFFIXES:

# Parameters:
#
#       OS          -       Set to either `FreeBSD` or `linux`:
#       PREFIX      -       Change to `/usr` on Linux.
#       FC          -       Fortran compiler.
#       CC          -       C compiler.
#       AR          -       Archiver.
#
OS      = FreeBSD
PREFIX  = /usr/local
FC      = gfortran
CC      = gcc
AR      = ar

# Flags:
#
#       FFLAGS      -       Fortran compiler flags.
#       CFLAGS      -       C compiler flags.
#       PPFLAGS     -       Pre-processor flags. Change to `-fpp` for Intel IFORT.
#       ARFLAGS     -       Archiver flags.
#       LDFLAGS     -       Linker flags.
#       LDLIBS      -       Linker libraries.
#       TARGET      -       Output library name.
#
FFLAGS  = -Wall -std=f2008 -fmax-errors=1 -fcheck=all
CFLAGS  = -Wall -fmax-errors=1
PPFLAGS = -cpp -D__$(OS)__
ARFLAGS = rcs
LDFLAGS = -I$(PREFIX)/include/ -L$(PREFIX)/lib/
LDLIBS  =
TARGET  = libfortran-unix.a

.PHONY: all clean dirent examples fifo fork irc mqueue msg mutex os pipe \
        pthread regex serial signal socket time

all: $(TARGET)

# Library
$(TARGET):
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_types.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_dirent.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_errno.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_fcntl.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_ipc.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_mqueue.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_msg.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_netdb.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_pthread.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_regex.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_signal.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_socket.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_stat.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_stdio.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_stdlib.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_string.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_termios.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_time.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_unistd.F90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_wait.F90
	$(FC) $(FFLAGS) -c src/unix.F90
	$(CC) $(CFLAGS) -c src/errno.c
	$(AR) $(ARFLAGS) $(TARGET) unix.o unix_dirent.o unix_errno.o unix_fcntl.o \
                               unix_ipc.o unix_mqueue.o unix_msg.o unix_netdb.o \
                               unix_pthread.o unix_regex.o unix_signal.o unix_socket.o \
                               unix_stat.o unix_stdio.o unix_stdlib.o \
                               unix_string.o unix_termios.o unix_time.o unix_types.o \
                               unix_unistd.o unix_wait.o errno.o

# Examples
dirent: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o dirent examples/dirent/dirent.f90 $(TARGET) $(LDLIBS)

fifo: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o fifo examples/fifo/fifo.f90 $(TARGET) $(LDLIBS)

fork: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o fork examples/fork/fork.f90 $(TARGET) $(LDLIBS)

irc: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o irc examples/irc/irc.f90 $(TARGET) $(LDLIBS)

mqueue: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o mqueue examples/mqueue/mqueue.f90 $(TARGET) $(LDLIBS) -lrt

msg: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o msg examples/msg/msg.f90 $(TARGET) $(LDLIBS)

mutex: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o mutex examples/mutex/mutex.f90 $(TARGET) $(LDLIBS) -lpthread

os: $(TARGET)
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o os examples/os/os.F90 $(TARGET) $(LDLIBS)

pthread: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o pthread examples/pthread/pthread.f90 $(TARGET) $(LDLIBS) -lpthread

regex: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o regex examples/regex/regex.f90 $(TARGET) $(LDLIBS)

serial: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o serial examples/serial/serial.f90 $(TARGET) $(LDLIBS)

signal: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o signal examples/signal/signal.f90 $(TARGET) $(LDLIBS)

socket: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o socket examples/socket/socket.f90 $(TARGET) $(LDLIBS)

time: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o time examples/time/time.f90 $(TARGET) $(LDLIBS)

examples: dirent fifo fork irc mqueue mutex msg os pthread regex serial signal socket time

clean:
	if [ `ls -1 *.mod 2>/dev/null | wc -l` -gt 0 ]; then rm *.mod; fi
	if [ `ls -1 *.o 2>/dev/null | wc -l` -gt 0 ]; then rm *.o; fi
	if [ -e $(TARGET) ]; then rm $(TARGET); fi
	if [ -e dirent ]; then rm dirent; fi
	if [ -e fifo ]; then rm fifo; fi
	if [ -e fork ]; then rm fork; fi
	if [ -e irc ]; then rm irc; fi
	if [ -e mqueue ]; then rm mqueue; fi
	if [ -e msg ]; then rm msg; fi
	if [ -e mutex ]; then rm mutex; fi
	if [ -e os ]; then rm os; fi
	if [ -e pipe ]; then rm pipe; fi
	if [ -e pthread ]; then rm pthread; fi
	if [ -e regex ]; then rm regex; fi
	if [ -e serial ]; then rm serial; fi
	if [ -e signal ]; then rm signal; fi
	if [ -e socket ]; then rm socket; fi
	if [ -e time ]; then rm time; fi
