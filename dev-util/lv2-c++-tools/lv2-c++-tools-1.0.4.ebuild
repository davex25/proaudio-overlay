# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=1

inherit multilib

DESCRIPTION="some tools and libraries that may come in handy when writing LV2 plugins"
HOMEPAGE="http://ll-plugins.nongnu.org/hacking.html"
SRC_URI="http://download.savannah.nongnu.org/releases/ll-plugins/${P}.tar.bz2"

RESTRICT="mirror"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="doc"

RDEPEND=">=dev-cpp/gtkmm-2.8.8:2.4"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# ar doesn't really like ldflags
	sed -e 's:ar rcs $$@ $$^ $(LDFLAGS) $$($(2)_LDFLAGS):ar rcs $$@ $$^:' \
		-i Makefile.template || die
}

src_compile() {
	./configure \
		--prefix=/usr \
		--CFLAGS="${CFLAGS}" \
		|| die "configure failed"
	emake || die "emake failed"
	if use doc; then
		doxygen || die "making docs failed"
	fi
}

src_install() {
	make DESTDIR="${D}" \
		libdir="/usr/$(get_libdir)" \
		docdir="/usr/share/doc/${PF}" \
		install || die "install failed"
	if use doc; then
		dohtml -r html/*
	fi
}
