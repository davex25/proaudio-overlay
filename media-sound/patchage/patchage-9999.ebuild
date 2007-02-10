# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion jackmidi

RESTRICT="nomirror"
IUSE="jackmidi lash"
DESCRIPTION="Patchage is a modular patchbay for Jack audio and Alsa sequencer."
HOMEPAGE="http://drobilla.net/software/patchage"

#ECVS_SERVER="cvs.savannah.nongnu.org:/sources/om-synth"
#ECVS_MODULE="patchage"
ESVN_REPO_URI="http://svn.drobilla.net/lad/${PN}"


LICENSE="GPL-2"
KEYWORDS="-*"

DEPEND=">=media-libs/liblo-0.22
	>=media-sound/jack-audio-connection-kit-0.99
	>=dev-libs/libxml2-2.6
	>=dev-cpp/gtkmm-2.4
	>=dev-cpp/libgnomecanvasmm-2.6
	>=dev-cpp/libglademm-2.4.1
	>=media-libs/flowcanvas-0.1.0
	lash? ( media-sound/lash )
	!media-sound/patchage-cvs
	=sys-libs/raul-9999"

#S="${WORKDIR}/${ECVS_MODULE}"

src_compile() {
	use jackmidi && need_jackmidi
	NOCONFIGURE=1 ./autogen.sh
	econf \
		`use_enable jackmidi jack-midi` \
		`use_enable lash` \
		|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS NEWS THANKS ChangeLog
} 
