# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6,7}} )

inherit desktop python-r1 scons-utils toolchain-funcs

DESCRIPTION="Object-oriented tool suite for chemical kinetics, thermodynamics, and transport"
HOMEPAGE="http://www.cantera.org"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
SRC_URI="https://github.com/Cantera/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

IUSE="+cpp +cti fortran pch python static-libs test"

## Python2 is required by '<scons-3.0' to work.
## Python3 automatic detection is used by cantera before compilling
## if python3_package isn't set no "n".

REQUIRED_USE="
	|| ( cpp python )
	cti? ( ${PYTHON_REQUIRED_USE} )
	fortran? ( cpp )
	python? ( cti )
	static-libs? ( cpp )
	?? ( python_targets_python3_4 python_targets_python3_5 python_targets_python3_6 python_targets_python3_7 )
	"

RDEPEND="
	python? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

# SCons >= 3.0 is recomended, but builds with older versions
DEPEND="
	${RDEPEND}
	dev-cpp/eigen
	dev-libs/boost
	dev-libs/libfmt:0=
	dev-util/scons
	sci-libs/sundials
	fortran? (
		sci-libs/sundials[fortran]
		sys-devel/gcc[fortran]
	)
	python? (
		dev-python/3to2
		dev-python/cython[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-cpp/gtest-1.8.0
	)
"

PATCHES=( "${FILESDIR}/${PN}_${PV}_disable_debug_and_optimization.patch" )

## Full list of configuration options of Cantera is presented here:
## http://cantera.org/docs/sphinx/html/compiling/config-options.html

scons_vars=()
set_scons_vars() {
	scons_vars=(
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		cc_flags="${CXXFLAGS}"
		cxx_flags="-std=c++11"
		debug="no"
		FORTRANFLAGS="${CXXFLAGS}"
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

	if use cti ; then
		python_setup
		local scons_python=$(usex python full minimal)
		use python_targets_python2_7 && scons_targets+=( python2_package="${scons_python}" python2_cmd="python2.7" )
		python_is_python3 && scons_targets+=( python3_package="${scons_python}" python3_cmd="${EPYTHON}" )

		## Force setup of python{2,3}_package="none" if appropriate python_targets_python{2_7,3_x} isn't active
		## regardless of USE 'cti' or/and 'python' are enabled
		use python_targets_python2_7 || scons_targets+=( python2_package="none" )
		python_is_python3 || scons_targets+=( python3_package="none" )
	else
		scons_targets+=( python2_package="none" python3_package="none" )
	fi
}

src_compile() {
	set_scons_targets
	set_scons_vars
	escons build "${scons_vars[@]}" "${scons_targets[@]}"
}

src_test() {
	escons test
}

src_install() {
	escons install
	local lib_dirname=$(usex amd64 "lib64" "lib")
	if ! use cpp ; then
		einfo "Removing of C++, Fortran libraries, headers and samples"
		rm -r "${D%/}/usr"/{include,${lib_dirname}/{libcantera*,pkgconfig}} || die "Can't remove headers, libraries and pkgconfig files."
		rm -r "${D%/}/usr/share/cantera/samples" || die "Can't remove samples files."
	elif ! use static-libs ; then
		einfo "Removing of C++ static library file."
		rm -r "${D%/}/usr/${lib_dirname}/libcantera.a" || die "Can't remove cantera C++ static library."
	fi
	if ! use cti ; then
		rm -r "${D%/}/usr/share/man" || die "Can't remove man files."
	fi
}

pkg_postinst() {
	if use cti && ! use python ; then
		elog "Cantera was build without 'python' use-flag therefore the CTI tool 'ck2cti'"
		elog "will convert Chemkin files to Cantera format without verification of kinetic mechanism."
	fi
	local post_msg=$(usex fortran "and Fortran " "")
	if use cpp ; then
		elog "C++ ${post_msg}samples are installed to '/usr/share/cantera/samples/' directory."
	fi
	if use python ; then
		elog "Python examples are installed to '/usr/lib64/python{2.7,3.x}/site-packages/cantera/examples' directories."
	fi
}
