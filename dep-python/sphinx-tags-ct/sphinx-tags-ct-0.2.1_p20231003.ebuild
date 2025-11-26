# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

sphinx_tags_sha="d060970037ec44e56a28d65b052ddd96099a98b6"

# Fork of https://github.com/melissawm/sphinx-tags project
DESCRIPTION="Cantera fork of a tiny Sphinx extension for documentation blog-style tags"
HOMEPAGE="https://github.com/Cantera/sphinx-tags"
SRC_URI="https://github.com/Cantera/sphinx-tags/archive/${sphinx_tags_sha}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/sphinx-tags-${sphinx_tags_sha}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
		$(python_gen_cond_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
		')
"
RDEPEND="
	${DEPEND}
"
