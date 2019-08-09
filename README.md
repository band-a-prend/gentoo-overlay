## gentoo-overlay

[ [dev-util/codeblocks](#dev-utilcodeblocks)  ] [  [sci-libs/cantera](#sci-libscantera) ]

***

### dev-util/codeblocks:  

> Code::Blocks is the open source, cross platform, free C, C++ and Fortran IDE.

Code::Blocks homepage: http://www.codeblocks.org  
FortranProject homepage: https://sourceforge.net/projects/fortranproject  


#### Ebuilds:
*(version bump ebuilds with patch to build FortranProject plugin via autotools)* 
* `dev-util/codeblocks-17.12.ebuild`  
* `dev-util/codeblocks-17.12-r300.ebuild`  

Related issue: [#643494](https://bugs.gentoo.org/643494)  
Related pull request: [#7324](https://github.com/gentoo/gentoo/pull/7324)  
*(merged to portage tree on 5 May 2018 after editing the commit with bug references and some changes)*  

* `dev-util/codeblocks-17.12-r1.ebuild`  
* `dev-util/codeblocks-17.12-r301.ebuild`  
* `dev-util/codeblocks-9999.ebuild`  

Related issues: [#383037](https://bugs.gentoo.org/383037), [#656758](https://bugs.gentoo.org/656758), [issue](http://forums.codeblocks.org/index.php/topic,22641.0.html) from C::B user forum  
Related pull request: [#9219](https://github.com/gentoo/gentoo/pull/9219)  
*(merged to portage tree after editing the commit with bug references)*  

#### Local USE flags:
* `contrib` - Build additional contrib components.  
* `fortran` - Build FortranProject plugin which enables to use Code::Blocks IDE for Fortran language.  

***

### sci-libs/cantera:  

> Cantera is an open-source suite of object-oriented software tools for problems involving chemical kinetics, thermodynamics, and/or transport processes.  

Homepage and documentation: http://cantera.org  
GitHub page: https://github.com/Cantera/cantera  


#### Ebuilds:
*(under development, please use package in main Gentoo portage tree)*  
* ~~`sci-libs/cantera-2.4.0.ebuild`~~ (droped due to the removing of old `<=sci-libs/sundials-3.1.2`)  
* `sci-libs/cantera-2.4.0-r1.ebuild`  

Related issues: [#200425](https://bugs.gentoo.org/200425), [#689998](https://bugs.gentoo.org/689998), [#691404](https://bugs.gentoo.org/691404)  
Related pull requests: [#10017](https://github.com/gentoo/gentoo/pull/10017), [#12303](https://github.com/gentoo/gentoo/pull/12303), [#12650](https://github.com/gentoo/gentoo/pull/12650)  
*(initially added to portage tree on 28 Nov 2018)*  

#### Additional ebuilds:  
*(to install doxygen and sphinx documentation)*  
* `app-doc/cantera-docs-2.4.0.ebuild`  


#### Local USE flags:  

* `cti` - Install CTI tools (ck2cti, ctml_writer) for conversion of Chemkin files to Cantera format.  


#### ToDo:  
* Using common system optimization flag in `FORTRANFLAGS` configuration option instead of default `-O3`.  
* Implementation and testing of USE flag to build Cantera package with BLAS/LAPACK implementation instead of Eigen.  


#### Cantera package configuration options:
Full list of configuration options is presented at the appropriate page of [Cantera documentation](https://cantera.org/compiling/config-options.html).  

Some of this options are listed below (checked if is used within ebuild):  

* [x] `python_package`: [ new | full | minimal | none | default ] - If you plan to work in Python, then you need the full Cantera Python package. If, on the other hand, you will only use Cantera from some other language (e.g. MATLAB or Fortran 90/95) and only need Python to process CTI files, then you only need a minimal subset of the package and Cython and NumPy are not necessary. The none option doesn’t install any components of the Python interface. The default behavior is to build the full Python module for whichever version of Python is running SCons if the required prerequisites (NumPy and Cython) are installed. Note: y is a synonym for full and n is a synonym for none. default: 'default'    
* [ ] `python2_package`: [ y | n | full | minimal | none | default ] (since v2.4.0) - Controls whether or not the Python 2 module will be built. By default, the module will be built if the Python 2 interpreter and the required dependencies (NumPy for Python 2 and Cython for the version of Python for which SCons is installed) can be found. default: 'default'  
* [x] `python3_package`: [ y | n | default ]  
or  
* [x] `python3_package`: [ y | n | full | minimal | none | default ] (since v2.4.0) - Controls whether or not the Python 3 module will be built. By default, the module will be built if the Python 3 interpreter and the required dependencies (NumPy for Python 3 and Cython for the version of Python for which SCons is installed) can be found. default: 'default'  
* [x] `python3_cmd`: [ /path/to/python3_cmd ] - The path to the Python 3 interpreter. The default is python3; if this executable cannot be found, this value must be specified to build the Python 3 module. default: 'python3'  

* [x] `googletest`: [ 'default' | 'system' | 'submodule' | 'none' ] (since v2.4.0) - Select whether to use gtest/gmock from system installation (system), from a Git submodule (submodule), to decide automatically (default) or don’t look for gtest/gmock (none).  

* [x] `CXX`: [ string ] - The C++ compiler to use  
* [x] `CC`: [ string ] - The C compiler to use. This is only used to compile CVODE  
* [x] `cc_flags`: [ string ] - Compiler flags passed to both the C and C++ compilers, regardless of optimization level. default: ''  
* [x] `cxx_flags`: [ string ] - Compiler flags passed to the C++ compiler only. Separate multiple options with spaces, e.g., cxx_flags='-g -Wextra -O3 --std=c++11'. default: ''  
* [x] `extra_inc_dirs`: [ string ] - Additional directories to search for header files (colon-separated list). default: ''  

* [x] `prefix`: [ /path/to/prefix ] - Set this to the directory where Cantera should be installed. default: ''  
* [x] `stage_dir`: [ /path/to/stage_dir ] - Directory relative to the Cantera source directory to be used as a staging area for building e.g., a Debian package. If specified, scons install will install files to `stage_dir/prefix/....`. default: ''  

* [x] `use_pch`: [ yes | no ] - Use a precompiled-header to speed up compilation  

* [x] `f90_interface`: [ y | n | default ] - This variable controls whether the Fortran 90/95 interface will be built. If set to default, the builder will look for a compatible Fortran compiler in the PATH environment variable, and compile the Fortran 90 interface if one is found. default: 'default'  

* [x] `FORTRAN`: [ /path/to/FORTRAN ] - set Fortran compiler  
* [x] `FORTRANFLAGS`: [ string ] - default "-O3"  

* [ ] `coverage`: [ yes | no ] - Enable collection of code coverage information with gcov. Available only when compiling with gcc. default: 'no'  

* [ ] `blas_lapack_libs`: [ string ] - e.g., "lapack,blas" or "lapack,f77blas,cblas,atlas" to use them instead of Eigen library  
* [ ] `blas_lapack_dir`: [ /path/to/blas_lapack_dir ] - Directory containing the libraries specified by blas_lapack_libs. Omit it if "/usr/lib"  
* [ ] `lapack_names`: [ lower | upper ] - Set depending on whether the procedure names in the specified libraries are lowercase or uppercase. If you don’t know, run nm on the library file (e.g., nm libblas.a). default: 'lower'  
* [ ] `lapack_ftn_trailing_underscore`: [ yes | no ] - Controls whether the LAPACK functions have a trailing underscore in the Fortran libraries  
* [ ] `lapack_ftn_string_len_at_end`: [ yes | no ] - Controls whether the LAPACK functions have the string length argument at the end of the argument list in the Fortran libraries  

* [x] `renamed_shared_libraries`: [ yes | no ] - the shared libraries that are created will be renamed to have a '_shared' extension added to their base name  
* [ ] `versioned_shared_library`: [ yes | no ] - create a versioned shared library, with symlinks to the more generic library name  

