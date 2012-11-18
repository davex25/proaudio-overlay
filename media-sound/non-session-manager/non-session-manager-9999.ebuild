# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PYTHON_DEPEND="2"
inherit waf-utils git-2 python

DESCRIPTION="The Non Things: Non-DAW, Non-Mixer, Non-Sequencer and Non-Session-Manager"
HOMEPAGE="http://non.tuxfamily.org"
EGIT_REPO_URI="git://git.tuxfamily.org/gitroot/non/non.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="-debug "

RDEPEND=">=media-sound/jack-audio-connection-kit-0.103.0
	>=media-libs/liblrdf-0.1.0
	>=media-libs/liblo-0.26
	>=dev-libs/libsigc++-2.2.0
	media-sound/non-session-manager
	media-libs/pyliblo"
DEPEND="${RDEPEND}
	x11-libs/ntk
	x11-libs/cairo
	x11-libs/libXft
	media-libs/libpng
	x11-libs/pixman
	x11-libs/libXpm
	virtual/jpeg
	x11-libs/libXinerama
	x11-libs/libxcb"

pkg_setup(){
	python_set_active_version 2
	python_pkg_setup
}

src_configure() {
	if use debug
		then waf-utils_src_configure --project=session-manager --enable-debug
		else waf-utils_src_configure --project=session-manager
	fi
}

src_compile() {
	waf-utils_src_compile
}

src_install() {
	waf-utils_src_install

	# strange, doesn't work in pkg_preinst... who konws?
	# provided by media-libs/pyliblo
	rm "${D}/usr/bin/send_osc" || die
}
