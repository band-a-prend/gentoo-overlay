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

## USE-flags INFO: 
## "matlab" and "sphinx_docs" require MATLAB and matlabdomain package installed
## (install it with: pip install sphinxcontrib-matlabdomain).
## Last package isn't in portage too: dev-python/sphinxcontrib-matlabdomain
## and is required to build Sphinx documentation. So both of this USE-flags is disabled now by default.

## Python2 is required by scons to work.
## Python3 automatic detection is used by cantera before compilling
## if python3_package is not set no "n".

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

## Full list of configuration options of Cantera is presented here: 
## http://cantera.org/docs/sphinx/html/compiling/config-options.html

## 'python_package=minimal' has ck2cti.py to be installed. 
## This xonverter utility requeres numpy and cython to run.
## If "python_package" will be changed to "none" instead of "minimal" 
## then dev-python/numpy and dev-python/cython dependency could be moved 
## to "python?" USE-conditional statement as they both are requeried 
## to build Python part of Cantera package.

scons_vars=()
set_scons_vars() {
	scons_vars=(
## temporary commented ##
#		cc="$(tc-getCC)"
#		cxx="$(tc-getCXX)"
#		ccflags="${CXXFLAGS}"
#		linkflags="${LDFLAGS}"

		cxx_flags="-std=c++11"
		debug=$(usex debug)
		use_pch=$(usex pch)
## in some cases other order could break the right location of Boost ##
		system_fmt="y"
		system_sundials="y"
		system_eigen="y"
		extra_inc_dirs="/usr/include/eigen3"
	)
}

scons_targets=()
set_scons_targets() {
	scons_targets=(
		prefix="/usr"
		stage_dir="${D%/}"
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
	escons install
}

#pkg_preinst() {
	## Rebuild bytecode .pyc files with relative paths instead of scons-'prefix' "${D}/usr" absolute paths
	## Currently for python 2.7 and 3.5. This action seems is not nessessary. So temporary commented
	#pushd ${D%/}/usr/lib64/python2.7
	#	python2 -m compileall .
	#popd
	#pushd ${D%/}/usr/lib64/python3.5
	#	python3.5 -m compileall .
	#popd
#}
