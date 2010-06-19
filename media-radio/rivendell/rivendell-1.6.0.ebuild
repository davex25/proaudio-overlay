# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit base eutils

DESCRIPTION="An automated system for acquisition, management, scheduling and playout of audio content."
HOMEPAGE="http://rivendellaudio.org/"
SRC_URI="http://rivendellaudio.org/ftpdocs/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa jack pam"

RESTRICT="mirror"

DEPEND="alsa? ( media-libs/alsa-lib )
	alsa? ( media-libs/libsamplerate )
	jack? ( media-sound/jack-audio-connection-kit )
	jack? ( media-libs/libsamplerate )
	media-libs/flac
	media-libs/id3lib
	media-libs/libogg
	media-libs/libvorbis
	virtual/mysql
	x11-libs/qt:3[mysql]"
RDEPEND="${DEPEND}
	pam? ( sys-libs/pam )
	app-cdr/cdrkit
	media-sound/cdparanoia
	media-sound/lame
	media-sound/mpg321
	media-sound/vorbis-tools
	net-ftp/lftp
	net-misc/wget"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} "${PN},audio"
}

src_prepare() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${PN}-init.patch"
	epatch "${FILESDIR}/${PN}-sandbox.patch"
}

src_compile() {
	local myconf=""

	use alsa || myconf="${myconf} --disable-alsa"
	use jack || myconf="${myconf} --disable-jack"
	use pam || myconf="${myconf} --disable-pam"

	econf ${myconf}
	emake || die "make failed. If you received an error about missing libogg.la,\
	  run emerge lafilefixer ; lafilefixer --justfixit"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"

	insinto /etc
	doins conf/rd.conf-sample || die "install /etc/rd.conf failed"

	keepdir /var/snd || die "keepdir failed"
	fowners ${PN}:${PN} /var/snd || die "fowners failed"

	dodoc AUTHORS ChangeLog INSTALL NEWS README SupportedCards docs/*.txt || die "install doc failed"
	prepalldocs || die "prepalldocs failed"
}

pkg_postinst() {
	elog "If you would like ASI or GPIO hardware support,"
	elog "install their drivers and re-emerge this package."
	einfo
	einfo "See http://rivendell.tryphon.org/wiki/index.php/Install_under_Gentoo"
	einfo "for Gentoo specific instructions."
	einfo
	ewarn "If ${P} comes as an update, it may use a new database schema, run rdadmin to ensure your schema is current."
}
