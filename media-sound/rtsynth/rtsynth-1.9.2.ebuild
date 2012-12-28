# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE="jack"

inherit eutils

RESTRICT="mirror"
DESCRIPTION="reproduce sounds of strings, organs, flutes and drums in real time"
HOMEPAGE="http://www.linux-sound.org/rtsynth/"
SRC_URI="http://www.audiodef.com/gentoo/src/${P}.tar.bz2"

LICENSE="RTSynth"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=x11-libs/fltk-1.1.2
	media-libs/libsndfile
	|| ( x11-libs/libXext virtual/x11 )
	media-libs/alsa-lib
	jack? ( media-sound/jack-audio-connection-kit )"
DEPEND=""

src_unpack() {
	RTSYNTH_JACK="rtsynth-1.9.1b-jack0.44.0"
	mkdir -p "${S}"
	cd "${S}"
		cp "${DISTDIR}/${P}.tar.bz2" .
		tar xvjpf  "${S}/${P}.tar.bz2" || die "untar failed"
	if use jack ;then
		tar xvzf  "${S}/${RTSYNTH_JACK}.tgz" || die "untar failed"
		mv "${S}/${RTSYNTH_JACK}/RTSynth-jack" "${S}/${P}/" || die "mv failed"
		mv "${S}/${RTSYNTH_JACK}/README" "${S}/${P}/README-jack" || die "mv failed"
	fi
}

src_compile() {
	echo -n
}

src_install() {
	dodir /opt/bin

	insinto "/usr/share/doc/${P}/examples"
	for i in "${S}"/"${P}"/Examples-v192/*;do doins "${i}";done

	if use jack;then
		insinto /opt/bin
		doins "${S}/${P}/RTSynth-jack"
		fperms 755 /opt/bin/RTSynth-jack
		insinto "/usr/share/doc/${P}"
		dodoc "${S}/${P}/README-jack"
		make_desktop_entry RTSynth-jack RTSynth-jack rtsynth "AudioVideo;Audio"
	else
		dobin "${S}/${P}/RTSynth"
		fperms 755 /opt/bin/RTSynth
		make_desktop_entry RTSynth RTSynth rtsynth "AudioVideo;Audio"
	fi

	insinto "/usr/share/doc/${P}"
	dohtml -r "${S}"/"${P}"/HtmlDocs/*
	dodoc "${S}/${P}/Changelog" "${S}/${P}/README"
}
