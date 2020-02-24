FC = gfortran
SRCDIR=$(shell pwd)/src
.PHONY: clean

main.exe: $(SRCDIR)/checktraj.mod $(SRCDIR)/freengfunc.mod $(SRCDIR)/checktraj.o $(SRCDIR)/freengfunc.o $(SRCDIR)/main.o
	$(FC) $(SRCDIR)/checktraj.o $(SRCDIR)/freengfunc.o $(SRCDIR)/main.o -o $(SRCDIR)/main.exe
	ln -s $(SRCDIR)/main.exe $(shell pwd)/2dpmf
	rm $(shell pwd)/*.mod

$(SRCDIR)/checktraj.mod : $(SRCDIR)/checktraj.f90
	$(FC) -c $(SRCDIR)/checktraj.f90 -o $(SRCDIR)/checktraj.mod
$(SRCDIR)/freengfunc.mod : $(SRCDIR)/freengfunc.f90
	$(FC) -c $(SRCDIR)/freengfunc.f90 -o $(SRCDIR)/freengfunc.mod
$(SRCDIR)/main.o : $(SRCDIR)/main.f90
	$(FC) -c $(SRCDIR)/main.f90 -o $(SRCDIR)/main.o
$(SRCDIR)/checktraj.o : $(SRCDIR)/checktraj.f90
	$(FC) -c $(SRCDIR)/checktraj.f90 -o $(SRCDIR)/checktraj.o
$(SRCDIR)/freengfunc.o : $(SRCDIR)/freengfunc.f90
	$(FC) -c $(SRCDIR)/freengfunc.f90 -o $(SRCDIR)/freengfunc.o
clean:
	rm -f 2dpmf *mod
	rm -f $(SRCDIR)/*o $(SRCDIR)/*mod $(SRCDIR)/*exe
