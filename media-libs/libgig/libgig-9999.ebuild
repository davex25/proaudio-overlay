# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils subversion

DESCRIPTION="libgig is a C++ library for loading Gigasampler files and DLS (Downloadable Sounds) Level 1/2 files."
HOMEPAGE="http://www.linuxsampler.org/libgig/"
ESVN_REPO_URI="https://svn.linuxsampler.org/svn/libgig/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc"
RDEPEND=">=media-libs/libsndfile-1.0.2
	>=media-libs/audiofile-0.2.3"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_configure() {
	make -f Makefile.cvs
	econf || die "./configure failed"
}

src_compile() {
	emake -j1 || die "make failed"

	if use doc; then
		make docs || die "make docs failed"
	fi
}

src_install() {
	einstall || die "einstall failed"
	dodoc AUTHORS ChangeLog TODO README

	if use doc; then
		mv "${S}/doc/html" "${D}/usr/share/doc/${PF}/"
	fi
}
