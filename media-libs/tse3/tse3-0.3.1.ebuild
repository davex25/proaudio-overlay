# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/tse3/tse3-0.3.0-r1.ebuild,v 1.1 2005/10/30 14:14:21 flameeyes Exp $

inherit eutils libtool autotools
RESTRICT="nomirror"
DESCRIPTION="TSE3 Sequencer library"
HOMEPAGE="http://TSE3.sourceforge.net/"
SRC_URI="mirror://sourceforge/tse3/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="alsa oss arts"

RDEPEND="alsa? ( media-libs/alsa-lib )
	arts? ( kde-base/arts )"

DEPEND="${RDEPEND}
	sys-devel/automake
	sys-devel/autoconf
	sys-devel/libtool"

src_unpack() {
	unpack ${A}

	cd ${S}
	# support 64bit machines properly
	epatch ${FILESDIR}/${PN}-0.2.7-size_t-64bit.patch
	# gcc-4 patch (bug #100708)
	epatch ${FILESDIR}/${PN}-0.2.7-gcc4.patch

	eautoreconf
	elibtoolize
}

src_compile() {
	local myconf=""

	use arts || myconf="${myconf} --without-arts"
	use alsa || myconf="${myconf} --without-alsa"
	use oss || myconf="${myconf} --without-oss"

	econf ${myconf} || die "./configure failed"
	emake -j1 || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}
