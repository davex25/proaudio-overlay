# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/qjackctl/qjackctl-0.3.9.ebuild,v 1.1 2012/05/21 15:24:00 aballier Exp $

EAPI=4

inherit qt4-r2 autotools subversion

DESCRIPTION="A Qt application to control the JACK Audio Connection Kit and ALSA sequencer connections."
HOMEPAGE="http://qjackctl.sourceforge.net/"
ESVN_REPO_URI="https://qjackctl.svn.sourceforge.net/svnroot/${PN}/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="alsa dbus debug portaudio"

RDEPEND="
	>=media-sound/jack-audio-connection-kit-0.109.2
	x11-libs/qt-core:4
	x11-libs/qt-gui:4
	alsa? ( media-libs/alsa-lib )
	dbus? ( x11-libs/qt-dbus:4 )
	portaudio? ( media-libs/portaudio )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

DOCS="AUTHORS ChangeLog README TODO TRANSLATORS"

src_prepare() {
	qt4-r2_src_prepare
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable alsa alsa-seq) \
		$(use_enable dbus) \
		$(use_enable debug) \
		$(use_enable portaudio)

	# Emulate what the Makefile does, so that we can get the correct
	# compiler used.
	eqmake4 ${PN}.pro -o ${PN}.mak
}

src_compile() {
	emake -f ${PN}.mak
	lupdate ${PN}.pro || die "lupdate failed"
}
