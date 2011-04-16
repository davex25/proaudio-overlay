# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit cmake-utils cvs kde

DESCRIPTION="Free Music Instrument Tuner"
HOMEPAGE="http://home.gna.org/fmit/"
#SRC_URI="http://download.gna.org/fmit/${P}.tar.bz2"
ECVS_SERVER="cvs.gna.org:/cvs/fmit"
ECVS_MODULE="${PN}"

LICENSE="GPL-2"
SLOT="3.5"
KEYWORDS=""
IUSE="alsa jack oss portaudio"
need-kde 3.5

DEPEND=">=sci-libs/fftw-3.2.2:3.0
	x11-libs/qt-opengl
	alsa? ( >=media-libs/alsa-lib-1.0.23 )
	jack? ( media-sound/jack-audio-connection-kit )
	portaudio? ( media-libs/portaudio )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_unpack() {
	cvs_src_unpack
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use alsa SOUNDSYSTEM_USE_ALSA)
		$(cmake-utils_use jack SOUNDSYSTEM_USE_JACK)
		$(cmake-utils_use oss SOUNDSYSTEM_USE_OSS)
		$(cmake-utils_use portaudio SOUNDSYSTEM_USE_PORTAUDIO)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc ChangeLog README.txt TODO
}
