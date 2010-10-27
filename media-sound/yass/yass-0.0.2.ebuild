# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils toolchain-funcs

DESCRIPTION="Yet Another Scrolling Scope features jack input, variable scrolling speed and automatic gain control"
HOMEPAGE="http://www.kokkinizita.net/linuxaudio/"
SRC_URI="http://www.kokkinizita.net/linuxaudio/downloads/${P}.tar.bz2"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=media-libs/libclthreads-2.2.1
	>=media-libs/libclxclient-3.3.1
	media-sound/jack-audio-connection-kit"
RDEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	tc-export CXX
	emake PREFIX=/usr || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" PREFIX=/usr install || die "make install failed"
	dodoc AUTHORS README
}
