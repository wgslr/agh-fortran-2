FC=ifort
PFUNIT = /opt/funit/pfunit-serial
F90_VENDOR = Intel

# module under testing
MODULE=naive

SDIR=src
ODIR=out
TDIR=test
TODIR=test/out

include $(PFUNIT)/include/base.mk

FFLAGS += -funroll-all-loops -WB -std08 -implicitnone -fpp -warn all -pedantic -module $(ODIR) -D_MODULE=$(MODULE)
FFLAGS += -g 
FFLAGS += -I$(PFUNIT)/mod -I$(PFUNIT)/include 
LIBS = $(PFUNIT)/lib/libpfunit$(LIB_EXT)

FS = $(wildcard src/*.F90)
FS =$(SDIR)/naive.F90
PFS = $(wildcard test/*.pf)
OBJS = $(FS:$(SDIR)/%.F90=$(ODIR)/%.o)
POBJS = $(PFS:$(TDIR)/%.pf=$(TODIR)/%.o)
# TOBJS = $(PFS:src/%.F90=out/%.o)

.PHONY: all objs

all: $(ODIR)/main.o
objs: $(OBJS)
	echo $^

$(ODIR)/main.o: $(SDIR)/*.F90
	$(FC) $^ -o $@ $(FFLAGS)

$(ODIR)/%.o: $(SDIR)/%.F90
	$(FC) -c $< -o $@ $(FFLAGS)

$(TODIR)/%.o: $(TDIR)/%.F90
	$(FC) -c $< -o $@ $(FFLAGS)

$(TODIR)/%.F90: $(TDIR)/%.pf
	$(PFUNIT)/bin/pFUnitParser.py $< $@

# test: testSuites.inc out/mmTest.o
# 	echo $^

t: testSuites.inc $(POBJS) $(OBJS)
	$(F90) -o $@ -I$(PFUNIT)/mod -I$(PFUNIT)/include \
				$(PFUNIT)/include/driver.F90 \
				$(OBJS) $(POBJS) $(FLAGS) $(FFLAGS) $(LIBS)
test: t
	./t

clean:
	$(RM) $(ODIR)/* $(TODIR)/*
