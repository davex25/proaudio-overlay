# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit multilib

DESCRIPTION="Tool to measure loudspeaker frequency and step responses and distortions"
HOMEPAGE="http://gaydenko.com/qloud/"
SRC_URI="http://gaydenko.com/qloud/download/${P}.tar.bz2"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 amd64"

DEPEND="|| ( ( x11-libs/qt-core x11-libs/qt-gui x11-libs/qt-xmlpatterns )
		>=x11-libs/qt-4:4 )
	>=x11-libs/qwt-5.0.0_rc0
	media-sound/jack-audio-connection-kit
	>=media-libs/libsndfile-1.0
	>=sci-libs/fftw-3.0"

src_compile() {
	/usr/bin/qmake
	emake || die "Compilation failed"
}

src_install() {
	dobin bin/qloud || die "Binary installation failed"
	dodoc INSTALL COPYING README || die "Doc installation failed"
}
