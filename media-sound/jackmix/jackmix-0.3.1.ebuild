# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils qt4

RESTRICT="mirror"
IUSE=""

DESCRIPTION="A mixer app for jack"
HOMEPAGE="http://www.arnoldarts.de/drupal/?q=JackMix%3Aintro"
SRC_URI="http://www.arnoldarts.de/drupal/files/downloads/jackmix/${P}.tar.gz"
S="${WORKDIR}/${PN}-0.3"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="${RDEPEND}
		dev-util/scons
		dev-util/pkgconfig"
RDEPEND="media-sound/jack-audio-connection-kit
	|| ( ( x11-libs/qt-core x11-libs/qt-gui x11-libs/qt-xmlpatterns )
		=x11-libs/qt-4.2*:4 )
		>=media-libs/liblo-0.23"

src_compile() {
	QTDIR=/usr \
	scons configure qtlibs=/usr/lib/qt4 prefix=${D}/usr || die "configure failed"

	scons || die "make failed"
}

src_install() {
	scons install || die
	dodoc AUTHORS ChangeLog
	make_desktop_entry "${PN}" "JackMix" Audio "AudioVideo;Audio;Mixer"
}
