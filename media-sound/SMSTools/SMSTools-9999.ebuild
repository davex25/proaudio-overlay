# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion kde

DESCRIPTION="Analyzes, transforms and synthesizes back a given sound using the SMS model."
HOMEPAGE="http://clam.project.org/index.html"

SRC_URI=""
ESVN_REPO_URI="http://clam.project.org/svn/clam/trunk/${PN}"

LICENSE="GPL-2"
SLOT="3.5"
KEYWORDS=""
IUSE=""
RESTRICT="mirror"

DEPEND="dev-util/scons
	dev-util/subversion
	=media-libs/libclam-9999"

need-kde 3.5

DEPEND="${DEPEND}
	media-gfx/imagemagick"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
}

src_configure() {
	einfo "No configure script"
}

src_compile() {
	# required for scons to "see" intermediate install location
	mkdir -p ${D}/usr
	addpredict /usr/share/clam/sconstools

	cd ${S}
	scons clam_prefix=/usr DESTDIR="${D}/usr" install_prefix="${D}/usr" release=yes || die "Build failed"
	convert -resize 48x48 -colors 24 resources/SMSTools-icon.png clam-smstools.xpm || die "Icon convert failed"
}

src_install() {
	cd ${S}
	dodir /usr
	addpredict /usr/share/clam/sconstools

	scons install || die "scons install failed"

	dodoc CHANGES COPYING README || die "doc install failed"
	insinto /usr/share/pixmaps
	doins clam-smstools.xpm || die "icon install failed"
}
