# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# py3.14 is not active here because not all "USE=doc" dependencies have py3.14 support at this moment
PYTHON_COMPAT=( python3_{11..13} )

FORTRAN_NEEDED=fortran
FORTRAN_STANDARD="77 90"

inherit flag-o-matic fortran-2 python-single-r1 scons-utils toolchain-funcs

DESCRIPTION="Object-oriented tool suite for chemical kinetics, thermodynamics, and transport"
HOMEPAGE="https://www.cantera.org"
## Some files may require to update Manifest as urls link to the latest versions
SRC_URI="
	https://github.com/Cantera/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/Cantera/cantera-example-data/archive/refs/tags/v${PV}.tar.gz -> ${P}_example_data.tar.gz
	doc? (
		https://docs.python.org/3.13/objects.inv -> ct_python-3.13.9_objects.inv
		https://pandas.pydata.org/pandas-docs/version/2.3/objects.inv -> ct_pandas-2.3.3_pydata_objects.inv
		https://numpy.org/doc/2.3/objects.inv -> ct_numpy-2.3.5_objects.inv
		https://pint.readthedocs.io/en/0.25.1/objects.inv -> ct_pint-0.25.1_objects.inv
		https://github.com/jothepro/doxygen-awesome-css/archive/refs/tags/v2.4.1.tar.gz -> doxygen-awesome-css-2.4.1.tar.gz
		https://raw.githubusercontent.com/Cantera/cantera-website/2ebd8558ae095b66f849826e9d07c8e3feb47dee/source/index.md -> ct_website_2ebd855_index.md
		https://raw.githubusercontent.com/Cantera/cantera-website/2ebd8558ae095b66f849826e9d07c8e3feb47dee/source/_static/img/Git_Logo.png -> ct_Git_Logo.png
		https://raw.githubusercontent.com/Cantera/cantera-website/2ebd8558ae095b66f849826e9d07c8e3feb47dee/source/_static/img/Groups_Logo.png -> ct_Groups_Logo.png
		https://github.com/mathjax/MathJax/archive/refs/tags/v3.2.2.tar.gz -> mathjax-3.2.2.tar.gz
	)
"
##  When build the Sphinx docs then trying to download:
##  https://docs.python.org/3/objects.inv
##  https://pandas.pydata.org/pandas-docs/stable/objects.inv
##  https://numpy.org/doc/stable/objects.inv
##  https://pint.readthedocs.io/en/stable/objects.inv

## MIT license is for doxygen-awesome-css
## Apache-2.0 license is for MathJax (for offline equations rendering)
LICENSE="BSD MIT Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="doc fortran hdf5 lapack +python test"
RESTRICT="!test? ( test ) mirror"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	doc? ( python )
"

RDEPEND="
	${PYTHON_DEPS}
	dev-cpp/yaml-cpp
	hdf5? ( sci-libs/highfive )
	!lapack? ( sci-libs/sundials:0= )
	lapack? (
		>=sci-libs/sundials-6.5.0:0=[lapack?]
		virtual/lapack
	)
	python? (
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
			dev-python/ruamel-yaml[${PYTHON_USEDEP}]
		')
	)
"

