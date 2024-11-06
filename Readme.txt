Voigt_rk: A Fortran subroutine to calculate the Voigt function (real part of the Faddeyeva function) to accuracy
in the order of 10^-6. 
The subroutine exists in the module Voigt_mod_rk together with the HUMLIK subrourine for the sake
of comparison and efficiency benchmark.
The subroutine Faddeyeva_V3_rk in the module Faddeyeva_v3_mod_rk (accurate up 14 significant digits)
is used as a reference for accuracy check.  

## Related Publication
For more information, check out the paper here: https://doi.org/10.1016/j.jqsrt.2024.109234 

Installation
========
Save all the accompanying files in a single directory with a name that is compatible with your Fortran compiler.

Compilation
=========
1- Using Makefile
Use the provided makefile to compile the package:
make -f makefile

2- Manual Compilation
Alternatively, you can compile the package manually using the terminal. For the gfortran compiler, use:
> gfortran -o3 set_rk.f90 Faddeyeva_v3_mod_rk.f90 Voigt_mod_rk.f90 Voigt_driver.f90  -o Voigt_driver

For the Intel Fortran compiler (ifort), replace gfortran with ifort.

Running the Driver Code
==================
Run the driver code by typing the following in the terminal:
>Voigt_driver
The code will execute automatically and display selfexplanatory results on the screen showing
accuracy check and efficiency comparison .

Selecting Precision
----------------------
To select or change the precision, set the integer "rk" in the set_rk.f90 file to the desired value (sp or dp)

File Descriptions
=============
Makefile
makefile: A script for compiling the package.

Source Files (.f90)
---------------
set_rk.f90                                               : An auxiliary module to select the precision by setting the value of the integer rk.

Voigt_mod_rk.f90                                  : A Fortran module including implementation of the  present algorithm  
                                                                  for calculating the Voigt function together with the HUMLIK subroutine
                                                                
Voigt_driver.f90                                      : An example of a Fortran driver code or main program.



Files used by the reference "Faddeyeva_v3_rk"
---------------------------------------------------- 
Faddeyeva_v3_parameters.f90              : Contains numerical constants and parameters used in calculating the set of Error
                                                                 functions and Dawson integral of a complex variable.

cheb_t_erfcx_parameters_sdq.f90          : Contains Chebyshev subinterval polynomial coefficients used in the present
                                                                  erfcx or scaled complementary error function of a real variable used in the 
                                                                  present Faddeyeva_v3 function (not need for the Voigt_rk function)

cheb_t100_daw_parameters_sdq.f90     : Contains Chebyshev subinterval polynomial coefficients used in the present
                                                                  Daw(x) or Dawson integral of a real variable used in the present Faddeyeva_v3
                                                                  function (not need for the Voigt_rk function)

constants.f90                                           : Contains some constants used in both of Faddeyeva_v3_mod_rk

Faddeyeva_v3_mod_rk.f90                     : A Fortran module including the subroutine Faddeyeva_v3_rk used as
                                                                  a reference for accuracy check

