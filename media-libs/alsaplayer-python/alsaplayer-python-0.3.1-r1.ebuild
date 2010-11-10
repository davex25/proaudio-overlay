# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/alsaplayer/alsaplayer-0.99.76-r3.ebuild,v 1.6 2006/07/12 22:05:09 agriffis Exp $

PYTHON_DEPEND="2"

inherit eutils distutils # autotools

MY_P="python"
MY_PN="${MY_P}_alsaplayer"

RESTRICT="mirror"

DESCRIPTION="New Python bindings for Alsaplayer."
HOMEPAGE="http://alsaplayer.sourceforge.net/"
SRC_URI="mirror://sourceforge/alsaplayer/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="x86"
IUSE=""

S=${WORKDIR}/${MY_P}

RDEPEND="media-sound/alsaplayer
	dev-lang/python
	dev-libs/boost"

DEPEND="${RDEPEND}"

src_install() {
#	python setup.py install
	distutils_src_install
}
