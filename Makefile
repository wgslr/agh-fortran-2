FC=ifort
PFUNIT = /opt/funit/pfunit-serial
F90_VENDOR = Intel

SDIR=src
ODIR=out
TDIR=.

include $(PFUNIT)/include/base.mk

FFLAGS=-funroll-all-loops -WB -std08 -implicitnone -fpp -warn all -pedantic
FFLAGS += -g
FFLAGS += -I$(PFUNIT)/mod -I$(PFUNIT)/include 
LIBS = $(PFUNIT)/lib/libpfunit$(LIB_EXT)

FS = $(wildcard src/*.F90)
PFS = $(wildcard test/*.pf)
OBJS = $(FS:src/%.F90=out/%.o)
POBJS = $(PFS:test/%.pf=out/%.o)
# TOBJS = $(PFS:src/%.F90=out/%.o)

.PHONY: all

all: $(ODIR)/main.o

$(ODIR)/main.o: $(SDIR)/*.F90
	$(FC) $^ -o $@ $(FFLAGS)

$(ODIR)/%.o: $(TDIR)/*.F90
	$(FC) -c $^ -o $@ $(FFLAGS)

$(TDIR)/%.F90: $(TDIR)/%.pf
	$(PFUNIT)/bin/pFUnitParser.py $< $@

# test: testSuites.inc out/mmTest.o
# 	echo $^

tests.x: testSuites.inc $(POBJS)
	$(F90) -o $@ -I$(PFUNIT)/mod -I$(PFUNIT)/include \
				$(PFUNIT)/include/driver.F90 \
				$(POBJS) $(FLAGS) $(LIBS)