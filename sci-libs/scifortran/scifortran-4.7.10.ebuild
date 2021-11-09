# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

FORTRAN_STANDARD=2003

inherit cmake fortran-2

MY_PN="SciFortran"

DESCRIPTION="A collection of Fortran modules and procedures for scientific calculations"
HOMEPAGE="https://github.com/QcmPlab/SciFortran"
SRC_URI="https://github.com/QcmPlab/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lapack mpi scalapack"
REQUIRED_USE="scalapack? ( mpi )"

BDEPEND=""
RDEPEND="
	virtual/lapack
	mpi? ( virtual/mpi )
	scalapack? ( sci-libs/scalapack )
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-LAPACK_LIBRARIES-list.patch" )

src_prepare() {
	# Patch scifor pkg-config file
	sed -i -e 's:prefix=@CMAKE_INSTALL_PREFIX@:prefix=/usr:' \
		 -e 's:/lib:/'"$(get_libdir)"':' \
		-e 's:/include:/include/scifor:' etc/scifor.pc.in || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs+=(
		-DPREFIX="/usr"
		-DUSE_MPI="$(usex mpi ON OFF)"
		-DWITH_SCALAPACK="$(usex scalapack ON OFF)"
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install(){
	# Upstream CMakeLists.txt provides rules to install package into user environment
	# with the following run by user the special shell-scripts to update user/global PATH variables.
	# Therefore the direct installation of package files is used instead of cmake_src_install().

	# Install scifor shared library
	dolib.so "${BUILD_DIR}"/libscifor.so

	# Install modules (headers) files
	insinto /usr/include/scifor
	doins -r "${BUILD_DIR}"/include/.

	# Install scifor.pc pkg-config file
	insinto /usr/"$(get_libdir)"/pkgconfig/
	doins "${BUILD_DIR}"/etc/scifor.pc
}

# Known issue:
# * QA Notice: The following files contain writable and executable sections
# *  Files with such sections will not work properly (or at all!) on some
# *  architectures/operating systems.  A bug should be filed at
# *  https://bugs.gentoo.org/ to make sure the issue is fixed.
# *  For more information, see:
# *
# *    https://wiki.gentoo.org/wiki/Hardened/GNU_stack_quickstart
# *
# *  Please include the following list of files in your report:
# *  Note: Bugs should be filed for the respective maintainers
# *  of the package in question and not hardened@gentoo.org.
# * RWX --- --- usr/lib64/libscifor.so
