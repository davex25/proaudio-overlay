# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools wxwidgets flag-o-matic unipatch-001

DESCRIPTION="FFT-based realtime audio spectral manipulation and display"
HOMEPAGE="http://freqtweak.sourceforge.net"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

DEPEND="=x11-libs/wxGTK-2.6*
	>=sci-libs/fftw-3.0
	=dev-libs/libsigc++-1.2*
	dev-libs/libxml2
	media-sound/jack-audio-connection-kit"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	unipatch "${FILESDIR}"/freqtweak-patches-1.tar.bz2
	eautoreconf
}

src_compile() {
	WX_GTK_VER="2.6"
	need-wxwidgets gtk2

	append-flags -fno-strict-aliasing

	econf \
		--with-wxconfig-path=${WX_CONFIG} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS
}
