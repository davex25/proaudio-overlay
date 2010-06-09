# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="A simple Linux Guitar Amplifier for jack with one input and two outputs"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
HOMEPAGE="http://guitarix.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND="
	>=dev-libs/boost-1.38
	media-libs/ladspa-sdk
	>=media-libs/libsndfile-1.0.17
	>=media-sound/jack-audio-connection-kit-0.109.1
	media-sound/lame
	media-sound/vorbis-tools
	>=x11-libs/gtk+-2.12.0"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

#S="${WORKDIR}/${P}"

src_configure() {
	./waf configure --prefix=/usr/ || die
}

src_compile() {
	./waf build || die
}

src_install() {
	DESTDIR=${D} ./waf install

}
