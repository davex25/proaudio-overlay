# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils python qt4-r2

DESCRIPTION="Framework for research and application development in the Audio and Music domain"
HOMEPAGE="http://clam-project.org/"

MY_PN="CLAM"
MY_P="CLAM-${PV}"

SRC_URI="http://clam-project.org/download/src/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc double jack ladspa osc fftw fft alsa optimize vorbis mad portaudio xercesc +xmlpp"
# portmidi"

RESTRICT="mirror"

PYTHON_DEPEND="2:7"

RDEPEND="
	dev-util/cppunit
	virtual/jpeg
	media-libs/libpng
	media-libs/libsndfile
	virtual/opengl
	x11-libs/fltk
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXi
	dev-qt/qtgui:4
	ladspa? ( media-libs/ladspa-sdk )
	xercesc? ( <dev-libs/xerces-c-3 )
	xmlpp? ( dev-cpp/libxmlpp:2.6 )
	fftw? ( sci-libs/fftw:3.0 )
	jack? ( media-sound/jack-audio-connection-kit )
	vorbis? ( media-libs/libvorbis
			  media-libs/libogg )
	mad? ( media-libs/libmad
		   media-libs/id3lib )
	portaudio? ( >=media-libs/portaudio-19 )
	alsa? ( media-libs/alsa-lib )
	osc? ( media-libs/oscpack )"

DEPEND="${RDEPEND}
	dev-util/scons
	app-doc/doxygen"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	python_set_active_version 2
}

src_compile() {
	# required for scons to "see" intermediate install location
	mkdir -p "${D}"/usr

	cd "${S}"

	local myconf="DESTDIR=${D}/usr prefix=/usr prefix_for_packaging=${D}/usr"
	if use double; then
	    myconf="${myconf} double=yes"
	fi
	if use optimize; then
	    myconf="${myconf} optimize_and_lose_precision=yes"
	fi
	if ! use ladspa; then
	    myconf="${myconf} with_ladspa=no"
	fi
	if use osc; then
	    myconf="${myconf} with_osc=yes"
	fi
	if ! use jack; then
	    myconf="${myconf} with_jack=no"
	fi
	if ! use fftw; then
	    myconf="${myconf} with_fftw=no"
	    else
		myconf="${myconf} with_fftw=no with_fftw3=yes"
	fi
	if ! use fft; then
	    myconf="${myconf} with_nr_fft=no"
	fi
	if ! use vorbis; then
	    myconf="${myconf} with_oggvorbis=no"
	fi
	if ! use mad; then
	    myconf="${myconf} with_mad=no"
	    myconf="${myconf} with_id3=no" # workaround buggy buildsys
	fi
	if  use mad; then # was ! use id3 workaround buggy buildsys
	    myconf="${myconf} with_mad=yes"
	    myconf="${myconf} with_id3=yes" # was no
	fi
	if ! use portaudio; then
	    myconf="${myconf} with_portaudio=no"
	fi
	if ! use alsa; then
	    myconf="${myconf} with_alsa=no"
	fi
	if use xercesc; then
		if use xmlpp; then
			myconf+=" xmlbackend=both"
		else
			myconf+=" xmlbackend=xercesc"
		fi
	else
		if use xmlpp; then
			myconf+=" xmlbackend=xmlpp"
		else
			myconf+=" xmlbackend=none"
		fi
	fi
	scons configure ${myconf} || die "configuration failed"
	scons --help
	scons || die "compilation failed"
}

src_install() {
	dodir /usr

	scons install || die "scons install failed"
	dodoc CHANGES

	if use doc; then
		docinto examples/ConfiguratorExample
		dodoc "${S}"/examples/ConfiguratorExample/*
		docinto examples/ControlArrayExamples
		dodoc "${S}"/examples/ControlArrayExamples/*
		docinto examples/FormantTracking
		dodoc "${S}"/examples/FormantTracking/*
		docinto examples/LadspaOSCRemoteController
		dodoc "${S}"/examples/LadspaOSCRemoteController/*
		docinto examples/NetworkLADSPAPlugin
		dodoc "${S}"/examples/NetworkLADSPAPlugin/*
		docinto examples/PluginExample
		dodoc "${S}"/examples/PluginExample/*
		docinto examples/PortsAndControlsUsageExample
		dodoc "${S}"/examples/PortsAndControlsUsageExample/*
		docinto examples/ProcessingClass2Ladspa
		dodoc "${S}"/examples/ProcessingClass2Ladspa/*
		docinto examples/SDIF2Wav
		dodoc "${S}"/examples/SDIF2Wav/*
		docinto examples/SDIF2WavStreaming
		dodoc "${S}"/examples/SDIF2WavStreaming/*
		docinto examples/SDIFToWavStreaming
		dodoc "${S}"/examples/SDIFToWavStreaming/*
		docinto examples/TickExtractor
		dodoc "${S}"/examples/TickExtractor/*
		docinto examples/Tutorial
		dodoc "${S}"/examples/Tutorial/*
		docinto examples/Wav2SDIF
		dodoc "${S}"/examples/Wav2SDIF/*
		docinto examples/loopMaker
		dodoc "${S}"/examples/loopMaker/*
		docinto examples
		dodoc "${S}"/examples/*
	fi
}
