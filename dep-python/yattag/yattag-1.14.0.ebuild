# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Python alternative to web template engines"
HOMEPAGE="https://github.com/leforestier/yattag"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"

python_test() {
	distutils_install_for_testing

	${EPYTHON} test/tests_doc.py || die
	${EPYTHON} test/tests_indentation.py || die
	${EPYTHON} test/tests_simpledoc.py || die
}
