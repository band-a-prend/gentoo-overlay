# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
MY_PN=${PN%-*}

inherit desktop python-single-r1 xdg-utils

DESCRIPTION="Web based tool to extract data from plots, images, and maps"
HOMEPAGE="https://automeris.io/${MY_PN}/"
SRC_URI="https://automeris.io/downloads/${MY_PN}-${PV}-linux-x64.zip"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
#RESTRICT="strip"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

QA_PREBUILT="
	*/libGLESv2.so
	*/libEGL.so
	*/libffmpeg.so
	*/libvk_swiftshader.so
	*/${MY_PN}-${PV}
	"

## RDEPEND is still required to be filled with actual runtime-deps:
## python is just assumed runtime-dependency.
RDEPEND="${PYTHON_DEPS}"

S="${WORKDIR}/${MY_PN}-${PV}-linux-x64"

src_install() {
	insinto "/opt/${P}"
	doins -r "${S}/."

	exeinto "/opt/${P}"
	doexe "/${S}/${MY_PN}-${PV}"
	dosym ../../opt/${MY_PN}-bin-${PV}/${MY_PN}-${PV} /usr/bin/${PN}

	newicon "/${S}/resources/app/images/icon/icon.png" ${PN}-icon.png

	make_desktop_entry "/opt/${P}/${MY_PN}-${PV}" "${MY_PN}" "${PN}-icon" "Graphics"
	## After opening via xdg-open the js scripts could not work (i.e. "File - Load Image" menu)
	make_desktop_entry "/usr/bin/xdg-open /opt/${P}/resources/app/index.html" "${MY_PN} html" "viewhtml" "Graphics"
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
