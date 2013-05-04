# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

MY_P="${P/-/_}"

DESCRIPTION="A sound level manager that fades applications in and out based on their profile and window focus"
HOMEPAGE="https://launchpad.net/earcandy"
SRC_URI="https://launchpad.net/${PN}/${PV}/${PV}/+download/${MY_P}.tar.gz"

S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-sound/pulseaudio
	dev-python/ctypesgen[${PYTHON_USEDEP}]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/gconf-python
	dev-python/gst-python[${PYTHON_USEDEP}]
	dev-python/libwnck-python
	dev-python/notify-python[${PYTHON_USEDEP}]
	dev-python/pyalsa
	dev-python/pyalsaaudio
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/pyxml[${PYTHON_USEDEP}]
	gnome-base/libglade"
DEPEND="${RDEPEND}"
