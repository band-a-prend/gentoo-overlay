### gentoo-overlay

***

**dev-util/codeblocks**:  
*(version bump ebuild with patch to build FortranProject plugin via autotools)*

Related issues: https://bugs.gentoo.org/643494  
Related pull request: https://github.com/gentoo/gentoo/pull/7324

***

**sci-libs/cantera**:  
*(ebuild is under development)*

Homepage and documentation: http://cantera.org

> Cantera is an open-source suite of object-oriented software tools for problems involving chemical kinetics,  
> thermodynamics, and/or transport processes. The software automates the chemical kinetic, thermodynamic,  
> and transport calculations so that the users can efficiently incorporate detailed chemical thermo-kinetics  
> and transport models into their calculations.


Currently there is no switching between python3 in ebuild and autodetection of current system python3 branch is used by cantera build system. Python3 branch could be managed by 'python_cmd' cantera scons configuration option.

**TODO**:
* Implement some additional USE-flags
* Write patch that optionaly disable dependence of 'google-test' (ready?)
* Add switch to build python3_{4,6} bindings
* Replace USE_flags `doxygen_docs` and  `sphinx_docs` to compile documentations from source by `doc` that will install already compiled sphinx and doxygen documentation from additional official tarball. The reason is that `sphinx_docs` depend on package that is absent in portage tree and sphinx documentation contains referenses to doxygen documentation so it's rationally to provide them together.
* Add .desktop entry to sphinx and doxygen documentation index.html files

**UNTESTED**:  
* Builing of `matlab` bindings and `sphinx_docs`


Full list of configure options of Cantera here: 
http://cantera.org/docs/sphinx/html/compiling/config-options.html

Some of them ([+] - marks that are used within ebuild):

[+] `python_package`: [ new | full | minimal | none | default ]  
[+] `python3_package`: [ y | n | default ]

[+] `matlab_toolbox`: [ y | n | default ]  
[+] `matlab_path`: [ /path/to/matlab_path ] - requires installed MATLAB

[+] `f90_interface`: [ y | n | default ]  
`FORTRAN`: [ /path/to/FORTRAN ] - set Fortran compiler 
`FORTRANFLAGS`: [ string ] - default "-O3"

`coverage`: [ yes | no ] - Enable collection of code coverage information with gcov. Available only when compiling with gcc. default: 'no'

`blas_lapack_libs`: [ string ] - e.g., "lapack,blas" or "lapack,f77blas,cblas,atlas"  
`blas_lapack_dir`: [ /path/to/blas_lapack_dir ] - Directory containing the libraries specified by blas_lapack_libs. Omit it if "/usr/lib"  
`lapack_names`: [ lower | upper ]  
`lapack_ftn_trailing_underscore`: [ yes | no ] - Controls whether the LAPACK functions have a trailing underscore in the Fortran libraries  
`lapack_ftn_string_len_at_end`: [ yes | no ] - Controls whether the LAPACK functions have the string length argument at the end of the argument list in the Fortran libraries

[+] `use_pch`: [ yes | no ] - Use a precompiled-header to speed up compilation  
[+] `debug`: [ yes | no ]  
`renamed_shared_libraries`: [ yes | no ] - the shared libraries that are created will be renamed to have a _shared extension added to their base name  
`versioned_shared_library`: [ yes | no ] - create a versioned shared library, with symlinks to the more generic library name  
`layout`: [ standard | compact | debian ] - The layout of the directory structure. 'standard' installs files to several subdirectories under 'prefix', e.g. $prefix/bin, $prefix/include/cantera, $prefix/lib. This layout is best used in conjunction with 'prefix=/usr/local'. 'compact' puts all installed files in the subdirectory defined by 'prefix'. This layout is best with a prefix like '/opt/cantera'  
default: 'standard'

... and some others


