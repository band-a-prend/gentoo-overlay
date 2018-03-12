# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit eutils python-r1 scons-utils

DESCRIPTION="Object-oriented tool suite for chemical kinetics, thermodynamics, and transport"
HOMEPAGE="http://www.cantera.org"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/Cantera/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/google/googletest/archive/release-1.7.0.tar.gz -> googletest-1.7.0.tar.gz"

IUSE="debug doxygen_docs fmt4 fortran -matlab pch python samples -sphinx_docs test"

# USE INFO: "matlab" and "sphinx_docs" require MATLAB installed and matlabdomain 
# (install it with: pip install sphinxcontrib-matlabdomain)
# This package isn't in portage: dev-python/sphinxcontrib-matlabdomain
# and is required to build Sphinx documentation. So both of this USE-flags is disabled by default.

# Python3 automatic detection is used by cantera before compilling
# Python2 is required by scons to work
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	^^ ( python_targets_python3_4 python_targets_python3_5 python_targets_python3_6 )"

DEPEND="
	dev-cpp/eigen
	dev-libs/boost
	dev-python/cython
	dev-python/numpy
	dev-util/scons
	fmt4? (
		>=dev-libs/libfmt-4.0.0
	)
	!fmt4? (
		<=dev-libs/libfmt-3.0.2
	)
	sci-libs/sundials
	fortran? (
		sci-libs/sundials[fortran]
		sys-devel/gcc[fortran]
	)
	python? (
		dev-python/3to2
		dev-python/cython
		dev-python/pip
	)
	doxygen_docs? (
		app-doc/doxygen
	)
	sphinx_docs? (
		dev-python/pygments
		dev-python/pyparsing
		dev-python/sphinx
		dev-python/sphinxcontrib-doxylink
	)
"

src_prepare() {
	use fmt4 && epatch "${FILESDIR}/${PN}_fmt4.patch"
	mv "${WORKDIR}"/googletest-release-1.7.0/* "${WORKDIR}/${P}"/ext/googletest/
	eapply_user
}

## python_package=minimal requires numpy to run ck2cti.py converter
## otherwise change then change "python_package" to "none" instead of "minimal"
## and move dev-python/numpy and dev-python/cython dependency to python? USE-conditional
## as they both are needed to build python part of cantera package

scons_targets=()
set_scons_targets() {
	scons_targets=(
		doxygen_docs=$(usex doxygen_docs)
		sphinx_docs=$(usex sphinx_docs)
		f90_interface=$(usex fortran y n)
	)
	use python && scons_targets+=( python_package="full" )
	use python && scons_targets+=( python3_package="$(usex python_targets_python3_5 y n)" )
	use python || scons_targets+=( python_package="minimal" )
	use python_targets_python2_7 || scons_targets+=( python_package="none" )
	use matlab && scons_targets+=( matlab_toolbox="y" )
	if use matlab; then
		MATLAB_DIR="/opt/MATLAB"
		if [ -d ${MATLAB_DIR} ]; then
			MATL_PATH="${MATLAB_DIR}/$(ls ${MATLAB_DIR})"
			scons_targets+=( matlab_path=${MATL_PATH} )
		else
			eerror "MATLAB must be installed in /opt/MATLAB directory to build Matlab bindigs"
			die
		fi
	fi
}

scons_vars=()
set_scons_vars() {
	scons_vars=(
## temporary commented ##
#		cc="$(tc-getCC)"
#		cxx="$(tc-getCXX)"
#		ccflags="${CXXFLAGS}"
#		linkflags="${LDFLAGS}"

		debug=$(usex debug)
		use_pch=$(usex pch)
## in some cases other order breaks founding of Boost ##
		system_fmt="y"
		system_sundials="y"
		system_eigen="y"
		extra_inc_dirs="/usr/include/eigen3"
	)
}

src_compile() {
	set_scons_targets
	set_scons_vars
	escons build "${scons_vars[@]}" "${scons_targets[@]}"
	use samples && escons samples
}

src_test() {
	cd "${WORKDIR}/${P}" || die "Can't change directory before run test"
	use test && escons test
}

src_install() {
	set_scons_targets
	set_scons_vars
	escons prefix="${D}/usr" install
}

# TODO: implement some additional USE-flags
#
# full list of configure options of Cantera here: 
# http://cantera.org/docs/sphinx/html/compiling/config-options.html
# Some of them:
#
# [+] python_package: [ new | full | minimal | none | default ]
# [+] python3_package: [ y | n | default ]
#
# [+] matlab_toolbox: [ y | n | default ] 
# [+] matlab_path: [ /path/to/matlab_path ] - requires installed MATLAB
#
# [+] f90_interface: [ y | n | default ]
# FORTRAN: [ /path/to/FORTRAN ] - set Fortran compiler
# FORTRANFLAGS: [ string ] - default "-O3"
#
# coverage: [ yes | no ] - Enable collection of code coverage information with gcov. Available only when compiling with gcc. default: 'no'
#
# blas_lapack_libs: [ string ] - e.g., "lapack,blas" or "lapack,f77blas,cblas,atlas"
# blas_lapack_dir: [ /path/to/blas_lapack_dir ] - Directory containing the libraries specified by blas_lapack_libs. Omit it if "/usr/lib"
# lapack_names: [ lower | upper ]
# lapack_ftn_trailing_underscore: [ yes | no ] - Controls whether the LAPACK functions have a trailing underscore in the Fortran libraries
# lapack_ftn_string_len_at_end: [ yes | no ] - Controls whether the LAPACK functions have the string length argument at the end of the argument list in the Fortran libraries
#
# [+] use_pch: [ yes | no ] - Use a precompiled-header to speed up compilation
# [+] debug: [ yes | no ]
# renamed_shared_libraries: [ yes | no ] - the shared libraries that are created will be renamed to have a _shared extension added to their base name
# versioned_shared_library: [ yes | no ] - create a versioned shared library, with symlinks to the more generic library name
# layout: [ standard | compact | debian ] - The layout of the directory structure. 'standard' installs files to several subdirectories under 'prefix',
#	e.g. $prefix/bin, $prefix/include/cantera, $prefix/lib. This layout is best used in conjunction with 'prefix=/usr/local'.
#	'compact' puts all installed files in the subdirectory defined by 'prefix'. This layout is best with a prefix like '/opt/cantera'
#	default: 'standard'
#
# ... and some others
#
# TODO: try to write patch that disable dependence of google-test at all
# TODO: add switch to python3_{4,6}
#
# UNTESTED: Builing of matlab bindings and sphinx_docs
