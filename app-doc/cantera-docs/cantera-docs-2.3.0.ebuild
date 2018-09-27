# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop

DESCRIPTION="Documentation API reference for Cantera package libraries"
HOMEPAGE="https://cantera.org"
SRC_URI="https://github.com/Cantera/docs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S="${WORKDIR}/docs-${PV}"

src_prepare()
{
	default
	rm "${S}/.gitignore"
	rm "${S}/.nojekyll"
	rm "${S}/banner4.jpg"
}

src_install() {
	dodir /usr/share/cantera/doc/
	cp -R "${S}/." "${D}/usr/share/cantera/doc/" || die "cantera-docs installation failed"

	make_desktop_entry "/usr/bin/xdg-open /usr/share/cantera/doc/doxygen/html/index.html" "Cantera Doxygen Documentation" "text-html" "Development"
	make_desktop_entry "/usr/bin/xdg-open /usr/share/cantera/doc/sphinx/html/index.html" "Cantera Sphinx Documentation" "text-html" "Development"
}
