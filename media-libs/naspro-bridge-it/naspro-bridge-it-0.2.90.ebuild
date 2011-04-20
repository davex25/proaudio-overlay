# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="A little helper library to develop insert-your-API-here to LV2 bridges"
HOMEPAGE="http://naspro.atheme.org/naspro-bridge-it/about"
SRC_URI="mirror://sourceforge/naspro/naspro/${PV}/${P}.tar.bz2"
RESTRICT="mirror"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/naspro-core-${PV}
	>=media-libs/lv2core-4.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	econf --disable-dependency-tracking --disable-static || die
}

src_install() {
	make DESTDIR="${D}" install || die
	find "${D}" -name '*.la' -delete || die
	dodoc AUTHORS ChangeLog NEWS README THANKS
}
