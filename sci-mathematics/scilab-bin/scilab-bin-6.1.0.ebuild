# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg

DESCRIPTION="Open source software for numerical computation"
HOMEPAGE="https://www.scilab.org"
SRC_URI="amd64? ( https://scilab.org/download/${PV}/scilab-${PV}.bin.linux-x86_64.tar.gz )
	x86? ( https://scilab.org/download/${PV}/scilab-${PV}.bin.linux-i686.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

#RESTRICT="strip"

QA_PREBUILT="
	*/lib/thirdparty/libnewt.so.debug.debug
	*/lib/thirdparty/libgluegen2-rt.so.debug.debug
	*/lib/thirdparty/libjogl_mobile.so.debug
	*/lib/thirdparty/libnewt.so
	*/lib/thirdparty/libnewt.so.debug
	*/lib/thirdparty/libjogl_desktop.so
	*/lib/thirdparty/libnativewindow_awt.so.debug.debug
	*/lib/thirdparty/libnativewindow_awt.so.debug
	*/lib/thirdparty/libnativewindow_x11.so.debug
	*/lib/thirdparty/libjogl_desktop.so.debug
	*/lib/thirdparty/libnativewindow_awt.so
	*/lib/thirdparty/redist/libncurses.so.5.5
	*/lib/thirdparty/redist/libncurses.so.5.5.debug
	*/lib/thirdparty/libjogl_desktop.so.debug.debug
	*/lib/thirdparty/libgluegen2-rt.so.debug
	*/lib/thirdparty/libjogl_mobile.so
	*/lib/thirdparty/libgluegen2-rt.so
	*/lib/thirdparty/libnativewindow_x11.so.debug.debug
	*/lib/thirdparty/libnativewindow_x11.so
	*/lib/thirdparty/libjogl_mobile.so.debug.debug
"

## RDEPEND is required to be filled with actual runtime-deps:
#RDEPEND=""

S="${WORKDIR}/scilab-${PV}"

src_install() {
	insinto "/opt/${P}"
	doins -r "${S}/."

	exeinto "/opt/${P}/bin"
	doexe "/${S}/bin/XML2Modelica"
	doexe "/${S}/bin/modelicac"
	doexe "/${S}/bin/modelicat"
	doexe "/${S}/bin/scilab"
	doexe "/${S}/bin/scilab-bin"
	doexe "/${S}/bin/scilab-cli-bin"
	doexe "/${S}/bin/scinotes"
	doexe "/${S}/bin/xcos"

	dosym ../../opt/${P}/bin/scilab-adv-cli /usr/bin/scilab-adv-cli-bin
	dosym ../../opt/${P}/bin/scilab-cli /usr/bin/scilab-cli-bin
	dosym ../../opt/${P}/bin/scilab /usr/bin/scilab-bin

	newicon -s 32 "/${S}/share/icons/hicolor/32x32/apps/scilab.png" scilab.png
	newicon -s 32 "/${S}/share/icons/hicolor/32x32/apps/scinotes.png" scinotes.png
	newicon -s 32 "/${S}/share/icons/hicolor/32x32/apps/xcos.png" xcos.png

	insinto "/usr/share/mime/packages"
	doins "share/mime/packages/scilab.xml"

	make_desktop_entry "/opt/${P}/bin/scilab-adv-cli" "Scilab advanced CLI" "scilab" "Science;Math" "Terminal=true"
	make_desktop_entry "/opt/${P}/bin/scilab-cli" "Scilab CLI" "scilab" "Science;Math" "Terminal=true"
	make_desktop_entry "/opt/${P}/bin/scilab" "Scilab" "scilab" "Science;Math"
	make_desktop_entry "/opt/${P}/bin/scinotes" "Scinotes" "scinotes" "Science;Math"
	make_desktop_entry "/opt/${P}/bin/xcos" "Xcos" "xcos" "Science;Math"
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
