# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools eutils findlib

DESCRIPTION="OCaml bindings for alsa."
HOMEPAGE="http://savonet.sourceforge.net/"
SRC_URI="mirror://sourceforge/savonet/${P}.tar.gz"
LICENSE="GPL-2"

IUSE="doc examples"
KEYWORDS="~x86 ~amd64"
SLOT="0"

DEPEND="dev-ml/findlib
		>=dev-lang/ocaml-3.06
		media-libs/alsa-lib
		dev-util/pkgconfig"

RDEPEND="dev-lang/ocaml
		media-libs/alsa-lib"

src_prepare() {
	einfo "Replacing strict tool checks with lazy ones..."
	sed -i 's/AC_CHECK_TOOL_STRICT/AC_CHECK_TOOL/g' m4/ocaml.m4 \
		|| die "Failed editing m4/ocaml.m4!"
	AT_M4DIR="m4" eautoreconf
	eautomake
}

src_compile() {
	emake -j1
}

src_install()
{
	findlib_src_install
	dodoc CHANGES README

	use doc && dohtml -r doc/html/*

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
