# gentoo-overlay

-------------------------------------

dev-util/codeblocks:

Related issues:
https://bugs.gentoo.org/643494

-------------------------------------

sci-libs/cantera:

http://cantera.org

Cantera is an open-source suite of object-oriented software tools 
for problems involving chemical kinetics, thermodynamics, and/or transport processes. 
The software automates the chemical kinetic, thermodynamic, and transport calculations 
so that the users can efficiently incorporate detailed chemical thermo-kinetics 
and transport models into their calculations.


Currently where is no switching between python3 in ebuild yet, 
so during compilation Cantera use autodetection of current system python3 branch.


TODO: implement some additional USE-flags

full list of configure options of Cantera here: 
http://cantera.org/docs/sphinx/html/compiling/config-options.html

Some of them:

[+] python_package: [ new | full | minimal | none | default ]
[+] python3_package: [ y | n | default ]

[+] matlab_toolbox: [ y | n | default ] 
[+] matlab_path: [ /path/to/matlab_path ] - requires installed MATLAB

[+] f90_interface: [ y | n | default ]
FORTRAN: [ /path/to/FORTRAN ] - set Fortran compiler
FORTRANFLAGS: [ string ] - default "-O3"

coverage: [ yes | no ] - Enable collection of code coverage information with gcov. Available only when compiling with gcc. default: 'no'

blas_lapack_libs: [ string ] - e.g., "lapack,blas" or "lapack,f77blas,cblas,atlas"
blas_lapack_dir: [ /path/to/blas_lapack_dir ] - Directory containing the libraries specified by blas_lapack_libs. Omit it if "/usr/lib"
lapack_names: [ lower | upper ]
lapack_ftn_trailing_underscore: [ yes | no ] - Controls whether the LAPACK functions have a trailing underscore in the Fortran libraries
lapack_ftn_string_len_at_end: [ yes | no ] - Controls whether the LAPACK functions have the string length argument at the end of the argument list in the Fortran libraries

[+] use_pch: [ yes | no ] - Use a precompiled-header to speed up compilation
[+] debug: [ yes | no ]
renamed_shared_libraries: [ yes | no ] - the shared libraries that are created will be renamed to have a _shared extension added to their base name
versioned_shared_library: [ yes | no ] - create a versioned shared library, with symlinks to the more generic library name
layout: [ standard | compact | debian ] - The layout of the directory structure. 'standard' installs files to several subdirectories under 'prefix',
e.g. $prefix/bin, $prefix/include/cantera, $prefix/lib. This layout is best used in conjunction with 'prefix=/usr/local'.
'compact' puts all installed files in the subdirectory defined by 'prefix'. This layout is best with a prefix like '/opt/cantera'
default: 'standard'

... and some others

TODO: try to write patch that disable dependence of google-test at all
TODO: add switch to python3_{4,6}

UNTESTED: Builing of matlab bindings and sphinx_docs
