# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6,7}} )

inherit eutils python-r1 scons-utils toolchain-funcs

DESCRIPTION="Object-oriented tool suite for chemical kinetics, thermodynamics, and transport"
HOMEPAGE="http://www.cantera.org"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/Cantera/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

IUSE="+cti debug doxygen_docs fortran -matlab pch python -sphinx_docs test"

## USE-flags INFO: "matlab" requires MATLAB to be installed preliminarily
## so this USE-flag is disabled by default.
## Installation with this USE-flag is untested.

## Python2 is required by '<scons-3.0' to work.
## Python3 automatic detection is used by cantera before compilling
## if python3_package isn't set no "n".

REQUIRED_USE="
	python? ( cti ${PYTHON_REQUIRED_USE} )
	python_targets_python3_4? ( !python_targets_python3_5 !python_targets_python3_6 !python_targets_python3_7 )
	python_targets_python3_5? ( !python_targets_python3_4 !python_targets_python3_6 !python_targets_python3_7 )
	python_targets_python3_6? ( !python_targets_python3_4 !python_targets_python3_5 !python_targets_python3_7 )
	python_targets_python3_7? ( !python_targets_python3_4 !python_targets_python3_5 !python_targets_python3_6 )
	"

# SCons >= 3.0 is recomended, but builds with older versions
# doxygen-1.8.14 is recomended
DEPEND="
	dev-cpp/eigen
	dev-libs/boost
	dev-util/scons
	dev-libs/libfmt:0=
	sci-libs/sundials
	fortran? (
		sci-libs/sundials[fortran]
		sys-devel/gcc[fortran]
	)
	python? (
		dev-python/3to2
		dev-python/cython
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pip
	)
	doxygen_docs? (
		app-doc/doxygen[dot]
	)
	sphinx_docs? (
		dev-python/pygments
		dev-python/pyparsing
		dev-python/sphinx
		dev-python/sphinxcontrib-doxylink
		dev-python/sphinxcontrib-matlabdomain
		dev-python/sphinxcontrib-katex
	)
	test? (
		>=dev-cpp/gtest-1.8.0
	)
"

PATCHES=(
	"${FILESDIR}/${PN}_fix_sphinx_docs_installation.patch"
	"${FILESDIR}/${PN}_${PV}_change_sphinx_template.patch"
	"${FILESDIR}/${PN}_${PV}_disable_debug_and_optimization.patch"
	)

## Full list of configuration options of Cantera is presented here:
## http://cantera.org/docs/sphinx/html/compiling/config-options.html

scons_vars=()
set_scons_vars() {
	scons_vars=(
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		cc_flags="${CXXFLAGS}"
		cxx_flags="-std=c++11"
		debug=$(usex debug)
		use_pch=$(usex pch)
## In some cases other order can break the detection of right location of Boost: ##
		system_fmt="y"
		system_sundials="y"
		system_eigen="y"
		extra_inc_dirs="/usr/include/eigen3"
	)
	use test || scons_vars+=( googletest="none" )
}

scons_targets=()
set_scons_targets() {
	scons_targets=(
		prefix="/usr"
		stage_dir="${D%/}"
		f90_interface=$(usex fortran y n)
	)

	if use python ; then
		use python_targets_python2_7 && scons_targets+=( python2_package="full" )
		use python_targets_python3_4 && scons_targets+=( python3_package="full" python3_cmd="python3.4" )
		use python_targets_python3_5 && scons_targets+=( python3_package="full" python3_cmd="python3.5" )
		use python_targets_python3_6 && scons_targets+=( python3_package="full" python3_cmd="python3.6" )
		use python_targets_python3_7 && scons_targets+=( python3_package="full" python3_cmd="python3.7" )
	else
		if use cti ; then
			use python_targets_python2_7 && scons_targets+=( python2_package="minimal" )
			use python_targets_python3_4 && scons_targets+=( python3_package="minimal" python3_cmd="python3.4" )
			use python_targets_python3_5 && scons_targets+=( python3_package="minimal" python3_cmd="python3.5" )
			use python_targets_python3_6 && scons_targets+=( python3_package="minimal" python3_cmd="python3.6" )
			use python_targets_python3_7 && scons_targets+=( python3_package="minimal" python3_cmd="python3.7" )
		fi
	fi

	use python_targets_python2_7 || scons_targets+=( python2_package="none" )
	use python_targets_python3_4 || use python_targets_python3_5 || \
	use python_targets_python3_6 || use python_targets_python3_7 || \
					scons_targets+=( python3_package="none" )

	use matlab && scons_targets+=( matlab_toolbox="y" )
	if use matlab; then
		MATLAB_DIR="/opt/MATLAB"
		if [ -d ${MATLAB_DIR} ]; then
			MATL_PATH="${MATLAB_DIR}/$(ls ${MATLAB_DIR})"
			scons_targets+=( matlab_path=${MATL_PATH} )
		else
			eerror "MATLAB must be installed in /opt/MATLAB directory to build Matlab bindings"
			die
		fi
	fi
}

src_compile() {
	set_scons_targets
	set_scons_vars
	escons build "${scons_vars[@]}" "${scons_targets[@]}"
	## Fix sphinx docs compilation warnings caused by of start sphinx_docs build
	## before compiling all python modules that results in the absence
	## of some sections of 'Python Module Documentation'.
	use doxygen_docs && escons doxygen doxygen_docs='y'
	use sphinx_docs && escons sphinx sphinx_docs='y'
}

src_test() {
	use test && escons test
}

src_install() {
	escons install
	if use doxygen_docs ; then
		make_desktop_entry "/usr/bin/xdg-open /usr/share/cantera/doc/doxygen/html/index.html" "Cantera Doxygen Documentation" "text-html" "Development"
	fi
	if use sphinx_docs ; then
		make_desktop_entry "/usr/bin/xdg-open /usr/share/cantera/doc/sphinx/html/index.html" "Cantera Sphinx Documentation" "text-html" "Development"
	fi
}

#pkg_preinst() {
	## Rebuild bytecode .pyc files with relative paths instead of scons-'prefix' "${D}/usr" absolute paths.
	## Currently for python 2.7 and 3.5. This action seems is not nessessary. So temporary commented here.
	#pushd ${D%/}/usr/lib64/python2.7
	#	python2 -m compileall .
	#popd
	#pushd ${D%/}/usr/lib64/python3.5
	#	python3.5 -m compileall .
	#popd
#}

pkg_postinst() {
	if use cti && ! use python; then
		elog "Cantera was build without 'python' use-flag therefore the CTI tool 'ck2cti'"
		elog "will convert Chemkin files to Cantera format without verification of kinetic mechanism."
	fi
	if ! use fortran ; then
		elog "C++ samples are installed to '/usr/share/cantera/samples/' directory."
	else
		elog "C++ and Fortran samples are installed to '/usr/share/cantera/samples/' directory."
	fi
	if use python ; then
		elog "Python examples are installed to '/usr/lib64/python{2.7,3.x}/site-packages/cantera/examples' directories."
	fi
}
