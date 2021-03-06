# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils git autotools

DESCRIPTION="LV2 dynparam extension"
HOMEPAGE="http://home.gna.org/lv2dynparam/"

EGIT_REPO_URI="git://repo.or.cz/lv2dynparam.git"
ESVN_PROJECT="master"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

S="${WORKDIR}/${PN}"

IUSE=""
DEPEND="|| ( >=media-libs/lv2-1.2.0 >=media-libs/lv2core-1 )
	!media-libs/lv2dynparam"
RDEPEND=""

src_unpack() {
	git_src_unpack
	cd "${S}"
	export WANT_AUTOMAKE="1.10"
	export WANT_AUTOCONF="2.61"
	./bootstrap
}

src_compile() {
	econf || die "Configure failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"
	dodoc README AUTHORS NEWS
}
