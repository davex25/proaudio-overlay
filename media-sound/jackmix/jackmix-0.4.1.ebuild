# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit exteutils qt4-r2

RESTRICT="mirror"
IUSE=""

DESCRIPTION="A mixer app for jack"
HOMEPAGE="http://www.arnoldarts.de/JackMix%3Aintro"
SRC_URI="http://www.arnoldarts.de/files/jackmix/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-sound/jack-audio-connection-kit
	|| ( ( x11-libs/qt-core x11-libs/qt-gui x11-libs/qt-xmlpatterns )
		>=x11-libs/qt-4.2:4 )
		>=media-libs/liblo-0.23"
DEPEND="${RDEPEND}
		dev-util/scons
		virtual/pkgconfig"

src_prepare() {
	esed_check -i -e "s@\(^env\['CXXFLAGS'\].*\)\"@\1 ${CXXFLAGS}\"@" SConstruct
}

src_compile() {
	tc-export CC CXX
	QTDIR=/usr \
	scons CXXFLAGS="${CXXFLAGS}" qtlibs=/usr/lib/qt4 prefix="${D}"/usr || die "make failed"
}

src_install() {
#	scons install || die
	dobin jackmix/jackmix
	dodoc AUTHORS ChangeLog
	make_desktop_entry "${PN}" "JackMix" Audio "AudioVideo;Audio;Mixer"
}
