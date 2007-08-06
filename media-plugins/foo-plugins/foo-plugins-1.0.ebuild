# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="nomirror"
IUSE=""
DESCRIPTION="foo-plugins for ladspa"
HOMEPAGE="http://www.studionumbersix.com/foo/"
SRC_URI="http://www.studionumbersix.com/foo/${P}.tar.bz2"
LICENSE="GPL"
SLOT="0"
KEYWORDS="x86"

DEPEND="media-libs/ladspa-sdk"

src_install() {
	dodoc AUTHORS README 
	insinto /usr/lib/ladspa
	insopts -m0755
	doins *.so
}
