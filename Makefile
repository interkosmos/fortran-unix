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
#       TARGET      -       Output library name.
#
FFLAGS  = -Wall -std=f2008 -fmax-errors=1 -fcheck=all
CFLAGS  = -Wall -fmax-errors=1
PPFLAGS = -cpp -D__$(OS)__
ARFLAGS = rcs
LDFLAGS = -I$(PREFIX)/include/ -L$(PREFIX)/lib/
TARGET  = libfortran-unix.a

.PHONY: all clean dirent examples fifo fork irc mqueue msg os pipe pthread signal socket time

all: $(TARGET)

# Library
$(TARGET):
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_types.f90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_dirent.f90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_errno.f90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_fcntl.f90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_ipc.f90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_mqueue.f90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_msg.f90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_netdb.f90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_pthread.f90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_signal.f90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_socket.f90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_stat.f90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_stdio.f90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_stdlib.f90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_string.f90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_time.f90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_unistd.f90
	$(FC) $(FFLAGS) $(PPFLAGS) -c src/unix_wait.f90
	$(FC) $(FFLAGS) -c src/unix.f90
	$(CC) $(CFLAGS) -c src/errno.c
	$(AR) $(ARFLAGS) $(TARGET) unix.o unix_dirent.o unix_errno.o unix_fcntl.o \
                               unix_ipc.o unix_mqueue.o unix_msg.o unix_netdb.o \
                               unix_pthread.o unix_signal.o unix_socket.o \
                               unix_stat.o unix_stdio.o unix_stdlib.o \
                               unix_string.o unix_time.o unix_types.o unix_unistd.o \
                               unix_wait.o errno.o

# Examples
dirent: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o dirent examples/dirent/dirent.f90 $(TARGET)

fifo: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o fifo examples/fifo/fifo.f90 $(TARGET)

fork: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o fork examples/fork/fork.f90 $(TARGET)

irc: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o irc examples/irc/irc.f90 $(TARGET)

mqueue: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o mqueue examples/mqueue/mqueue.f90 $(TARGET) -lrt

msg: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o msg examples/msg/msg.f90 $(TARGET)

os: $(TARGET)
	$(FC) $(FFLAGS) $(PPFLAGS) $(LDFLAGS) -o os examples/os/os.f90 $(TARGET)

pthread: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o pthread examples/pthread/pthread.f90 $(TARGET) -lpthread

signal: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o signal examples/signal/signal.f90 $(TARGET)

socket: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o socket examples/socket/socket.f90 $(TARGET)

time: $(TARGET)
	$(FC) $(FFLAGS) $(LDFLAGS) -o time examples/time/time.f90 $(TARGET)

examples: dirent fifo fork irc mqueue msg os pthread signal socket time

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
	if [ -e os ]; then rm os; fi
	if [ -e pipe ]; then rm pipe; fi
	if [ -e pthread ]; then rm pthread; fi
	if [ -e signal ]; then rm signal; fi
	if [ -e socket ]; then rm socket; fi
	if [ -e time ]; then rm time; fi
