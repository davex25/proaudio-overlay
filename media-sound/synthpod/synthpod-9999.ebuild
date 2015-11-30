# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils
inherit git-r3

DESCRIPTION="Syntpod"
HOMEPAGE="http://openmusickontrollers.github.io/lv2/synthpod/"
EGIT_REPO_URI="git://github.com/OpenMusicKontrollers/synthpod.git"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="**"
IUSE=""

DEPEND="
	media-libs/alsa-lib
	media-libs/elementary
	media-libs/lilv
	media-libs/lv2
	media-libs/zita-alsa-pcmi
	media-sound/jack-audio-connection-kit
"
RDEPEND="${DEPEND}"
