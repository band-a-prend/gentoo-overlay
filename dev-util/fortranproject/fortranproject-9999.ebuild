# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"

inherit autotools subversion wxwidgets

DESCRIPTION="FortranProject plugin for Code::Blocks IDE"
HOMEPAGE="http://cbfortran.sourceforge.net/"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS=""
SRC_URI=""
ESVN_REPO_URI="https://svn.code.sf.net/p/${PN}/code/trunk"

RDEPEND="=dev-util/codeblocks-9999-r0"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i "s:#include <tinyxml/tinyxml.h>:#include <tinyxml.h>:" nativeparserf.cpp || die
	eautoreconf
}

src_configure() {
	setup-wxwidgets
	econf
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
