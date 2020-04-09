# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

inherit distutils-r1

DESCRIPTION="KaTeX Sphinx extension for rendering of math in HTML pages"
HOMEPAGE="https://github.com/hagenw/sphinxcontrib-katex"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-python/sphinx-1.7.5[${PYTHON_USEDEP}]"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( "CONTRIBUTING.rst" "README.rst" )

python_install_all() {
	distutils-r1_python_install_all
	find "${ED}" -name '*.pth' -delete || die
}
