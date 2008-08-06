# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit qt4

MY_P="SimpleSysexxer"
DESCRIPTION="a small tool to load, send, receive, save and request sysex data on
MIDI devices"
HOMEPAGE="http://www.christeck.de/pages/simplesysexxer.html"
SRC_URI="http://www.christeck.de/files/SimpleSysexxer.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

S="${WORKDIR}/${MY_P}"

RDEPEND="|| ( ( x11-libs/libX11
						x11-libs/libXext )
						virtual/x11
			)"
DEPEND="${RDEPEND}
		>=media-libs/alsa-lib-1.0.9
		|| ( ( x11-libs/qt-gui )
			>=x11-libs/qt-4.1:4 )"

src_compile() {
	qmake
	emake || die "make failed"
}

src_install() {
	dobin simplesysexxer
	cd "${S}"/DOCUMENTATION
	dodoc AUTHORS CREDITS KNOWNISSUES USAGE
}
