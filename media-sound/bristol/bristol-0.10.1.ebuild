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
	epatch "${FILESDIR}/${P}-fix_startBristol.patch"
	econf \
		`use_enable alsa` \
		`use_enable jack` \
		`use_enable static` \
		|| die "configure failed"
	
	emake bristoldir=/usr/share/${PN} || die "make failed"
}

src_install() {
	make bristoldir="${D}/usr/share/${PN}" prefix="${D}/usr" install || die "install failed"
	dodoc ChangeLog AUTHORS README NEWS 
}
