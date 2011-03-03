# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PYTHON_DEPEND="2:2.4"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit python distutils

DESCRIPTION="pyliblo is a Python wrapper for the liblo OSC library"
HOMEPAGE="http://das.nasophon.de/pyliblo/"
SRC_URI="http://das.nasophon.de/download/${P}.tar.gz"

RESTRICT="mirror"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND=">=media-libs/liblo-0.24"
DEPEND="${RDEPEND}
	>=dev-python/cython-0.12"
