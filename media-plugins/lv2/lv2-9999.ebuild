# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion eutils

ESVN_REPO_URI="http://svn.drobilla.net/lad/"
ESVN_PROJECT="svn.drobilla.net"

IUSE=""
DESCRIPTION="Collection of lv2 plugins for modular synthesizers."
HOMEPAGE="http://drobilla.net/software"

ESVN_REPO_URI="http://svn.drobilla.net/lad/"
ESVN_PROJECT="svn.drobilla.net"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"

DEPEND=""

src_unpack() {
	subversion_src_unpack || die
	#cd "${S}"
}

src_compile() {
	export WANT_AUTOCONF=2.5
	export WANT_AUTOMAKE=1.9
	./autogen.sh || die

	econf \
		--disable-in-process-engine \
		--without-pic \
		--disable-dssi \
		--disable-lash \
		--disable-ladspa \
		--disable-server \
		--disable-ingen-gtk-client \
		--disable-jack \
		--disable-alsa \
		--disable-lv2 \
		--disable-machina-gui || die "configure failed"

	cd "${S}/${PN}" || die "source for ${PN} not found"
	emake || die
}

src_install() {
	cd "${S}/${PN}" || die "source for ${PN} not found"
	make DESTDIR="${D}" install || die
	dodoc NEWS AUTHORS README ChangeLog
}
