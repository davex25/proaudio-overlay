# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils qt4 autotools

DESCRIPTION="A Qt application to control the JACK Audio Connection Kit and ALSA sequencer connections."
HOMEPAGE="http://qjackctl.sourceforge.net/"
SRC_URI="mirror://sourceforge/qjackctl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="alsa debug jackmidi"

DEPEND="alsa? ( media-libs/alsa-lib )
	$(qt4_min_version 4.1)
	media-sound/jack-audio-connection-kit"

pkg_setup() {
	if use alsa && ! built_with_use --missing true media-libs/alsa-lib midi; then
		eerror ""
		eerror "To be able to build ${CATEGORY}/${PN} with ALSA support you"
		eerror "need to have built media-libs/alsa-lib with midi USE flag."
		die "Missing midi USE flag on media-libs/alsa-lib"
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/${P}.patch"
}

src_compile() {
	unset QTDIR

	econf \
		$(use_enable jackmidi jack-midi) \
		$(use_enable alsa alsa-seq) \
		$(use_enable debug) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "make install failed"

	rm "${D}/usr/share/applications/qjackctl.desktop"

	# Upstream desktop file is invalid, better stick with our for now.
	make_desktop_entry "${PN}" "QjackCtl" "/usr/share/icons/qjackctl.png"

	dodoc README ChangeLog TODO AUTHORS
}
