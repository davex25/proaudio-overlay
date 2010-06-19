# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs
RESTRICT="mirror"
DESCRIPTION="watchdog to ensure a realtime process won't hang the machine"
HOMEPAGE="http://www.notam02.no/arkiv/src/"
SRC_URI="http://www.notam02.no/arkiv/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=gnome-base/libgtop-2.0
		|| ( x11-base/xorg-x11 x11-apps/xmessage )"
RDEPEND=""

src_unpack(){
	unpack "${A}"
	cd "${S}"
	#fix makefile
	sed -i -e 's@gcc@$(CC) $(CFLAGS)@g' -e	's@\@sh.*@@g' \
		-e 's@^[[:blank:]]*which.*@@g'  Makefile
}

src_compile(){
	#CONFIG="-O2 `pkg-config --libs --cflags libgtop-2.0` -Wall -lpthread -DWHICH_WISH=\"`which xmessage`\" -DVERSION=\"$(PV)\""
	#$(tc-getCC) ${CFLAGS} das_watchdog.c -o  ${PN} ${CONFIG} || die "compile failed"
	emake VERSION="${PV}" || die
	gzip -d -c ${FILESDIR}/das_watchdog-init.d.gz > das_watchdog-init.d || die "excracing rc-script"
}

src_install(){
	dosbin ${PN}
	dobin test_rt
	dodoc README
	newinitd ${S}/das_watchdog-init.d ${PN}
}

pkg_postinst(){
	einfo "now add the script to your runlevel"
	einfo "e.g. rc-update add ${PN} default"
	einfo "and maybe you also want to use a realtime-kernel:"
	einfo "\"emerge rt-sources\" or fetch the the"
	einfo "kernel-patch: redhat.com/~mingo/realtime-preempt/"
}
