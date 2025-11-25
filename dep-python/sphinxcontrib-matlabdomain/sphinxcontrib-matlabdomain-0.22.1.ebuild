# Copyright 1999-2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="MATLAB Sphinx domain and autodoc extensions"
HOMEPAGE="http://www.sphinx-doc.org"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/pygments[${PYTHON_USEDEP}]"
# avoid circular dependency with sphinx
PDEPEND="
	>=dev-python/sphinx-4.5.0-r1[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_install_all() {
	distutils-r1_python_install_all
	find "${ED}" -name '*.pth' -delete || die
}
