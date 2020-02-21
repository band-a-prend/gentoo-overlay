# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FORTRAN_STANDARD=2003

inherit  fortran-2

# Unfortunately the releases doesn't have appropriate release-tags
# so there commit sha-1 checksum are used for
# StringiFor-1.1.1, BeFoR-1.1.4, FACE-1.1.2, PENF-1.2.2
StringiFor_sha="7f73f2682372201721f0fd670cf9c772d11b5268"
BeFoR64_sha="d2be41faa804c5b1b811351c5384cdb6c58ce431"
FACE_sha="e3700566a18e145f0f90ba6c89570b690526845b"
PENF_sha="d2b27d5652f48584b9468ebd0b11dd44b5fb1638"

DESCRIPTION="StringiFor, Strings Fortran Manipulator, yet another strings Fortran module"
HOMEPAGE="https://github.com/szaghi/StringiFor"
SRC_URI="
	https://github.com/szaghi/${PN}/archive/${StringiFor_sha}.zip -> ${P}.zip
	https://github.com/szaghi/FACE/archive/"${FACE_sha}".zip -> FACE-1.1.2.zip
	https://github.com/szaghi/PENF/archive/"${PENF_sha}".zip -> PENF-1.2.2.zip
	https://github.com/szaghi/BeFoR64/archive/"${BeFoR64_sha}".zip -> BeFoR64-1.1.4.zip
"

S="${WORKDIR}/${PN}-${StringiFor_sha}"

# For FOSS projects: GPL-3
# For closed source/commercial projects: BSD 2-Clause, BSD 3-Clause, MIT
LICENSE="GPL-3 BSD-2 BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
#IUSE="test"
#RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="
	${RDEPEND}
	dev-util/FoBiS
"

PATCHES=( "${FILESDIR}/stringifor-1.1.1_fobos_soname.patch" )

pkg_setup() {
	fortran-2_pkg_setup
}

src_prepare() {
	default
	mv -T "${WORKDIR}"/BeFoR64-"${BeFoR64_sha}" "${S}"/src/third_party/BeFoR64
	mv -T "${WORKDIR}"/FACE-"${FACE_sha}" "${S}"/src/third_party/FACE
	mv -T "${WORKDIR}"/PENF-"${PENF_sha}" "${S}"/src/third_party/PENF
}

src_compile() {
	FoBiS.py build -mode stringifor-static-gnu
	FoBiS.py build -mode stringifor-shared-gnu
}

#src_test() {
#
#}

src_install() {
	mv lib/mod lib/stringifor
	doheader -r lib/stringifor/
	dolib.a lib/libstringifor.a
	mv lib/libstringifor.so{,.1}
	dosym libstringifor.so.1 /usr/$(get_libdir)/libstringifor.so
	dolib.so lib/libstringifor.so.1
}
