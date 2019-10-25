# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils

MY_PN="doublecmd"
DESCRIPTION="Free cross platform open source file manager with two panels side by side."
HOMEPAGE="http://${MY_PN}.sourceforge.net/"

SRC_URI="amd64? ( gtk? ( mirror://sourceforge/${MY_PN}/${MY_PN}-${PV}.gtk2.x86_64.tar.xz )
		qt5?  ( mirror://sourceforge/${MY_PN}/${MY_PN}-${PV}.qt5.x86_64.tar.xz ) )
	x86? ( gtk? ( mirror://sourceforge/${MY_PN}/${MY_PN}-${PV}.gtk2.i386.tar.xz )
		qt5?  ( mirror://sourceforge/${MY_PN}/${MY_PN}-${PV}.qt5.i386.tar.xz ) )"

RESTRICT="mirror"

S="${WORKDIR}/${MY_PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk qt5"
REQUIRED_USE=" ^^ ( gtk qt5 ) "

QA_PREBUILT="
	*/doublecmd
	*/libQt5Pas.so.1
	"

RDEPEND="
	sys-apps/dbus
	dev-libs/glib
	sys-libs/ncurses
	x11-libs/libX11
	gtk? ( x11-libs/gtk+:2 )
	qt5? ( dev-qt/qtgui:5
	dev-qt/qtx11extras:5 )
	"

src_prepare(){
	default
	## Create partial init config that allows to store config within user home directory
	cp "${FILESDIR}/doublecmd.xml" "${S}/"
}

src_install(){
	insinto "/opt/${MY_PN}-bin"
	doins -r "${S}/."

	exeinto "/opt/${MY_PN}-bin"
	doexe "${S}/${MY_PN}"
	dosym ../../opt/${MY_PN}-bin/${MY_PN} /usr/bin/${MY_PN}-bin

	doicon -s 48 ${MY_PN}.png
	make_desktop_entry "${MY_PN}-bin" "Double Commander" "${MY_PN}" "Utility;" || die "Failed making desktop entry!"

	if use qt5; then
		newlib.so libQt5Pas.so.1 libQt5Pas.so.1
	fi
}
