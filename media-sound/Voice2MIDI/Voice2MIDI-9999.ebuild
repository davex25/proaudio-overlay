# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit eutils python subversion qt4

DESCRIPTION="CLAM Voice2MIDI extracts the melody as a MIDI or XML file from monophonic audio files"
HOMEPAGE="http://clam-project.org/index.html"

SRC_URI=""
ESVN_REPO_URI="http://clam-project.org/clam/trunk"
ESVN_PROJECT="clam"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""
RESTRICT="mirror"

PYTHON_DEPEND="2:7"

DEPEND="dev-util/scons
	>=media-libs/libclam-9999
 	|| ( ( x11-libs/qt-core x11-libs/qt-gui 
 		x11-libs/qt-xmlpatterns x11-libs/qt-opengl
 		x11-libs/qt-svg )
 		>=x11-libs/qt-4:4 )"

RDEPEND="${DEPEND}
	media-gfx/imagemagick"

QTDIR=""

S="${WORKDIR}/${PN}"
MY_S="${S}/${PN}"

pkg_setup() {
	if ! has_version x11-libs/qt-opengl && ! built_with_use =x11-libs/qt-4* opengl; then
		eerror "You need to build qt4 with opengl support to have it in ${PN}"
		die "Enabling opengl for $PN requires qt4 to be built with opengl support"
	fi
	if ! has_version x11-libs/qt-qt3support && ! built_with_use =x11-libs/qt-4* qt3support; then
		eerror "You need to build qt4 with qt3support support to have it in ${PN}"
		die "Enabling qt3support for $PN requires qt4 to be built with qt3support support"
	fi

	python_set_active_version 2
}

src_unpack() {
	subversion_src_unpack
}

src_compile() {
	# required for scons to "see" intermediate install location
	mkdir -p ${D}/usr
	addpredict /usr/share/clam/sconstools

	cd ${MY_S} || die
	scons clam_prefix=/usr DESTDIR="${D}/usr" prefix="${D}/usr" release=yes || die "Build failed"
}

src_install() {
	cd ${MY_S}
	dodir /usr
	addpredict /usr/share/clam/sconstools

	scons install || die "scons install failed"

	dodoc CHANGES COPYING README

	make_desktop_entry ${PN} Voice2MIDI ${PN} \
		"AudioVideo;Audio;Midi;"

}
