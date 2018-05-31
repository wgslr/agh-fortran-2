FC=ifort
PFUNIT = /opt/funit/pfunit-serial
F90_VENDOR = Intel

# module under testing
MODULE=naive

MODULES=dot naive cache dotcache

SDIR=src
ODIR=out
TDIR=test
TODIR=test/out

include $(PFUNIT)/include/base.mk

FFLAGS = -O2 -funroll-all-loops -std08 -implicitnone -fpp -warn all -pedantic -module $(ODIR) -D_MODULE=$(MODULE)
FFLAGS += -I$(PFUNIT)/mod -I$(PFUNIT)/include 
#FFLAGS += -WB -g -O0
LIBS = $(PFUNIT)/lib/libpfunit$(LIB_EXT)

FS = $(filter-out $(SDIR)/main.F90, $(wildcard $(SDIR)/*.F90))
PFS = $(wildcard test/*.pf)
OBJS = $(FS:$(SDIR)/%.F90=$(ODIR)/%.o)
TOBJS = $(PFS:$(TDIR)/%.pf=$(TODIR)/%.o)

.PHONY: all main

all: $(OBJS)
	echo $(OBJS)

main: $(ODIR)/main.o

$(ODIR)/main.o: $(SDIR)/*.F90
	$(FC) $^ -o $@ $(FFLAGS)

$(ODIR)/%.o: $(SDIR)/%.F90
	$(FC) -c $< -o $@ $(FFLAGS)

$(TODIR)/%.o: $(TDIR)/%.F90
	$(FC) -c $< -o $@ $(FFLAGS)

$(TODIR)/%.F90: $(TDIR)/%.pf
	$(PFUNIT)/bin/pFUnitParser.py $< $@

t_$(MODULE): testSuites.inc $(TOBJS) $(OBJS)
	$(F90) -o $@ -I$(PFUNIT)/mod -I$(PFUNIT)/include \
				$(PFUNIT)/include/driver.F90 \
				$(OBJS) $(TOBJS) $(FLAGS) $(FFLAGS) $(LIBS)

test: t_$(MODULE)
	./t_$(MODULE)

testall: $(OBJS)
	for i in $(MODULES); do make t_$$i MODULE=$$i -B; done
	for i in $(MODULES); do \
		echo -e "\033[0;36m\n\nTesting module $$i\033[0;m"; \
		./t_$$i; \
	done

clean:
	$(RM) $(ODIR)/* $(TODIR)/* */.mod