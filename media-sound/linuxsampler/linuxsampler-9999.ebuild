# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils toolchain-funcs subversion

DESCRIPTION="LinuxSampler is a software audio sampler engine with professional grade features."
HOMEPAGE="http://www.linuxsampler.org/"
ESVN_REPO_URI="https://svn.linuxsampler.org/svn/linuxsampler/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa doc dssi jack lv2 sqlite"

RDEPEND="
	>=media-libs/liblscp-9999
	>=media-libs/libgig-9999
	alsa? ( media-libs/alsa-lib )
	dssi? ( media-libs/dssi )
	jack? ( media-sound/jack-audio-connection-kit )
	lv2? ( media-libs/lv2 )
	sqlite? ( dev-db/sqlite:3 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

pkg_setup() {
	if [ $(gcc-major-version)$(gcc-minor-version) -eq 41 ]; then
		eerror "${PN} will maybe crash a lot with gcc-4.1."
		eerror "You have to upgrade to 4.2 for linuxsampler!"
		die
	fi

	if ! use sqlite; then
		ewarn "sqlite useflag not set. Disabling support for instrument-db!"
	fi
}

src_configure() {
	make -f Makefile.cvs
	local myconf=""

	econf \
		`use_enable alsa alsa-driver` \
		`use_enable jack jack-driver` \
		`use_enable sqlite instruments-db` \
		${myconf} || die "configure failed"
}

src_compile() {
	emake -j1 || die "make failed"

	if use doc; then
		emake docs || die "emake docs failed"
	fi
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog README

	if use doc; then
		dohtml -r doc/html/*
	fi
}
