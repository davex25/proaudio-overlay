# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit autotools-utils

DESCRIPTION="MIDI Arpeggiator w/ JACK Tempo Sync, includes Zonage MIDI splitter/manipulator"
HOMEPAGE="http://sourceforge.net/projects/arpage/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-cpp/gtkmm-2.12:2.4
	dev-cpp/libxmlpp:2.6
	>=media-sound/jack-audio-connection-kit-0.105.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

RESTRICT="mirror"

DOCS=("${S}"/AUTHORS "${S}"/ChangeLog "${S}"/README)

PATCHES=("${FILESDIR}"/${P}-doc.patch
	"${FILESDIR}"/${P}-gcc46.patch
	"${FILESDIR}"/${P}-gcc47.patch)

AUTOTOOLS_AUTORECONF=1

src_install() {
	cd "${S}_build"
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc "${DOCS[@]}"
	doicon "${S}"/src/arpage.png
	doicon "${S}"/src/zonage.png
	make_desktop_entry "${PN}" Arpage "${PN}" "AudioVideo;Audio;Midi;X-Jack"
	make_desktop_entry "zonage" Zonage "zonage" "AudioVideo;Audio;Midi;X-Jack"
}
