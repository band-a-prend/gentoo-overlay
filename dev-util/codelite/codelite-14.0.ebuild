# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_BUILD_TYPE="Gentoo"
CMAKE_MAKEFILE_GENERATOR="emake"
WX_GTK_VER="3.0-gtk3"

inherit cmake wxwidgets xdg

DESCRIPTION="CodeLite, a cross platform C/C++/PHP and Node.js IDE"
HOMEPAGE="https://codelite.org/"
SRC_URI="https://github.com/eranif/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2-with-exceptions"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="clang +cpp-plugins custom-notebook flex lldb mysql pch sftp webview"
RESTRICT="strip"

REQUIRED_USE="
	lldb? ( cpp-plugins )
	sftp? ( cpp-plugins )
"

BDEPEND="virtual/pkgconfig"

RDEPEND="
	app-text/hunspell
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	clang? ( sys-devel/clang )
	lldb? ( dev-util/lldb )
	mysql? ( virtual/mysql )
	sftp? ( net-libs/libssh )
	webview? ( x11-libs/wxGTK:${WX_GTK_VER}[webkit] )
"

DEPEND="
	${RDEPEND}
	flex? ( sys-devel/flex )
"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	setup-wxwidgets

	mycmakeargs+=(
		-DENABLE_SFTP="$(usex sftp 1 0)"
		-DENABLE_LLDB="$(usex lldb 1 0)"
		-DPHP_BUILD="$(usex cpp-plugins 0 1)"
		-DUSE_AUI_NOTEBOOK="$(usex custom-notebook 1 0)"
		-DUSE_CLANG="$(usex clang)"
		-DWITH_FLEX="$(usex flex)"
		-DWITH_MYSQL="$(usex mysql)"
		-DWITH_PCH="$(usex pch 1 0)"
		-DWITH_WEBVIEW="$(usex webview)"
		-DWITH_WXC=0
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
