# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

RESTRICT="mirror"
DESCRIPTION="Seq24 is a loop based MIDI sequencer with focus on live performances."
HOMEPAGE="https://edge.launchpad.net/seq24/"
SRC_URI="http://edge.launchpad.net/seq24/trunk/${PV}/+download/${P}.tar.bz2"

IUSE="jack lash"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="media-libs/alsa-lib
	>=dev-cpp/gtkmm-2.4:2.4
	>=dev-libs/libsigc++-2.2:2
	jack? ( >=media-sound/jack-audio-connection-kit-0.90 )
	lash? ( || ( >=media-sound/lash-0.5 media-sound/ladish ) )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
}
src_prepare() {

	epatch "${FILESDIR}/${P}-lash-fix.diff"
}

src_configure() {
	econf \
		$(use_enable jack) \
		$(use_enable lash) \
		|| die
}

src_compile() {
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README RTC SEQ24
	newicon src/pixmaps/seq24_32.xpm seq24.xpm
	make_desktop_entry "${PN}" "SEQ24" "${PN}" "AudioVideo;Audio;Sequencer"
}
