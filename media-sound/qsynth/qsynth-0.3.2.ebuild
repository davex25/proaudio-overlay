# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/qsynth/qsynth-0.3.1-r1.ebuild,v 1.6 2007/11/23 12:33:49 armin76 Exp $

inherit qt4 eutils flag-o-matic

DESCRIPTION="A Qt application to control FluidSynth"
HOMEPAGE="http://qsynth.sourceforge.net/"
SRC_URI="mirror://sourceforge/qsynth/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
IUSE="debug jack alsa"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND="$(qt4_min_version 4.2)
	>=media-sound/fluidsynth-1.0.7a"

pkg_setup() {
	if use jack; then
		if ! built_with_use media-sound/fluidsynth jack; then
			eerror "To use Qsynth with JACK, you need to build media-sound/fluidsynth"
			eerror "with the jack USE flag enabled."
			die "Missing jack USE flag on media-sound/fluidsynth"
		fi
		einfo "Enabling default JACK output."
	elif use alsa; then
		if ! built_with_use media-sound/fluidsynth alsa; then
			eerror "To use Qsynth with ALSA, you need to build media-sound/fluidsynth"
			eerror "with the alsa USE flag enabled."
			die "Missing alsa USE flag on media-sound/fluidsynth"
		fi
		einfo "Enabling non-default ALSA output."
	else
		if ! built_with_use media-sound/fluidsynth oss; then
			eerror "If you don't want to use either JACK or ALSA on Qsynth"
			eerror "you need to enable the oss USE flag on media-sound/fluidsynth"
			die "Missing oss USE flag on media-sound/fluidsynth"
		fi
		einfo "Enabling non-default OSS output."
	fi
}

src_compile() {
	append-flags -I/usr/include/qt4
	append-ldflags -L/usr/$(get_libdir)/qt4

	econf \
		$(use_enable debug) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install () {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README TODO

	# The desktop file is invalid, and we also change the command
	# depending on useflags
	rm -rf "${D}/usr/share/applications/qsynth.desktop"

	local cmd
	if use jack; then
		cmd="qsynth"
	elif use alsa; then
		cmd="qsynth -a alsa"
	else
		cmd="qsynth -a oss"
	fi

	make_desktop_entry "${cmd}" Qsynth qsynth
}
