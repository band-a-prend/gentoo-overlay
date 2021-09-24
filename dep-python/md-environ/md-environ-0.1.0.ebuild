# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="Syntax which allows for inclusion of contents of other Markdown docs"
HOMEPAGE="https://github.com/cmacmackin/md-environ"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="dev-python/markdown[${PYTHON_USEDEP}]"

src_prepare() {
	# Fix QA Notice: setuptools warning
	sed -i "s/description-file/description_file/" setup.cfg || die
	eapply_user
}
