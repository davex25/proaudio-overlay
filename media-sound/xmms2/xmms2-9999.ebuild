# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Header: $

inherit eutils toolchain-funcs git

DESCRIPTION="X(cross)platform Music Multiplexing System. The new generation of the XMMS player."
HOMEPAGE="http://xmms2.xmms.org"

EGIT_REPO_URI="git://git.xmms.se/xmms2/xmms2-devel.git"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="aac alsa ao asx avahi avcodec cdda clientonly coreaudio curl cpp daap
diskwrite ecore eq fam flac gnome jack lastfm mac mms modplug mp3 mp4 musepack nophonehome ofa oss perl python rss ruby samba shout sid speex vorbis wma xml xspf"

RESTRICT="nomirror"

DEPEND="!clientonly? ( 
		>=dev-db/sqlite-3.3.4
		aac? ( >=media-libs/faad2-2.0 )
		alsa? ( media-libs/alsa-lib )
		ao? ( media-libs/libao )
		avahi? ( net-dns/avahi )
		cdda? ( >=media-libs/libdiscid-0.1.1
			>=media-sound/cdparanoia-3.9.8 )
		curl? ( >=net-misc/curl-7.15.1 
			 	!=net-misc/curl-7.16.1 
			 	!=net-misc/curl-7.16.2 )
		flac? ( media-libs/flac )
		gnome? ( gnome-base/gnome-vfs )
		jack? ( >=media-sound/jack-audio-connection-kit-0.101.1 )
		mms? ( media-video/ffmpeg
			>=media-libs/libmms-0.3 )
		modplug? ( media-libs/libmodplug )
		mp3? ( media-sound/madplay )
		mp4? ( media-video/ffmpeg )
		musepack? ( media-libs/libmpcdec )
		ofa? ( media-libs/libofa )
		rss? ( dev-libs/libxml2 )
		samba? ( net-fs/samba )
		sid? ( media-sound/sidplay
			media-libs/resid )
		speex? ( media-libs/speex )
		vorbis? ( media-libs/libvorbis )
		xml? ( dev-libs/libxml2 )
		xspf? ( dev-libs/libxml2 ) )
	>=dev-lang/python-2.4.3
	>=dev-libs/glib-2.12.9
	cpp? ( >=dev-libs/boost-1.32
			>=sys-devel/gcc-3.4 )
	ecore? ( x11-libs/ecore )
	fam? ( app-admin/gamin )
	perl? ( >=dev-lang/perl-5.8.8 )
	python? ( >=dev-python/pyrex-0.9.5.1 )
	ruby? ( >=dev-lang/ruby-1.8.5 )
	mac? ( media-sound/mac )"

RDEPEND="${DEPEND}"

S=${WORKDIR}/${version}

src_compile() {
	local exc=""
	local excl_pls=""
	local excl_opts=""
	local options="--conf-prefix=/etc --prefix=/usr --destdir=${D}"
	if use clientonly ; then
		exc="--without-xmms2d=1 "
	else 
		for x in avahi cpp:xmmsclient++,xmmsclient++-glib ecore:xmmsclient-ecore fam:medialib-updater nophonehome:et perl python ruby ; do
			use ${x/:*} || excl_opts="${excl_opts},${x/*:}"
		done
		for x in aac:faad alsa ao asx avcodec cdda coreaudio curl daap diskwrite eq:equalizer flac gnome:gnomevfs jack lastfm mac mp3:mad mp4 mms modplug musepack ofa oss rss samba sid speex vorbis xml xspf ; do
			use ${x/:*} || excl_pls="${excl_pls},${x/*:}"
		done
	fi

	if [ ${excl_pls} != "" ]
	then
		options="${options} --without-plugins=${excl_pls:1}"
	fi
	if [ ${excl_opts} != "" ]
	then
		options="${options} --without-optionals=${excl_opts:1}"
	fi
	CC="$(tc-getCC) ${CFLAGS} -fPIC" \
	CXX="$(tc-getCXX) ${CXXFLAGS} -fPIC" \
	LINK="$(tc-getCXX) ${LDFLAGS} -fPIC"

	${S}/waf --nocache ${options} ${exc} configure || die "Configure failed"
	# parallel builds are bad with DrJekyll, it will corrupt your pc-files
	${S}/waf build || die "Build failed"
}

src_install() {
	${S}/waf --destdir=${D} install || die
	dodoc AUTHORS COPYING COPYING.GPL COPYING.LGPL TODO README
}

pkg_postinst() {
	if ! use nophonehome ; then
		einfo ""
		einfo "The phone-home client xmms2-et was activated"
		einfo "This client sends anonymous usage-statistics to the xmms2"
		einfo "developers which may help finding bugs"
		einfo "Enable the nophonehome useflag if you don't like that"
	fi
}
