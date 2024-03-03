# Copyright 1999-2021 Gentoo Authors
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

# USE="fortran" enables FortranProject plugin (updated to v1.8 2021-05-29 [r230])
# that is delivered with Code::Blocks 20.03 source code.
# https://sourceforge.net/projects/fortranproject
# https://cbfortran.sourceforge.io

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
	"${FILESDIR}"/0001-FortranProject-autotools-build.patch
	"${FILESDIR}"/0002-FortranProject-update-r271-r272.patch
	"${FILESDIR}"/0003-FortranProject-update-r273.patch
	"${FILESDIR}"/0004-FortranProject-update-r274.patch
	"${FILESDIR}"/0005-FortranProject-update-r275.patch
	"${FILESDIR}"/0006-FortranProject-update-r276.patch
	"${FILESDIR}"/0007-FortranProject-update-r277.patch
	"${FILESDIR}"/0008-FortranProject-update-r278.patch
	"${FILESDIR}"/0009-FortranProject-update-r279.patch
	"${FILESDIR}"/0010-FortranProject-update-r280.patch
	"${FILESDIR}"/0011-FortranProject-update-r281.patch
	"${FILESDIR}"/0012-FortranProject-update-r282.patch
	"${FILESDIR}"/0013-FortranProject-update-r283.patch
	"${FILESDIR}"/0014-FortranProject-update-r284.patch
	"${FILESDIR}"/0015-FortranProject-update-r285.patch
	"${FILESDIR}"/0016-FortranProject-update-r286.patch
	"${FILESDIR}"/0017-FortranProject-update-r287.patch
	"${FILESDIR}"/0018-FortranProject-update-r288.patch
	"${FILESDIR}"/0019-FortranProject-update-r289.patch
	"${FILESDIR}"/0020-FortranProject-update-r290.patch
	"${FILESDIR}"/0021-FortranProject-update-r291.patch
	"${FILESDIR}"/0022-FortranProject-update-r292.patch
	"${FILESDIR}"/0023-FortranProject-update-r293.patch
	"${FILESDIR}"/0023-FortranProject-update-r294.patch
	"${FILESDIR}"/0025-FortranProject-update-r295.patch
	"${FILESDIR}"/0026-FortranProject-update-r296.patch
	"${FILESDIR}"/0027-FortranProject-update-r297.patch
	"${FILESDIR}"/0028-FortranProject-update-r298.patch
	"${FILESDIR}"/0029-FortranProject-update-r299.patch
	"${FILESDIR}"/0030-FortranProject-update-r300.patch
	"${FILESDIR}"/0031-FortranProject-update-r301.patch
	"${FILESDIR}"/0032-FortranProject-update-r302.patch
	"${FILESDIR}"/0033-FortranProject-update-r303.patch
	"${FILESDIR}"/0034-FortranProject-update-r304.patch
	"${FILESDIR}"/0035-FortranProject-update-r305.patch
	"${FILESDIR}"/0036-FortranProject-update-r306.patch
	"${FILESDIR}"/0037-FortranProject-update-r307.patch
	"${FILESDIR}"/0038-FortranProject-update-r308.patch
	"${FILESDIR}"/0039-FortranProject-update-r309.patch
	"${FILESDIR}"/0040-FortranProject-update-r310.patch
	"${FILESDIR}"/0041-FortranProject-update-r311.patch
	"${FILESDIR}"/0042-FortranProject-update-r312.patch
	"${FILESDIR}"/0043-FortranProject-update-r313.patch
	"${FILESDIR}"/0044-FortranProject-update-r314.patch
	"${FILESDIR}"/0045-FortranProject-update-r315.patch
	"${FILESDIR}"/0046-FortranProject-update-r316.patch
	"${FILESDIR}"/0047-FortranProject-update-r317.patch
	"${FILESDIR}"/0048-FortranProject-update-r318.patch
	"${FILESDIR}"/0049-FortranProject-update-r319.patch
	"${FILESDIR}"/0050-FortranProject-update-r320.patch
	"${FILESDIR}"/0051-FortranProject-update-r321.patch
	"${FILESDIR}"/0052-FortranProject-update-r322.patch
	"${FILESDIR}"/0053-FortranProject-update-r323.patch
	"${FILESDIR}"/0054-FortranProject-update-r324.patch
	"${FILESDIR}"/0055-FortranProject-update-r325.patch
	"${FILESDIR}"/0056-FortranProject-update-r326.patch
	"${FILESDIR}"/0057-FortranProject-update-r327.patch
	"${FILESDIR}"/0058-FortranProject-update-r328.patch
	"${FILESDIR}"/0059-FortranProject-update-r329.patch
	"${FILESDIR}"/0060-FortranProject-update-r330.patch
	"${FILESDIR}"/0001-CodeBlocks-codecompletion-r12190.patch
	"${FILESDIR}"/0002-CodeBlocks-codecompletion-r12209.patch
	"${FILESDIR}"/0003-CodeBlocks-codecompletion-r12218.patch
	"${FILESDIR}"/0004-CodeBlocks-codecompletion-r12287.patch
	"${FILESDIR}"/0005-CodeBlocks-codecompletion-r12289.patch
	"${FILESDIR}"/0006-CodeBlocks-codecompletion-r12293.patch
	"${FILESDIR}"/0007-CodeBlocks-openfileslistplugin-gcc11-r12303.patch
	"${FILESDIR}"/0008-CodeBlocks-codecompletion-r12304.patch
	"${FILESDIR}"/0009-CodeBlocks-codecompletion-r12314.patch
	"${FILESDIR}"/0010-CodeBlocks-codecompletion-r12317.patch
	"${FILESDIR}"/0011-CodeBlocks-codecompletion-r12322.patch
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
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
