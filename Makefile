FC=ifort
PFUNIT = /opt/funit/pfunit-serial
F90_VENDOR = Intel

# module under testing
MODULE=naive

MODULES=dot naive

SDIR=src
ODIR=out
TDIR=test
TODIR=test/out

include $(PFUNIT)/include/base.mk

FFLAGS += -funroll-all-loops -WB -std08 -implicitnone -fpp -warn all -pedantic -module $(ODIR) -D_MODULE=$(MODULE)
FFLAGS += -g 
FFLAGS += -I$(PFUNIT)/mod -I$(PFUNIT)/include 
LIBS = $(PFUNIT)/lib/libpfunit$(LIB_EXT)

FS = $(filter-out $(SDIR)/main.F90, $(wildcard $(SDIR)/*.F90))
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

t_$(MODULE): testSuites.inc $(POBJS) $(OBJS)
	$(F90) -o $@ -I$(PFUNIT)/mod -I$(PFUNIT)/include \
				$(PFUNIT)/include/driver.F90 \
				$(OBJS) $(POBJS) $(FLAGS) $(FFLAGS) $(LIBS)

test: t_$(MODULE)
	./t_$(MODULE)

clean:
	$(RM) $(ODIR)/* $(TODIR)/*

testall:
	for i in $(MODULES); do make t_$$i MODULE=$$i -B; done
	for i in $(MODULES); do \
		echo -e "\033[0;36m\n\nTesting module $$i\033[0;m"; \
		./t_$$i; \
	done