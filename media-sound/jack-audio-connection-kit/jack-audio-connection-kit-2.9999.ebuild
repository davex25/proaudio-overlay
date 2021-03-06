# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
inherit eutils git-2 python-single-r1 waf-utils

DESCRIPTION="Jackdmp jack implemention for multi-processor machine"
HOMEPAGE="http://jackaudio.org/"

EGIT_REPO_URI="git://github.com/jackaudio/jack2.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa debug doc dbus freebob ieee1394 mixed opus pam"

RDEPEND="media-libs/libsamplerate
	>=media-libs/libsndfile-1.0.0
	alsa? ( >=media-libs/alsa-lib-1.0.24 )
	dbus? ( sys-apps/dbus )
	freebob? ( sys-libs/libfreebob !media-libs/libffado )
	ieee1394? ( media-libs/libffado !sys-libs/libfreebob )
	opus? ( media-libs/opus[custom-modes] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"
RDEPEND="${RDEPEND}
	dbus? ( dev-python/dbus-python )
	pam? ( sys-auth/realtime-base )"

DOCS=( ChangeLog README README_NETJACK2 TODO )

pkg_pretend() {
	if use mixed; then
		ewarn 'You are about to build with "mixed" use flag.'
		ewarn 'The build will probably fail.'
		ewarn 'This is a known issue and a fix is coming eventually.'
	fi
}

src_unpack() {
	git-2_src_unpack
}

src_configure() {
	local mywafconfargs=(
		$(usex alsa --alsa "")
		$(usex dbus --dbus --classic)
		$(usex debug --debug "")
		$(usex freebob --freebob "")
		$(usex ieee1394 --firewire "")
		$(usex mixed --mixed "")
	)

	waf-utils_src_configure ${mywafconfargs[@]}
}

src_compile() {
	waf-utils_src_compile

	if use doc; then
		doxygen || die "doxygen failed"
	fi
}

src_install() {
	use doc && HTML_DOCS=( html/ )
	waf-utils_src_install

	python_fix_shebang "${ED}"
}
