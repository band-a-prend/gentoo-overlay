# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"

inherit autotools wxwidgets xdg

DESCRIPTION="The open source, cross platform, free C, C++ and Fortran IDE"
HOMEPAGE="https://codeblocks.org/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

# USE="fortran" enables FortranProject plugin (updated to v1.7 2020-06-07 [r298])
# that is delivered with Code::Blocks 20.03 source code.
# https://sourceforge.net/projects/fortranproject
# http://cbfortran.sourceforge.net

IUSE="contrib debug fortran pch"

BDEPEND="virtual/pkgconfig"

RDEPEND="app-arch/zip
	>=dev-libs/tinyxml-2.6.2-r3
	>=dev-util/astyle-3.1-r2:0/3.1
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	contrib? (
		app-admin/gamin
		app-text/hunspell
		dev-libs/boost:=
	)"

DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-env.patch
	"${FILESDIR}"/${P}-0001-FortranProject-autotools-build.patch
	"${FILESDIR}"/${P}-0002-FortranProject-update-r271-r272.patch
	"${FILESDIR}"/${P}-0003-FortranProject-update-r273.patch
	"${FILESDIR}"/${P}-0004-FortranProject-update-r274.patch
	"${FILESDIR}"/${P}-0005-FortranProject-update-r275.patch
	"${FILESDIR}"/${P}-0006-FortranProject-update-r276.patch
	"${FILESDIR}"/${P}-0007-FortranProject-update-r277.patch
	"${FILESDIR}"/${P}-0008-FortranProject-update-r278.patch
	"${FILESDIR}"/${P}-0009-FortranProject-update-r279.patch
	"${FILESDIR}"/${P}-0010-FortranProject-update-r280.patch
	"${FILESDIR}"/${P}-0011-FortranProject-update-r281.patch
	"${FILESDIR}"/${P}-0012-FortranProject-update-r282.patch
	"${FILESDIR}"/${P}-0013-FortranProject-update-r283.patch
	"${FILESDIR}"/${P}-0014-FortranProject-update-r284.patch
	"${FILESDIR}"/${P}-0015-FortranProject-update-r285.patch
	"${FILESDIR}"/${P}-0016-FortranProject-update-r286.patch
	"${FILESDIR}"/${P}-0017-FortranProject-update-r287.patch
	"${FILESDIR}"/${P}-0018-FortranProject-update-r288.patch
	"${FILESDIR}"/${P}-0019-FortranProject-update-r289.patch
	"${FILESDIR}"/${P}-0020-FortranProject-update-r290.patch
	"${FILESDIR}"/${P}-0021-FortranProject-update-r291.patch
	"${FILESDIR}"/${P}-0022-FortranProject-update-r292.patch
	"${FILESDIR}"/${P}-0023-FortranProject-update-r293.patch
	"${FILESDIR}"/${P}-0023-FortranProject-update-r294.patch
	"${FILESDIR}"/${P}-0025-FortranProject-update-r295.patch
	"${FILESDIR}"/${P}-0026-FortranProject-update-r296.patch
	"${FILESDIR}"/${P}-0027-FortranProject-update-r297.patch
	"${FILESDIR}"/${P}-0028-FortranProject-update-r298.patch
	)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	setup-wxwidgets

	# USE="contrib -fortran" setup:
	use fortran || CONF_WITH_LST=$(use_with contrib contrib-plugins all,-FortranProject)
	# USE="contrib fortran" setup:
	use fortran && CONF_WITH_LST=$(use_with contrib contrib-plugins all)
	# USE="-contrib fortran" setup:
	use contrib || CONF_WITH_LST=$(use_with fortran contrib-plugins FortranProject)

	econf \
		--disable-static \
		$(use_enable debug) \
		$(use_enable pch) \
		${CONF_WITH_LST}
}

pkg_postinst() {
	elog "The Symbols Browser is disabled due to it causing crashes."
	elog "For more information see https://sourceforge.net/p/codeblocks/tickets/225/"

	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
