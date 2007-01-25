# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

RESTRICT="nomirror"
inherit kde-functions virtualx eutils toolchain-funcs # lash
need-qt 3.2

MY_PN=${PN/museseq/muse}
MY_PV=${PV/a/}
MY_P=${MY_PN/_/}-${PV}

DESCRIPTION="The Linux (midi) MUSic Editor (a sequencer)"
SRC_URI="mirror://sourceforge/lmuse/${MY_P}.tar.gz"
HOMEPAGE="http://www.muse-sequencer.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc x86"
IUSE="lash debug vst"

DEPEND="alsa? ( media-libs/alsa-lib )
	>=media-sound/fluidsynth-1.0.3
	doc? ( app-text/openjade
		   app-doc/doxygen
		   media-gfx/graphviz )
	dev-lang/perl
	>=media-libs/libsndfile-1.0.4
	>=media-libs/libsamplerate-0.1.0
	>=media-sound/jack-audio-connection-kit-0.98.0
	lash? ( >=media-sound/lash-0.5.0 )
	vst? ( >=media-libs/fst-1.7-r5 )"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

src_compile() {
	# check if libfst is valid
	if [ -e "/usr/lib/pkgconfig/libfst.pc"	];then
		egrep -q '1.8|1.7' /usr/lib/pkgconfig/libfst.pc &>/dev/null && \
		eerror "try to update fst: at least to fst-1.8-r3 or uninstall fst
 or just remove /usr/lib/pkgconfig/libfst.pc" && die
	fi	
	use vst && eerror "vst useflag is disabled due segfault"
	USE="${IUSE/\ vst/\ -vst/}"
	./autogen.sh
	export LD="$(tc-getLD)"
	Xeconf \
		"`use_enable lash` \
		`use_enable debug` \
		`use_enable vst` \
		--disable-suid-install --enable-optimize \
		--disable-suid-build" || die "Configure failed"

	emake all || die
}

src_install() {
	make DESTDIR=${D} install || die "install failed"
	dodoc AUTHORS ChangeLog INSTALL NEWS README SECURITY README.*
	mv ${D}/usr/bin/muse ${D}/usr/bin/museseq
}

pkg_postinst() {
	einfo "You must have the realtime module loaded to use MusE 0.8.x"
	einfo "Additionally, configure your Linux Kernel for non-generic"
	einfo "Real Time Clock support enabled or loaded as a module."
	einfo "User must have read/write access to /dev/misc/rtc device."
	einfo "Realtime LSM: http://sourceforge.net/projects/realtime-lsm/"
	einfo
	einfo "If using pam rlimits instead Realtime LSM and you hit this error:"
	einfo "\"RtcTimer::setTimerFreq(): cannot set tick on /dev/rtc: Permission
	denied\""
	einfo "add the following to /etc/sysctl.conf"
	einfo "dev.rtc.max-user-freq = 1024"
	einfo ""
	einfo "to take changes effect immediately, use the command"
	einfo "echo 1024 > /proc/sys/dev/rtc/max-user-freq"

	use vst || ewarn "vst useflag is disabled due segfault"
}

