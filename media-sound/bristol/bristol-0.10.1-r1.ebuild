# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="nomirror"
IUSE=""

inherit eutils toolchain-funcs

DESCRIPTION="synthesiser emulation package for Moog, Sequential Circuits, Hammond and several other keyboards."
HOMEPAGE="http://sourceforge.net/projects/bristol"
SRC_URI="mirror://sourceforge/bristol/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="alsa jack static"

DEPEND="|| ( (  x11-proto/xineramaproto
					x11-proto/xextproto
					x11-proto/xproto )
				virtual/x11 )
		media-libs/alsa-lib
		jack? ( >=media-sound/jack-audio-connection-kit-0.100 )"
		
src_compile() {
	./configure \
		--prefix=/opt \
		`use_enable alsa` \
		`use_enable jack` \
		`use_enable static` \
		--mandir=/usr/share/man \
		--infodir=/usr/share/infodir \
		--datadir=/usr/share/dir \
		--sysconfdir=/etc \
		--localstatedir=/var/lib \
		|| die "configure failed"
	
	emake || die "make failed"
}

src_install() {
	make prefix="${D}/opt" install || die "install failed"
	dodoc ChangeLog AUTHORS README NEWS 
}
