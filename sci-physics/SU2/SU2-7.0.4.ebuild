# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit meson python-single-r1

DESCRIPTION="SU2: An Open-Source Suite for Multiphysics Simulation and Design"
HOMEPAGE="https://su2code.github.io/"
SRC_URI="
	https://github.com/su2code/SU2/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/su2code/TestCases/archive/v${PV}.tar.gz -> ${P}-TestCases.tar.gz )
	tutorials? ( https://github.com/su2code/Tutorials/archive/v${PV}.tar.gz -> ${P}-Tutorials.tar.gz )
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

IUSE="cgns -mkl +mpi openblas tecio test tutorials"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	mkl? ( !openblas )
"

RDEPEND="
	${PYTHON_DEPS}
	mpi? ( virtual/mpi[cxx] )
	mkl? ( sci-libs/mkl )
	openblas? ( sci-libs/openblas )
"
DEPEND="
	${RDEPEND}
	tecio? ( dev-libs/boost:= )
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-fix-env.patch"
	"${FILESDIR}/${P}-unbundle_boost.patch"
	"${FILESDIR}/${P}-fix-python-optimize.patch"
)

DOCS=( "LICENSE.md" "README.md" "SU2_PY/documentation.txt" )

src_unpack() {
	unpack "${P}.tar.gz"
	if use test ; then
		einfo "Unpacking ${P}-TestCases.tar.gz to /var/tmp/portage/sci-physics/${P}/work/${P}/TestCases"
		tar -C "${P}"/TestCases --strip-components=1 -xzf "${DISTDIR}/${P}-TestCases.tar.gz" || die
	fi
	if use tutorials ; then
		einfo "Unpacking ${P}-Tutorials.tar.gz to /var/tmp/portage/sci-physics/${P}/work/${P}"
		mkdir "${P}"/Tutorials
		tar -C "${P}"/Tutorials --strip-components=1 -xzf "${DISTDIR}/${P}-Tutorials.tar.gz" || die
	fi
}

src_configure() {
	local emesonargs=(
		-Denable-autodiff=false
		-Denable-directdiff=false
		-Denable-pastix=false
		-Denable-pywrapper=false
		-Dwith-omp=false
		$(meson_feature mpi with-mpi)
		$(meson_use cgns enable-cgns)
		$(meson_use mkl enable-mkl)
		$(meson_use openblas enable-openblas)
		$(meson_use tecio enable-tecio)
		$(meson_use test enable-tests)
	)
	meson_src_configure
}

src_test() {
	ln -s ../../${P}-build/SU2_CFD/src/SU2_CFD SU2_PY/SU2_CFD
	ln -s ../../${P}-build/SU2_DEF/src/SU2_DEF SU2_PY/SU2_DEF
	ln -s ../../${P}-build/SU2_DOT/src/SU2_DOT SU2_PY/SU2_DOT
	ln -s ../../${P}-build/SU2_GEO/src/SU2_GEO SU2_PY/SU2_GEO
	ln -s ../../${P}-build/SU2_MSH/src/SU2_MSH SU2_PY/SU2_MSH
	ln -s ../../${P}-build/SU2_SOL/src/SU2_SOL SU2_PY/SU2_SOL

	export SU2_RUN="${S}/SU2_PY"
	export SU2_HOME="${S}"
	export PATH=$PATH:$SU2_RUN
	export PYTHONPATH=$PYTHONPATH:$SU2_RUN

	einfo "Running UnitTests ..."
	../${P}-build/UnitTests/test_driver

	pushd TestCases/
	use mpi && python parallel_regression.py
	use mpi || python serial_regression.py
	use tutorials && use mpi && python tutorials.py
	popd
}

src_install() {
	meson_src_install
	mkdir -p "${ED}$(python_get_sitedir)"
	mv "${ED}"/usr/bin/{FSI,SU2,*.py} -t "${ED}$(python_get_sitedir)"
	python_optimize "${D}/$(python_get_sitedir)"

	if use tutorials ; then
		insinto "/usr/share/${P}"
		doins -r Tutorials
	fi
}
