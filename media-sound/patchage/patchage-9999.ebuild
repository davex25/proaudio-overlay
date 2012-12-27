# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Patchage is a modular patchbay for Jack audio and Alsa sequencer."
HOMEPAGE="http://drobilla.net/software/patchage"
SRC_URI=""

LICENSE=""
KEYWORDS=""
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

pkg_postinst() {
	einfo "This ebuild is a fake aimed to satisfy portage dependencies"
	einfo "without creating circular dependencies."
	einfo "Nothing will be installed."
	einfo ""
	elog "To install ${P}, please emerge media-sound/drobilla"
}
