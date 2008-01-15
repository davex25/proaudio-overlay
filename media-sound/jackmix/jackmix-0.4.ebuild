# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils qt4

RESTRICT="nomirror"
IUSE=""

DESCRIPTION="A mixer app for jack"
HOMEPAGE="http://www.arnoldarts.de/drupal/?q=JackMix%3Aintro"
SRC_URI="http://www.arnoldarts.de/drupal/files/downloads/jackmix/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

DEPEND="${RDEPEND}
		dev-util/scons
		dev-util/pkgconfig"
RDEPEND="media-sound/jack-audio-connection-kit
		$(qt4_min_version 4.2)
		>=media-libs/liblo-0.23"

src_compile() {
	QTDIR=/usr \
	scons qtlibs=/usr/lib/qt4 prefix=${D}/usr || die "make failed"
}

src_install() {
	scons install || die
	dodoc AUTHORS ChangeLog
	make_desktop_entry "${PN}" "JackMix" Audio "AudioVideo;Audio;Mixer"
}
