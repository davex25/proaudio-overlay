# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


DESCRIPTION="nekobee, a DSSI TB303 plugin"
HOMEPAGE="http://www.nekosynth.co.uk/wiki/nekobee"
SRC_URI="http://static.nekosynth.co.uk/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="nomirror"

RDEPEND=">=media-libs/dssi-0.9
	>=x11-libs/gtk+-2.0"

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"
}

src_compile() {
	econf || die
	emake || die
}

src_install() {
	einstall || die
	dodoc ChangeLog
	}
