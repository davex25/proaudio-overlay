# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: evermind
# Purpose: share common ebuild code for zynaddsubfx & zynaddsubfx-cvs
#

inherit jackmidi
EXPORT_FUNCTIONS src_compile src_install

LICENSE="GPL-2"
SLOT="0"

#IUSE="oss alsa jack mmx"
IUSE="oss alsa jack jackmidi lash"

DEPEND=">=x11-libs/fltk-1.1.2
	=sci-libs/fftw-3*
    jackmidi?  ( >=media-sound/jack-audio-connection-kit-0.100.0-r3 )
	!jackmidi? ( media-sound/jack-audio-connection-kit )
	>=dev-libs/mini-xml-2.2.1
	lash? ( >=media-sound/lash-0.5 )
	media-libs/zynaddsubfx-banks"
#	portaudio? ( media-libs/portaudio )"

zyn_patches() {
	cd ${S}
	use jackmidi && need_jackmidi
	use jackmidi && use lash && epatch \
		"${FILESDIR}/zyn-lash-and-jackmidi-051205.diff" \
		&& epatch "${FILESDIR}/unzombify.diff"
	use jackmidi && use !lash && epatch	"${FILESDIR}/zyn-jackmidi-051205.diff" 
	use lash && use !jackmidi && epatch "${FILESDIR}/zyn_lash-0.5.0pre0.diff"
}

unpack_examples_presets() {
	cd "${S}"
	mkdir "${WORKDIR}/remove_tmp"
	cd "${WORKDIR}/remove_tmp"
	unpack "ZynAddSubFX-2.2.1.tar.bz2" || die
	cd - &>/dev/null
	[ ! -e "${S}/presets" ] && mv "${WORKDIR}/remove_tmp/ZynAddSubFX-2.2.1/presets" "${S}" # || die "error extracting	presets"
	einfo "examples"
	[ ! -e "${S}/examples" ] && mv "${WORKDIR}/remove_tmp/ZynAddSubFX-2.2.1/examples" "${S}" #|| die "error moving examples"
	rm -rf "${S}/examples/banks" || die "error rm banks"

}

install_examples_presets() {
	[ "${#MY_PN}" == "0" ] && MY_PN="${PN}"

	insinto /usr/share/${MY_PN}/presets
	doins "${S}/presets/"*
	insinto /usr/share/${MY_PN}/examples
	doins "${S}/examples/"*

}

src_compile() {
	local FFTW_VERSION=3
	local ASM_F2I=NO
	local LINUX_MIDIIN=NONE
	local LINUX_AUDIOOUT=NONE
	local LINUX_USE_LASH=NO

	if use oss ; then
		LINUX_MIDIIN=OSS
		LINUX_AUDIOOUT=OSS
		use jack && LINUX_AUDIOOUT=OSS_AND_JACK
	else
		use jack && LINUX_AUDIOOUT=JACK
	fi
	
	use lash && LINUX_USE_LASH=YES

	use jackmidi && LINUX_USE_JACKMIDI=YES
	use alsa && LINUX_MIDIIN=ALSA
#	use portaudio && LINUX_AUDIOOUT=PA
#	use mmx && ASM_F2I=YES

	cd ${S}/src
	make \
		FFTW_VERSION=${FFTW_VERSION} \
		ASM_F2I=${ASM_F2I} \
		LINUX_MIDIIN=${LINUX_MIDIIN} \
		LINUX_AUDIOOUT=${LINUX_AUDIOOUT} \
		LINUX_USE_LASH=${LINUX_USE_LASH} \
		LINUX_USE_JACKMIDI=${LINUX_USE_JACKMIDI} \
		|| die "compile failed"
	cd ${S}/ExternalPrograms/Spliter
	./compile.sh
	cd ${S}/ExternalPrograms/Controller
	./compile.sh
}

src_install() {
	dobin ${S}/src/zynaddsubfx
	dobin ${S}/ExternalPrograms/Spliter/spliter
	dobin ${S}/ExternalPrograms/Controller/controller
	dodoc ChangeLog FAQ.txt HISTORY.txt README.txt ZynAddSubFX.lsm bugs.txt
	install_examples_presets
}

pkg_postinst() {
	einfo "Banks are now provided with the package zynaddsubfx-banks"
	einfo "To get some nice sounding parameters emerge zynaddsubfx-extras"
}