DEPEND="
	${RDEPEND}
	>=app-text/doxygen-1.13.0[dot]
	dev-cpp/eigen:3
	dev-libs/boost:=
	dev-libs/libfmt
	doc? (
		$(python_gen_cond_dep '
			dev-python/coolprop[${PYTHON_USEDEP}]
			dev-python/flexcache[${PYTHON_USEDEP}]
			dev-python/graphviz[${PYTHON_USEDEP}]
			dev-python/matplotlib[${PYTHON_USEDEP}]
			dev-python/myst-nb[${PYTHON_USEDEP}]
			dev-python/myst-parser[${PYTHON_USEDEP}]
			dev-python/pandas[${PYTHON_USEDEP}]
			dev-python/pint[${PYTHON_USEDEP}]
			dev-python/pydata-sphinx-theme[${PYTHON_USEDEP}]
			dev-python/scipy[${PYTHON_USEDEP}]
			dev-python/sphinx-argparse[${PYTHON_USEDEP}]
			dev-python/sphinx-copybutton[${PYTHON_USEDEP}]
			dev-python/sphinx-design[${PYTHON_USEDEP}]
			dev-python/sphinx-gallery[${PYTHON_USEDEP}]
			dev-python/sphinx-tags-ct[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinxcontrib-bibtex[${PYTHON_USEDEP}]
			dev-python/sphinxcontrib-doxylink[${PYTHON_USEDEP}]
			dev-python/sphinxcontrib-matlabdomain[${PYTHON_USEDEP}]
		')
	)
	python? (
		$(python_gen_cond_dep '
			dev-python/cython[${PYTHON_USEDEP}]
			dev-python/pip[${PYTHON_USEDEP}]
		')
	)
	test? (
		>=dev-cpp/gtest-1.11.0
		python? (
			$(python_gen_cond_dep '
				dev-python/h5py[${PYTHON_USEDEP}]
				dev-python/pandas[${PYTHON_USEDEP}]
				dev-python/pytest[${PYTHON_USEDEP}]
				dev-python/scipy[${PYTHON_USEDEP}]
			')
		)
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-3.1.0_env.patch"
	"${FILESDIR}/${P}_sphinx_docs_modify.patch"
	"${FILESDIR}/${P}_fix_continuity_equation.patch"
)

src_unpack() {
	default
	mv -T "${WORKDIR}/${PN}-example-data-${PV}" "${S}"/data/example_data || die
	if use doc ; then
		mv -T "${WORKDIR}/doxygen-awesome-css-2.4.1" "${S}"/ext/doxygen-awesome-css || die
		cp "${DISTDIR}/ct_Git_Logo.png" "${S}/doc/sphinx/_static/images/Git_Logo.png" || die
		cp "${DISTDIR}/ct_Groups_Logo.png" "${S}/doc/sphinx/_static/images/Groups_Logo.png" || die
	fi
	# Replace initial index.md with taken from https://github.com/Cantera/cantera-website project
	# Later additional patch is applied for menu modifications
	cp "${DISTDIR}/ct_website_2ebd855_index.md" "${S}/doc/sphinx/index.md" || die
}

pkg_setup() {
	fortran-2_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	default
	use doc && { cp -r "${DISTDIR}"/{ct_numpy-2.3.5,ct_python-3.13.9,ct_pandas-2.3.3_pydata,ct_pint-0.25.1}_objects.inv "${S}/doc/sphinx/" || die; }
	sed -i -e "/'numpy'/s:None:'ct_numpy-2.3.5_objects.inv':" \
		-e "/'python'/s:None:'ct_python-3.13.9_objects.inv':" \
		-e "/'pandas'/s:None:'ct_pandas-2.3.3_pydata_objects.inv':" \
		-e "/'pint'/s:None:'ct_pint-0.25.1_objects.inv':" \
		 "${S}/doc/sphinx/conf.py" || die
}

## Full list of configuration options of Cantera is presented here:
## https://cantera.org/3.2/develop/compiling/config-options.html
src_configure() {
	# -Werror=odr, -Werror=lto-type-mismatch
	# https://github.com/Cantera/cantera/issues/1783
	filter-lto

	scons_vars=(
		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		cc_flags="${CXXFLAGS}"
		cxx_flags="-std=c++20"
		debug="no"
		FORTRAN="$(tc-getFC)"
		FORTRANFLAGS="${FCFLAGS}"
		optimize_flags="-Wno-inline"
		renamed_shared_libraries="no"
		use_pch="no"
		doxygen_docs=$(usex doc)
		sphinx_docs=$(usex doc)
		## In some cases other order can break the detection of right location of Boost: ##
		system_fmt="y"
		system_sundials="y"
		system_eigen="y"
		system_yamlcpp="y"
		hdf_support=$(usex hdf5 y n)
		system_blas_lapack=$(usex lapack y n)
		env_vars="all"
		extra_inc_dirs="/usr/include/eigen3"
		use_rpath_linkage="yes"
		extra_lib_dirs="/usr/$(get_libdir)/${PN}"
	)
	use hdf5 && scons_vars+=( system_highfive="y" )
	use lapack && scons_vars+=( blas_lapack_libs="lapack,blas" )
	use test || scons_vars+=( googletest="none" )

	scons_targets=(
		f90_interface=$(usex fortran y n)
	)

	if use python ; then
		scons_targets+=( python_package="y" python_cmd="${EPYTHON}" )
	else
		scons_targets+=( python_package="n" )
	fi
}

src_compile() {
	escons build "${scons_vars[@]}" "${scons_targets[@]}" prefix="/usr"
	if use doc ; then
#		escons doxygen
#		escons sphinx
		cp -r "${WORKDIR}/MathJax-3.2.2" "${S}/build/doc/html/_static/" || die
	fi
}

src_test() {
	escons test
}

src_install() {
	escons install stage_dir="${D}" libdirname="$(get_libdir)"
	if ! use python ; then
		rm -r "${D}/usr/share/man" || die "Can't remove man files."
	else
		# Run the byte-compile of modules
		python_optimize "${D}$(python_get_sitedir)/${PN}"
	fi

	# User could remove this line if require static libs for development purpose
	find "${ED}" -name '*.a' -delete || die
}

pkg_postinst() {
	local post_msg=$(usex fortran "and Fortran " "")
	elog "C++ ${post_msg}samples are installed to '/usr/share/${PN}/samples/' directory."
}
