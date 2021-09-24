# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

MY_PN="MaTiSSe.py"
DESCRIPTION="Markdown To Impressive Scientific Slides"
HOMEPAGE="https://github.com/szaghi/MaTiSSe"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_PN}-${PV}"

IDEPEND="
	dev-python/dirsync[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/yattag[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}/${P}_fix_python3.patch" )

src_prepare() {
	default

	# Fix installation paths
	sed -i -e "s:matisse/utils:share/matisse/utils:" setup.py || die
	# Fix "TypeError: 'dict_keys' object is not subscriptable"
	sed -i -e "s:css.keys():list(css.keys()):" matisse/theme.py || die
}

pkg_postinst() {
	elog "To run matisse use MaTiSSe.py command"
}
