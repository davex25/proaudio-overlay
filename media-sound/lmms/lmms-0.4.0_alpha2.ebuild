# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools flag-o-matic

MY_P="${P/_alpha/-alpha}"

DESCRIPTION="free alternative to popular programs such as FruityLoops, Cubase and Logic"
HOMEPAGE="http://lmms.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="alsa debug flac jack ladspa oss pic samplerate sdl singerbot surround stk vorbis vst"

DEPEND="|| ( >=x11-libs/qt-4.3.0 x11-libs/qt-gui )
	vorbis? ( media-libs/libvorbis )
	alsa? ( media-libs/alsa-lib )
	sdl? ( media-libs/libsdl
		>=media-libs/sdl-sound-1.0.1 )
	samplerate? ( media-libs/libsamplerate )
	jack? ( >=media-sound/jack-audio-connection-kit-0.99.0 )
	vst? ( app-emulation/wine )
	ladspa? ( media-libs/ladspa-sdk )
	singerbot? ( app-accessibility/festival )
	stk? ( media-sound/stk )"

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf \
		`use_with alsa asound` \
		`use_with oss` \
		`use_with vorbis` \
		`use_with samplerate libsrc` \
		`use_with sdl` \
		`use_with sdl sdlsound`\
		`use_with jack` \
		`use_with flac` \
		`use_with ladspa` \
		`use_with pic` \
		`use_enable surround` \
		`use_enable debug` \
		`use_with vst` \
		`use_with singerbot` \
		`use_with stk` \
		--enable-hqsinc \
		|| die "Configure failed"

	emake || die "Make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"
	dodoc README AUTHORS ChangeLog TODO || die "dodoc failed"
	newicon "${D}/usr/share/lmms/themes/default/icon.png" "${PN}.png"
}
