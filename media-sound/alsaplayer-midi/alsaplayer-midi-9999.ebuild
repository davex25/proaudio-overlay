# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsaplayer/alsaplayer-0.99.76-r3.ebuild,v 1.6 2006/07/12 22:05:09 agriffis Exp $

inherit eutils subversion # autotools

DESCRIPTION="Midi input plugin for the alsaplayer. It use timidity++ for the output"
HOMEPAGE="http://www.alsaplayer.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

ESVN_REPO_URI="https://svn.sourceforge.net/svnroot/alsaplayer/trunk/midi"

S=${WORKDIR}/${PN}

DEPEND="media-sound/alsaplayer"

RDEPEND="${DEPEND}
	media-sound/timidity++"

src_unpack() {
	subversion_src_unpack

	cd ${S}
	./bootstrap || die "bootstrap failed"
}

src_compile() {
	econf \
		${myconf} \
		--disable-dependency-tracking \
		|| die "econf failed"

	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" docdir="${D}/usr/share/doc/${PF}" install \
		|| die "make install failed"

	dodoc AUTHORS ChangeLog DESIGN README
}
