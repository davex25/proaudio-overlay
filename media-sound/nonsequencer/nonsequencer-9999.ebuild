# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git eutils

DESCRIPTION="The Non Sequencer is a powerful real-time, pattern-based MIDI sequencer for Linux."
HOMEPAGE="http://non-sequencer.tuxfamily.org/"
EGIT_REPO_URI="git://git.tuxfamily.org/gitroot/non/sequencer.git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="lash"

DEPEND=">=x11-libs/fltk-1.1.2
	>=dev-libs/libsigc++-2.0
	>=media-sound/jack-audio-connection-kit-0.103
	lash? ( >=media-sound/lash-0.5.4 )"
RDEPEND="${DEPEND}"

src_unpack(){
	git_src_unpack || die "git clone failed."
	cd "${S}"
	epatch "${FILESDIR}/nonsequencer-makefile-fix.patch"
}

src_compile() {
	econf $(use_enable lash) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	fowners root:audio  "${ROOT}"/usr/bin/non-sequencer || die "chown failed"
}
