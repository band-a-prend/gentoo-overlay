# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

FORTRAN_NEEDED=fortran
FORTRAN_STANDARD=90

inherit desktop python-r1 scons-utils toolchain-funcs fortran-2

DESCRIPTION="Object-oriented tool suite for chemical kinetics, thermodynamics, and transport"
HOMEPAGE="http://www.cantera.org"
SRC_URI="https://github.com/Cantera/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cti +cxx fortran pch python static-libs test"

## Python2 is required by '<scons-3.0' to work.
## Python3 automatic detection is used by cantera before compilling
## if python3_package isn't set no "n".

REQUIRED_USE="
	|| ( cxx python )
	cti? ( ${PYTHON_REQUIRED_USE} )
	fortran? ( cxx )
	python? ( cti )
	static-libs? ( cxx )
	?? ( python_targets_python3_4 python_targets_python3_5 python_targets_python3_6 )
	"

RDEPEND="
	python? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

DEPEND="
	${RDEPEND}
	dev-cpp/eigen
	dev-libs/boost
	dev-libs/libfmt:0/4
	<dev-util/scons-3.0
	sci-libs/sundials
	python? (
		dev-python/3to2
		dev-python/cython[${PYTHON_USEDEP}]
	)
	test? (
		>=dev-cpp/gtest-1.7.0
	)
"

	# Fix compability only with libfmt-4.x as
	# fixing compability with libfmt-5.y requires too many changes
	# and is fixed in Cantera 2.4.0.
PATCHES=(
	"${FILESDIR}/${PN}_${PV}_googletest_option.patch"
	"${FILESDIR}/${PN}_${PV}_fix_fmt4_compability.patch"
	"${FILESDIR}/${PN}_${PV}_fix_functional_error.patch"
	"${FILESDIR}/${PN}_${PV}_disable_debug_and_optimization.patch"
	)

pkg_setup() {
	python_setup
}

src_prepare() {
	default
	# modify SConstruct to comment block of lines and to set "env['libdirname'] = '$(get_libdir)'"
	sed -i "/if any(name.startswith/,/else:/ s/^/#/" "${S}"/SConstruct || die "failed to modify 'SConstruct'"
	sed -i "/env\['libdirname'\] = 'lib'/{s/^[ \t]*//;s/'lib'/'$(get_libdir)'/}" "${S}"/SConstruct || die "failed to modify 'SConstruct' with get_libdir"
}

## Full list of configuration options of Cantera is presented here:
## http://cantera.org/docs/sphinx/html/compiling/config-options.html

src_configure() {
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

	scons_targets=(
		f90_interface=$(usex fortran y n)
	)

	if use cti ; then
		if use python ; then
			use python_targets_python2_7 && scons_targets+=( python_package="full" )
			python_is_python3 && scons_targets+=( python3_package="y" python3_cmd="${EPYTHON}" )
		else
			use python_targets_python2_7 && scons_targets+=( python_package="minimal" python3_package="n" )
		fi
		## Force setup of python{2,3}_package="none" if appropriate python_targets_python{2_7,3_x} isn't active
		## regardless of USE 'cti' or/and 'python' are enabled
		use python_targets_python2_7 || scons_targets+=( python2_package="none" )
		python_is_python3 || scons_targets+=( python3_package="n" )
	else
		scons_targets+=( python_package="none" python3_package="n" )
	fi
}

src_compile() {
	escons build "${scons_vars[@]}" "${scons_targets[@]}"
}

src_test() {
	escons test
}

src_install() {
	escons install stage_dir="${D%/}" prefix="/usr"
	if ! use cxx ; then
		einfo "Removing of C++, Fortran libraries, headers and samples"
		rm -r "${D%/}/usr"/{include,$(get_libdir)/{libcantera*,pkgconfig}} || die "Can't remove headers, libraries and pkgconfig files."
		rm -r "${D%/}/usr/share/cantera/samples" || die "Can't remove samples files."
	elif ! use static-libs ; then
		rm -r "${D%/}/usr/$(get_libdir)/libcantera.a" || die "Can't remove cantera C++ static library."
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
	if use cxx ; then
		elog "C++ ${post_msg}samples are installed to '/usr/share/cantera/samples/' directory."
	fi
	if use python ; then
		elog "Python examples are installed to '/usr/lib64/python{2.7,3.x}/site-packages/cantera/examples' directories."
	fi
}
