# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit exteutils

DESCRIPTION="Simple BPM detection utility"
HOMEPAGE="http://kde-apps.org/content/show.php/BPM+Detect?content=43147"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kde"

DEPEND=">=dev-util/scons-0.96.1
		>=dev-util/pkgconfig-0.9
		x11-libs/qt:3"
RDEPEND=">=media-libs/fmod-4.06.01
		media-libs/id3lib
		media-libs/libsoundtouch
		>=media-libs/taglib-1.4
		x11-libs/qt:3
		kde? ( =kde-base/kdelibs-3.5* )"

S="${WORKDIR}/${PN}"

src_compile() {
	local myconf=""
	myconf="qtincludes=/usr/qt3/include"

	use kde && myconf="${myconf}  kdeinclude=/usr/kde/3.5/include"
	use amd64 && myconf="${myconf} libsuffix=64"

	escons configure ${myconf} || die "scons configure failed"
	escons || die "scons failed"
}

src_install() {
	DESTDIR="${D}" escons install || die "scons install failed"
	dodoc ChangeLog AUTHORS NEWS TODO README
}
