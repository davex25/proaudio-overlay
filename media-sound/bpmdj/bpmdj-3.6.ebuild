# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils qt4

DESCRIPTION="Bpmdj, software for measuring the BPM of music and mixing"
HOMEPAGE="http://bpmdj.sourceforge.net/"
SRC_URI="ftp://bpmdj.yellowcouch.org/${PN}/${P}.source.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE="alsa jack vorbis"

DEPEND="${RDEPEND}
	$(qt4_min_version 4.2)		
	dev-util/pkgconfig"

RDEPEND="alsa? ( media-libs/alsa-lib )
	 vorbis? ( media-sound/vorbis-tools )
	 jack? ( media-sound/jack-audio-connection-kit )
	 =sci-libs/fftw-3*"

src_unpack() {
	unpack ${A}
	cd ${S}

	# add our defines
	cp ${FILESDIR}/defines.gentoo defines

	# and now.. the useflags. What a giant PITA!
	# Note: oss could be optional, but compile fails if disabled!
	local flags=""
	flags="CFLAGS         += -D QT_THREAD_SUPPORT -D QT3_SUPPORT"
	use alsa && flags="${flags} -D COMPILE_ALSA"
	use jack && flags="${flags} -D COMPILE_JACK"
	echo "${flags} -D COMPILE_OSS -D NO_EMPTY_ARRAYS -fPIC" >> defines

	# and the same for LDFLAGS..
	local lflags=""
	lflags="LDFLAGS        += -lpthread -lm -lrt -lfftw3"
	use alsa && lflags="${lflags} -lasound"
	use jack && lflags="${lflags} -ljack"
	echo "${lflags}" >> defines

	# not to forget our custom C(XX)FLAGS
	echo "CPP             = g++ -g ${CXXFLAGS} -Wall" >> defines
}

src_compile() {
	make || die "make failed"
}

src_install () {
	# makefile is absolutly a mess so we use portage features 
	dodoc authors changelog copyright readme todo support.txt
	dodir /usr/$(get_libdir)/${PN}
	exeinto /usr/$(get_libdir)/${PN}
	doexe bpmcount bpmdj bpmdjraw bpmmerge bpmplay
	# needed too..
	mv sequences ${D}/usr/$(get_libdir)/${PN} 
	dodoc authors changelog readme support.txt
	# install startup wrapper
	dobin ${FILESDIR}/${PN}.sh
	# install logo and desktop entry
	doicon ${FILESDIR}/${PN}.png	
	make_desktop_entry "bpmdj.sh" "BpmDj" ${PN} "AudioVideo;Audio"
}
