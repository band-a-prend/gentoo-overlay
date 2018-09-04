## gentoo-overlay

***

### **dev-util/codeblocks**:  
*(version bump ebuild with patch to build FortranProject plugin via autotools)*

**dev-util/codeblocks-17.12**  
**dev-util/codeblocks-17.12-r300**  
Related issues: [#643494](https://bugs.gentoo.org/643494)  
Related pull request: [#7324](https://github.com/gentoo/gentoo/pull/7324)  
*(merged to portage tree after editing the commit with bug references and some changes)*


**dev-util/codeblocks-17.12-r1**  
**dev-util/codeblocks-17.12-r301**  
**dev-util/codeblocks-9999**  
Related issues: [#383037](https://bugs.gentoo.org/383037), [#656758](https://bugs.gentoo.org/656758), [issue](http://forums.codeblocks.org/index.php/topic,22641.0.html) from C::B user forum  
Related pull request: [#9219](https://github.com/gentoo/gentoo/pull/9219)  
*(merged to portage tree after editing the commit with bug references)*

***

### **sci-libs/cantera**:  
Homepage and documentation: http://cantera.org

> Cantera is an open-source suite of object-oriented software tools for problems involving chemical kinetics,  
> thermodynamics, and/or transport processes. The software automates the chemical kinetic, thermodynamic,  
> and transport calculations so that the users can efficiently incorporate detailed chemical thermo-kinetics  
> and transport models into their calculations.


**EBUILDS**:  
*(ebuilds is under development)*  
**sci-libs/cantera-2.3.0**  
**sci-libs/cantera-2.4.0**  

**ADDITIONAL EBUILDS**:  
*(to build sphinx documentation)*  
**dev-python/sphinxcontrib-matlabdomain-0.3.3**  
**dev-python/sphinxcontrib-katex-0.2.0**


**TODO**:
* Maybe it's worth to replace USE-flags `doxygen_docs` and  `sphinx_docs` to compile documentations from source by `doc` that will install already compiled sphinx and doxygen documentation from additional official tarball. It's possible only for Cantera-2.3.0 as for current stable version 2.4.0 such docs contains only Python and Matlab interface API docs and CTI input documentation. The reason also is that `sphinx_docs` depend on packages that are absent in portage tree and sphinx documentation contains referenses to doxygen documentation so it's rationally to provide them together.


**UNTESTED**:  
* Building with `USE=matlab`


**USE-flags**:  

[Full list of Cantera-2.4.0 configuration options](https://cantera.org/compiling/config-options.html)  

Some of them ([+] - marks that are used within ebuild):

[+] `python_package`: [ new | full | minimal | none | default ]  
[+] `python2_package`: [ y | n | full | minimal | none | default ] (since v2.4.0)  
[+] `python3_package`: [ y | n | default ]  
or  
[+] `python3_package`: [ y | n | full | minimal | none | default ] (since v2.4.0)  

[+] `googletest`: [ 'default' | 'system' | 'submodule' | 'none' ] (since v2.4.0) - Select whether to use `gtest/gmock` from system installation (`system`), from a Git submodule (`submodule`), to decide automatically (`default`) or don’t look for gtest/gmock (`none`).

[+] `matlab_toolbox`: [ y | n | default ]  
[+] `matlab_path`: [ /path/to/matlab_path ] - requires installed MATLAB

[+] `use_pch`: [ yes | no ] - Use a precompiled-header to speed up compilation  
[+] `debug`: [ yes | no ]  

[+] `f90_interface`: [ y | n | default ]  
`FORTRAN`: [ /path/to/FORTRAN ] - set Fortran compiler 
`FORTRANFLAGS`: [ string ] - default "-O3"

`coverage`: [ yes | no ] - Enable collection of code coverage information with gcov. Available only when compiling with gcc. default: 'no'

`blas_lapack_libs`: [ string ] - e.g., "lapack,blas" or "lapack,f77blas,cblas,atlas" to use them instead of Eigen library  
`blas_lapack_dir`: [ /path/to/blas_lapack_dir ] - Directory containing the libraries specified by blas_lapack_libs. Omit it if "/usr/lib"  
`lapack_names`: [ lower | upper ]  
`lapack_ftn_trailing_underscore`: [ yes | no ] - Controls whether the LAPACK functions have a trailing underscore in the Fortran libraries  
`lapack_ftn_string_len_at_end`: [ yes | no ] - Controls whether the LAPACK functions have the string length argument at the end of the argument list in the Fortran libraries

`renamed_shared_libraries`: [ yes | no ] - the shared libraries that are created will be renamed to have a _shared extension added to their base name  
`versioned_shared_library`: [ yes | no ] - create a versioned shared library, with symlinks to the more generic library name  
`layout`: [ standard | compact | debian ] - The layout of the directory structure. 'standard' installs files to several subdirectories under 'prefix', e.g. $prefix/bin, $prefix/include/cantera, $prefix/lib. This layout is best used in conjunction with 'prefix=/usr/local'. 'compact' puts all installed files in the subdirectory defined by 'prefix'. This layout is best with a prefix like '/opt/cantera'  
default: 'standard'

... and many others.


