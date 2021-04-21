# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

MY_PN="pyarmadillo"

DESCRIPTION="PyArmadillo: linear algebra library for Python that is relied on Armadillo"
HOMEPAGE="https://pyarma.sourceforge.io/"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-${PV}.tar.xz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="arpack blas bundled-libs hdf5 lapack superlu test"
RESTRICT="!test? ( test )"

# SciKit-Build generate own CMake build directory "${S}/_skbuild/linux-x86_64-3.8/cmake-build"
# and ignored config generated bu cmake_src_configure() function is cmake.eclass is inherited.
# Therefore CMake is directly in BDEPEND
BDEPEND="
	dev-util/cmake
	virtual/pkgconfig
"
# Build with bundled Armadillo and PyBind11 is recommended by upstream.
# Note: with USE="bundled-libs" some libraries could be autdetected to build
# bundled Armadillo, e.g. with LAPACK support, if it's installed in system.
# For MKL support only autodetect here is used.
# If build with system libraries then sci-libs/armadillo USE flags are used.
RDEPEND="
	${PYTHON_DEPS}
	bundled-libs? (
		arpack? ( sci-libs/arpack )
		blas? ( virtual/blas )
		lapack? ( virtual/lapack )
		superlu? ( >=sci-libs/superlu-5.2 )
	)
	!bundled-libs? (
		sci-libs/armadillo[arpack?,blas?,hdf5?,lapack?,superlu?]
	)
"
DEPEND="
	${RDEPEND}
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/scikit-build[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	bundled-libs? (
		hdf5? ( sci-libs/hdf5 )
	)
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pluggy[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		sys-apps/pkgcore[${PYTHON_USEDEP}]
		bundled-libs? (
			virtual/lapack
		)
		!bundled-libs? (
			sci-libs/armadillo[lapack]
		)
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's/"cmake", "ninja", //' setup.py || die
	sed -i -e 's/"cmake", "ninja", //' pyproject.toml

	if use !bundled-libs ; then
		eapply "${FILESDIR}/${P}_unbundle_libs.patch"
		rm -rf "${S}/ext"
	fi

	eapply_user
}

python_prepare_all() {
	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile
}

python_install_all() {
	distutils-r1_python_install_all
	python_optimize "${D}/$(python_get_sitedir)/${PN}"

	rm -rf "${D}/$(python_get_sitedir)/${PN}/"{include,$(get_libdir),share}
}

python_test() {
	epytest tests_auto/*.py || die
}
