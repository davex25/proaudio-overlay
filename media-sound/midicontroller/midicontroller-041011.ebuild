# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""
RESTRICT="nomirror"

DESCRIPTION="Set MIDI controller values using sliders and buttons."
HOMEPAGE="http://sourceforge.net/projects/midicontrol/"
SRC_URI="mirror://sourceforge/midicontrol/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"

RDEPEND="media-libs/alsa-lib
	>=dev-cpp/libglademm-2.4
	>=dev-cpp/gtkmm-2.4"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	sed -ie "s:/usr/local:/usr:" Makefile
	sed -ie "s:-g -O2:\$(CFLAGS):" Makefile
	emake || die
}

src_install() {
	dobin midicontroller
	insinto /usr/share/${PN}
	doins *.glade
	dodoc README
}

pkg_postinst() {
	einfo
	einfo "Run the program as:"
	einfo "${PN} /path/to/glade-file"
	einfo "(defaults to /usr/share/${PN}/controller.glade)"
	einfo
}