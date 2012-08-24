# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils toolchain-funcs

DESCRIPTION="A jack multichannel audio level meter app featuring correct ballistics for both the VU and the PPM"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${P}.tar.bz2"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/libclthreads-2.2.1
	>=media-libs/libclxclient-3.3.2
	media-sound/jack-audio-connection-kit"
RDEPEND="${RDEPEND}"

S="${WORKDIR}/${P}/source"

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	CXX="$(tc-getCXX)" emake PREFIX="${EPREFIX}/usr" || die "emake failed"
}

src_install() {
	emake DESTDIR="${ED}" PREFIX="${EPREFIX}/usr" install || \
		die "make install failed"
	cd ..
	dodoc AUTHORS README
}
