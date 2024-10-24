#make -f Makefile

# Set the remove file command for your system used in the clean command
#Rm = del

# Set the required Fortran compiler and associated flags
#F90 = nagfor
#F90FLAGS = -g -g90 -gline -nan -C=all -C=undefined -C=dangling -maxcontin=999 
#F90LINKFLAGS = -g -g90 -gline -nan -C=all -C=undefined -C=dangling -maxcontin=999 
#O = o

#F90 = ifort
#F90FLAGS =  -O3 /WARN:ALL /WARN:DECLARATIONS /STAND:F90 /TRACEBACK /CU
#F90LINKFLAGS = -O3  /WARN:ALL /WARN:DECLARATIONS /STAND:F90 /TRACEBACK /CU
#O = obj

F90 = gfortran
F90FLAGS = -O3 -g -ffast-math
F90LINKFLAGS = -O3 -g -ffast-math
O = o

# Template for .f90 -> .o
%.$O: %.f90
	$(F90) $(F90FLAGS) -o $@ -c $<

# Template for linking .o -> executable
%: %.$O
	$(F90) $(F90LINKFLAGS) -o $@ $^

# Object files needed for Voigt_driver
OBJS = set_rk.$O Voigt_mod_rk.$O Faddeyeva_v3_mod_rk.$O
Voigt_driver: $(OBJS) Voigt_driver.$O
Voigt_driver.$O: $(OBJS)

# Module dependencies
Voigt_mod_rk.$O: set_rk.$O
Faddeyeva_v3_mod_rk.$O: set_rk.$O
set_rk.$O:

# Clean command to remove generated files
.PHONY: clean
clean:
	del /f *.o *.mod *.exe
	