# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN/-/_}
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="A defined interface for working with a cache of jupyter notebooks"
HOMEPAGE="https://jupyter-cache.readthedocs.io"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
		$(python_gen_cond_dep '
			dev-python/attrs[${PYTHON_USEDEP}]
			dev-python/click[${PYTHON_USEDEP}]
			dev-python/importlib-metadata[${PYTHON_USEDEP}]
			dev-python/nbclient[${PYTHON_USEDEP}]
			dev-python/nbformat[${PYTHON_USEDEP}]
			dev-python/pyyaml[${PYTHON_USEDEP}]
			dev-python/sqlalchemy[${PYTHON_USEDEP}]
			dev-python/tabulate[${PYTHON_USEDEP}]
		')
"
RDEPEND="${DEPEND}"
