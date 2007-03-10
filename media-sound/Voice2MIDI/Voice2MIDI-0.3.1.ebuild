# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="CLAM Music Annotator can visualize, check and modify music information extracted from audio"
HOMEPAGE="http://clam.iua.upf.edu/index.html"

SRC_URI="http://clam.iua.upf.edu/download/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="doc"
RESTRICT="nomirror"

DEPEND="dev-util/scons
	media-libs/libclam
    	=x11-libs/qt-3*"
	
RDEPEND="${DEPEND}"

src_compile() {
	# required for scons to "see" intermediate install location
	mkdir -p ${D}/usr
	cd ${S}
	scons clam_prefix=/usr DESTDIR="${D}/usr" install_prefix="${D}/usr" -j2
}

src_install() {
	cd ${S}
	dodir /usr
	scons install || die "scons install failed"
	
	dodoc CHANGES COPYING README
	
	make_desktop_entry ${PN} Voice2MIDI ${PN} \
		"AudioVideo;Audio;Midi;"

}
