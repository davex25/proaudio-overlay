# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit waf-utils subversion

RESTRICT="mirror"
DESCRIPTION="A lightweight C library for RDF syntax which supports reading and
writing Turtle and NTriples"
HOMEPAGE="http://drobilla.net/software/serd/"

ESVN_REPO_URI="http://svn.drobilla.net/lad/trunk"
ESVN_PROJECT="svn.drobilla.net"
ESVN_UP_FREQ="1"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug doc"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )
	dev-util/pkgconfig
	dev-lang/python"

src_prepare() {
	# work around ldconfig call causing sandbox violation
	sed -i -e "s/bld.add_post_fun(autowaf.run_ldconfig)//" ${PN}/wscript || die
}

src_configure() {
	cd ${PN}
	tc-export CC CXX CPP AR RANLIB
	waf-utils_src_configure --mandir="/usr/share/man" \
		$(use doc && echo " --build-docs --htmldir=/usr/share/doc/${P}/html") \
		$(use debug && echo "--debug") || die
}

src_compile() {
	cd ${PN}
	waf-utils_src_compile
}

src_install() {
	cd ${PN}
	waf-utils_src_install
	dodoc AUTHORS ChangeLog README
}
