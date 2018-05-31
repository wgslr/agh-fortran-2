FC=ifort
PFUNIT = /opt/funit/pfunit-serial
F90_VENDOR = Intel

include $(PFUNIT)/include/base.mk

FFLAGS += -std08 -warn all -pedantic -I$(PFUNIT)/mod
FFLAGS=-funroll-all-loops -WB -std08 -module . -implicitnone -fpp -warn all -pedantic -fpp -Iout/ -g -I./
LIBS = $(PFUNIT)/lib/libpfunit$(LIB_EXT)

PFS = $(wildcard src/*.pf)
FS = $(wildcard src/*.F90)
OBJS = $(FS:src/%.F90=out/%.o)

.PHONY: all
.DEFAULT: all

all: ${OBJS}

out/%.o: src/%.F90
	$(FC) $< -o $@ $(FFLAGS)
