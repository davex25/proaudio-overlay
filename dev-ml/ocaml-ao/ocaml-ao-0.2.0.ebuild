# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils findlib

DESCRIPTION="OCaml interface to libao."
HOMEPAGE="http://savonet.sourceforge.net/"
SRC_URI="mirror://sourceforge/savonet/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="examples"

RDEPEND="dev-lang/ocaml
		 media-libs/libao"
DEPEND="${RDEPEND}
		dev-ml/findlib
		virtual/pkgconfig"

src_compile() {
	emake -j1
}

src_install()
{
	findlib_src_install
	dodoc CHANGES README

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
