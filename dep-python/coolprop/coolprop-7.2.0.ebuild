# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=scikit-build-core
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN/-/_}
PYTHON_COMPAT=( python3_{11..14} )

inherit cmake distutils-r1 pypi

DESCRIPTION="A defined interface for working with a cache of jupyter notebooks"
HOMEPAGE="https://jupyter-cache.readthedocs.io"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
		$(python_gen_cond_dep '
			dev-python/numpy[${PYTHON_USEDEP}]
		')
"
DEPEND="
	${RDEPEND}
	$(python_gen_cond_dep '
		dev-python/cython[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
"

distutils_enable_tests pytest
