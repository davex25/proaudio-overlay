# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

RESTRICT=mirror

DESCRIPTION="Rakarrack is a richly featured multi-effects processor emulating a uitar effects pedalboard."
HOMEPAGE="http://rakarrack.sourceforge.net/"
SRC_URI="mirror://sourceforge/rakarrack/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"

DEPEND=">=x11-libs/fltk-1.1
	x11-libs/libXpm
	>=media-libs/alsa-lib-0.9
	>=media-sound/alsa-utils-0.9
	>=media-sound/jack-audio-connection-kit-0.100.0"

src_install() {
	make DESTDIR=${D} install || die
}
