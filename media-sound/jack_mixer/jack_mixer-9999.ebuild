# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_DEPEND="2:2.4"
RESTRICT_PYTHON_ABIS="3.*"
inherit eutils gnome2 python git-2 autotools

DESCRIPTION="JACK audio mixer using GTK2 interface."
HOMEPAGE="http://home.gna.org/jackmixer/"
EGIT_REPO_URI="git://repo.or.cz/jack_mixer.git"
SRC_URI=""

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="gconf lash phat"

DEPEND="dev-python/fpconst
	dev-python/pygtk
	>=dev-python/pyxml-0.8.4
	media-sound/jack-audio-connection-kit"
RDEPEND="${DEPEND}
	gconf? ( dev-python/gconf-python:2 )
	lash? ( virtual/liblash[python] )
	phat? ( media-libs/pyphat )"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/missing-gconf-2.m4.patch
	AT_M4DIR="m4" eautoreconf
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	python_convert_shebangs -r 2 "${ED}"
	dosym /usr/bin/jack_mixer.py /usr/bin/jack_mixer
	dodoc AUTHORS NEWS README
}

pkg_postinst() {
	python_mod_optimize "${EPREFIX}/usr/share/${PN}"
	gnome2_pkg_postinst
}

pkg_postrm() {
	python_mod_cleanup "${EPREFIX}/usr/share/${PN}"
	gnome2_pkg_postrm
}
