FC=ifort
PFUNIT = /opt/funit/pfunit-serial
F90_VENDOR = Intel

# module under testing
MODULE=naive

MODULES=naive dot cache dotcache builtin

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

$(ODIR)/main.o:  $(SDIR)/main.F90  $(ODIR)/$(MODULE).o
	$(FC) $^ -o $@ $(FFLAGS)

$(ODIR)/%.o: $(SDIR)/%.F90
	$(FC) -c $< -o $@ $(FFLAGS)

$(TODIR)/%.o: $(TDIR)/%.F90
	$(FC) -c $< -o $@ $(FFLAGS)

$(TODIR)/%.F90: $(TDIR)/%.pf
	$(PFUNIT)/bin/pFUnitParser.py $< $@

t:
	$(F90) -o $@_$(MODULE) -I$(PFUNIT)/mod -I$(PFUNIT)/include \
				$(PFUNIT)/include/driver.F90 \
				$(OBJS) $(TOBJS) $(FLAGS) $(FFLAGS) $(LIBS)

t_%: $(OBJS) $(TOBJS)
	make -B t MODULE=$*

test: t_$(MODULE)
	./t_$(MODULE)

testall: $(addprefix t_,$(MODULES))
	for i in $(MODULES); do \
		echo -e "\033[0;36m\n\nTesting module $$i\033[0;m"; \
		./t_$$i; \
	done

measure:
	for i in $(MODULES); do \
		make main -B MODULE=$$i; \
		echo -e "\033[0;36m\n\nMeasuring performance of $$i\033[0;m"; \
		./out/main.o 5000 100 > times.$$i.csv; \
		cat times.$$i.csv >> times.csv; \
	done

		# s./out/main.o 2000 5 > times.$$i.csv; \

clean:
	$(RM) $(ODIR)/* $(TODIR)/* */.mod

