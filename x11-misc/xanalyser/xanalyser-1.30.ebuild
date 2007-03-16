# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
RESTRICT="nomirror"

DESCRIPTION="Program to analyse a stereo audio signal."
HOMEPAGE="http://arvin.schnell-web.net/xanalyser/"
SRC_URI="http://arvin.schnell-web.net/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE=""

DEPEND="virtual/motif
	sci-libs/fftw
	x11-base/xorg-x11
	media-libs/alsa-lib"

RDEPEND="${DEPEND}"

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS VERSION
	make_desktop_entry "xanalyser -device plughw:1,0" "xanalyser" \
	    ${PN} "AudioVideo;Audio"
}
