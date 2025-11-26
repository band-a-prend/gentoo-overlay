# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{11..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Python package to define, operate and manipulate physical quantities"
HOMEPAGE="https://github.com/hgrecco/pint"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/flexcache[${PYTHON_USEDEP}]
	dev-python/flexparser[${PYTHON_USEDEP}]
	dev-python/uncertainties[${PYTHON_USEDEP}]
	dev-python/xarray[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? ( dev-python/pytest-subtests[${PYTHON_USEDEP}] )
"

DOCS=()

distutils_enable_tests pytest
