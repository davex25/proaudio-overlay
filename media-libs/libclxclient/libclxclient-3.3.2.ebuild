# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libclxclient/libclxclient-1.0.1.ebuild,v 1.5 2006/03/06 14:59:01 flameeyes Exp $

IUSE=""

inherit eutils multilib toolchain-funcs

RESTRICT="nomirror"
MY_P="clxclient-${PV}"
MY_A="${MY_P}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="An audio library by Fons Adriaensen <fons.adriaensen@skynet.be>"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${MY_A}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

RDEPEND="|| ( x11-libs/libX11 virtual/x11 )
	>=media-libs/libclthreads-1.1.0"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i 's@\ \(\$(PREFIX)\)@\ \$(DESTDIR\)\1@g' Makefile
}

src_compile() {
	tc-export CC CXX
	emake || die "emake failed"
}

src_install() {
	make CLXCLIENT_LIBDIR="/usr/$(get_libdir)" DESTDIR="${D}" install || die "make install failed"
}
