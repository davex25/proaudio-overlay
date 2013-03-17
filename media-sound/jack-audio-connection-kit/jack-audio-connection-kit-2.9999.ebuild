# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_DEPEND="2"

inherit git-2 waf-utils python

DESCRIPTION="Jackdmp jack implemention for multi-processor machine"
HOMEPAGE="http://www.grame.fr/~letz/jackdmp.html"

EGIT_REPO_URI="git://github.com/jackaudio/jack2.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa classic debug doc dbus freebob ieee1394 mixed opus pam"

RDEPEND="media-libs/libsamplerate
	>=media-libs/libsndfile-1.0.0
	>=media-libs/alsa-lib-1.0.24
	dbus? ( sys-apps/dbus )
	freebob? ( sys-libs/libfreebob !media-libs/libffado )
	ieee1394? ( media-libs/libffado !sys-libs/libfreebob )
	opus? ( media-libs/opus )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"
RDEPEND="${RDEPEND}
	dbus? ( dev-python/dbus-python )
	pam? ( sys-auth/realtime-base )"

src_unpack() {
	git-2_src_unpack
}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_configure() {
	local myconf="--prefix=/usr --destdir=${D}"
	use alsa && myconf="${myconf} --alsa"
	if use classic && use dbus ; then
		myconf="${myconf} --classic"
	fi
	if use mixed && use amd64 ; then
		myconf="${myconf} --mixed"
	fi
	use dbus && myconf="${myconf} --dbus"
	use debug && myconf="${myconf} --debug"
	use freebob && myconf="${myconf} --freebob"
	use ieee1394 && myconf="${myconf} --firewire"

	einfo "Running \"./waf configure ${myconf}\" ..."
	waf-utils_src_configure  ${myconf}
}

src_compile() {
	waf-utils_src_compile
	if use doc ; then
		doxygen || die "doxygen failed"
	fi
}

src_install() {
	waf-utils_src_install
	dodoc ChangeLog README README_NETJACK2 TODO || die "dodoc failed"
	if use doc ; then
		dohtml html/* || die "dohtml failed"
	fi
	python_convert_shebangs -r 2 "${ED}"
}
