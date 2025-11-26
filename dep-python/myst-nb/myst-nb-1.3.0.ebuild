# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN/-/_}
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Parse and execute ipynb files in Sphinx"
HOMEPAGE="https://myst-nb.readthedocs.io"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
		$(python_gen_cond_dep '
			dev-python/importlib-metadata[${PYTHON_USEDEP}]
			dev-python/ipykernel[${PYTHON_USEDEP}]
			dev-python/ipython[${PYTHON_USEDEP}]
			dev-python/jupyter-cache[${PYTHON_USEDEP}]
			dev-python/myst-parser[${PYTHON_USEDEP}]
			dev-python/nbclient[${PYTHON_USEDEP}]
			dev-python/nbformat[${PYTHON_USEDEP}]
			dev-python/pyyaml[${PYTHON_USEDEP}]
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/typing-extensions[${PYTHON_USEDEP}]
		')
"
RDEPEND="${DEPEND}"
