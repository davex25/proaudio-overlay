# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P="${P}-0.jacklab.1.i586"

DESCRIPTION="a collection of free VST synths"
HOMEPAGE="http://jacklab.net"
SRC_URI="http://ftp4.gwdg.de/pub/linux/suse/apt/SuSE/10.0-i386/RPMS.jacklab/${MY_P}.rpm
		experimental? (	http://www.kjaerhusaudio.com/archives/classic_eq_v104.zip
						http://www.kjaerhusaudio.com/archives/classic_chorus_v128.zip
						http://www.kjaerhusaudio.com/archives/classic_compressor_v117.zip
						http://www.kjaerhusaudio.com/archives/classic_delay_v103.zip
						http://www.kjaerhusaudio.com/archives/classic_flanger_v109.zip
						http://www.kjaerhusaudio.com/archives/classic_master-limiter_v106.zip
						http://www.kjaerhusaudio.com/archives/classic_phaser_v103.zip
						http://www.kjaerhusaudio.com/archives/classic_reverb_v106.zip
						http://www.kjaerhusaudio.com/archives/classic_auto-filter_v101.zip
						http://mda.smartelectronix.com/vst/mdaJX10.zip
						http://www.refx.net/downloads/Claw/Claw_1.0.zip 
						http://bigblueamoeba.com/mirror/greenoak/files/Crystal.zip 
						http://www.fxpansion.com/skunk/fx_dr005_10.zip )"
						# http://www.uv.es/%7Eruizcan/sintes/jg3-k_v1561.zip
						# http://www.uv.es/%7Eruizcan/sintes/cosmogirl2-k_v1011.zip
						
RESTRICT="nomirror"

LICENSE="Other"
SLOT="0"
KEYWORDS="~x86"
IUSE="experimental"

DEPEND=">=media-libs/fst-1.7
		app-arch/rpm2targz"

S="${WORKDIR}"

src_unpack() {
	cd "${S}"
	if use experimental; then
		cd ${DISTDIR}
		for i in `ls *.zip`; do
		cd ${S}
		unpack $i
		done
	fi
	rpm2targz "${DISTDIR}/${MY_P}.rpm" || die "rpm2targz failed"
	tar xzf ${MY_P}.tar.gz || die
}

src_install() {
	dodir /usr/lib/vst
	rm -rf ${S}/usr/lib/vst/MrRay73* ${S}/usr/lib/vst/Stringer* \
			${S}/usr/lib/vst/ORGANized_trio_v30*
	cp -R ${S}/usr/lib/vst/* ${D}/usr/lib/vst
	if use experimental; then
		dodir /usr/lib/vst/experimental
		cp ${S}/*.dll ${D}/usr/lib/vst/experimental
	fi
	dodoc ${FILESDIR}/README
}

pkg_postinst() {
	einfo ""
	einfo "All the .dll's have been installed to /usr/lib/vst"
	einfo "In order to use them with standalone fst just type:"
	einfo ""
	einfo "fst /usr/lib/vst/nameofsomesynth.dll"
	einfo ""
	einfo "You can also use them with some sequencer with fst/vst support"
	einfo "like museseq, lmms-cvs or adour."
	einfo ""
	einfo "For more Details see the README." 
	einfo ""
	
	if use experimental; then
	ewarn ""
	ewarn "WARNING: You have chosen to install some untested VSTs"
	ewarn "The experimental VSTs are pretty much untested and may crash"
	ewarn "your system. USE WITH CARE!"
	ewarn ""
	fi
}

