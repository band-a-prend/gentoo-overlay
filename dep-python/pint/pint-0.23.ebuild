# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
#PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} pypy3 )

inherit distutils-r1 pypi

MY_PN="Pint"
DESCRIPTION="Python package to define, operate and manipulate physical quantities"
HOMEPAGE="https://github.com/hgrecco/pint"
SRC_URI="$(pypi_sdist_url --no-normalize "${MY_PN^}" "${PV}")"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_PN}-${PV}"

RDEPEND="
	dev-python/numpy
	dev-python/uncertainties
	dev-python/xarray
"
#	>=dev-python/sphinx-4.5.0-r1[${PYTHON_USEDEP}]
#	doc? ( dev-python/insipid-sphinx-theme )
DEPEND="
	test? ( dev-python/pytest-subtests )
"

DOCS=()

distutils_enable_tests pytest
#distutils_enable_sphinx docs

#src_prepare() {
#	default
#	sed -i -e 's/license_file/license_files/' setup.cfg || die
#}

#python_install_all() {
#	distutils-r1_python_install_all
#	find "${ED}" -name '*.pth' -delete || die
#}
