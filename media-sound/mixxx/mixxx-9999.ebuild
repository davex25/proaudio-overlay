# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit bzr eutils multilib scons-utils toolchain-funcs

DESCRIPTION="A Qt based Digital DJ tool"
HOMEPAGE="http://mixxx.sourceforge.net"
EBZR_REPO_URI="lp:mixxx"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="aac debug doc mp3 mp4 pulseaudio shout wavpack"

RDEPEND="media-libs/fidlib
	media-libs/flac
	media-libs/libid3tag
	media-libs/libogg
	media-libs/libsndfile
	>=media-libs/libsoundtouch-1.5
	media-libs/libvorbis
	>=media-libs/portaudio-19_pre
	media-libs/portmidi
	media-libs/taglib
	virtual/glu
	virtual/opengl
	>=x11-libs/qt-gui-4.6:4
	>=x11-libs/qt-opengl-4.6:4
	>=x11-libs/qt-qt3support-4.6:4
	>=x11-libs/qt-svg-4.6:4
	>=x11-libs/qt-webkit-4.6:4
	>=x11-libs/qt-xmlpatterns-4.6:4
	aac? ( media-libs/faad2 )
	mp3? ( media-libs/libmad )
	mp4? ( media-libs/libmp4v2 )
	pulseaudio? ( media-sound/pulseaudio )
	shout? ( media-libs/libshout )
	wavpack? ( media-sound/wavpack )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${S}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-cflags.patch
	epatch "${FILESDIR}"/${P}-system-libs.patch
	epatch "${FILESDIR}"/${P}-docs.patch
	epatch "${FILESDIR}"/${P}-no-bzr.patch

	# use multilib compatible directory for plugins
	sed -i -e "/unix_lib_path =/s/'lib'/'$(get_libdir)'/" src/SConscript || die

	# alter startup command when pulseaudio support is disabled
	if ! use pulseaudio ; then
		sed -i -e 's:pasuspender ::' src/mixxx.desktop || die
	fi
}

src_compile() {
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LINKFLAGS="${LDFLAGS}" \
	LIBPATH="/usr/$(get_libdir)" escons \
		prefix=/usr \
		qtdir=/usr/$(get_libdir)/qt4 \
		hifieq=1 \
		vinylcontrol=1 \
		optimize=0 \
		$(use_scons aac faad) \
		$(use_scons debug qdebug) \
		$(use_scons mp3 mad) \
		$(use_scons mp4 m4a) \
		$(use_scons shout shoutcast) \
		$(use_scons wavpack wv)
}

src_install() {
	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LINKFLAGS="${LDFLAGS}" \
	LIBPATH="/usr/$(get_libdir)" escons install \
		prefix=/usr \
		install_root="${D}"/usr

	dodoc README Mixxx-Manual.pdf
}
