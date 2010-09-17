# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools subversion

DESCRIPTION="Buzz Machines Loader for Buzztard"
HOMEPAGE="http://www.buzztard.org"
ESVN_REPO_URI="https://buzztard.svn.sourceforge.net/svnroot/buzztard/trunk/${PN}"
SRC_URI=""

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="app-emulation/wine"
RDEPEND="${DEPEND}"

src_configure() {
	myconf="$(use_enable debug)"
	"${S}"/autogen.sh ${myconf} || die "Autogen failed"
}

src_compile() {
	emake -j1 || die "Compilation failed"
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}

## Does it still need? ##
#pkg_postinst() {
#	if use amd64; then
#		echo
#		ewarn "AMD64 users please note that you will not be able to load 32bit"
#		ewarn "machines! To get some native 64bit ones, install	media-plugins/buzzmachines"
#		echo
#	fi
#}
