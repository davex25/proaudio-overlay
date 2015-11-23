# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python3_4 )

inherit git-2 python-single-r1

DESCRIPTION="Audio plugin host and sampler"
HOMEPAGE="https://github.com/falkTX/Carla"
EGIT_REPO_URI="git://github.com/falkTX/Carla.git"
EGIT_BRANCH="master"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+plugin samplers rtaudio vestige +rdf osc control gtk2 gtk3 qt5 projectm extra_plugins"

DEPEND="
	dev-python/PyQt4[${PYTHON_USEDEP}]
	samplers? (
		media-sound/linuxsampler
		media-sound/fluidsynth )
	rdf? ( dev-python/rdflib[${PYTHON_USEDEP}] )
	osc? (
		media-libs/liblo
		control? (
			media-libs/pyliblo[${PYTHON_USEDEP}]
		)
	)
	plugin? (
		gtk2? ( x11-libs/gtk+:2 )
		gtk3? ( x11-libs/gtk+:3 )
		qt5? ( dev-qt/qtgui:5 )
		projectm? ( media-libs/libprojectm )
		extra_plugins? (
			virtual/opengl
			media-libs/libprojectm
			|| ( x11-libs/ntk x11-libs/fltk )
			>=sci-libs/fftw-3
			dev-libs/mini-xml
			sys-libs/zlib
		)
	)"
RDEPEND="${DEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_compile () {
	make || die
}

src_install () {
	make install \
	PREFIX="/usr" DESTDIR="$D" || die
}
