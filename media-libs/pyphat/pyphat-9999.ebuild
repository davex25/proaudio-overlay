# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion autotools

DESCRIPTION="python binding for phat"
HOMEPAGE="https://developper.berlios.de/projects/phat/"

ESVN_REPO_URI="svn://svn.berlios.de/phat/trunk/pyphat"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-*"

S="${WORKDIR}/${PN}"

IUSE=""
DEPEND="=media-libs/phat-9999"

src_unpack() {
	subversion_src_unpack ${A}
	cd ${S}
	chmod +x autogen.sh
	./autogen.sh
}

src_compile() {
	econf || die "Configure failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"
	dodoc README AUTHORS NEWS || die "dodoc failed"
}
