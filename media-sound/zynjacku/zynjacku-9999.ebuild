# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils subversion autotools

DESCRIPTION="JACK based, GTK (2.x) host for LV2 synths"
HOMEPAGE="http://home.gna.org/zynjacku/"

ESVN_REPO_URI="http://svn.gna.org/svn/zynjacku/code"
ESVN_PROJECT="zynjacku"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

S="${WORKDIR}/${PN}"

IUSE=""
DEPEND="=media-sound/jack-audio-connection-kit-9999
	media-libs/slv2
	>=dev-libs/atk-1.0
	>=media-libs/freetype-2.0
	>=x11-libs/cairo-1.0
	>=x11-libs/pango-1.0
	>=dev-libs/glib-2.0
	>=dev-python/pygtk-2.0
	>=x11-libs/gtk+-2
	>=dev-lang/python-2.4
	=media-libs/lv2dynparam-9999
	>=media-libs/phat-0.4.1
	>=dev-libs/redland-1.0.6"

RDEPEND="${DEPEND}
	>=media-libs/pyphat-9999"

pkg_setup() {
	ewarn "if building fails try the following:"
	ewarn "emerge -O media-libs/slv2 =media-libs/lv2dynparam-9999"
}


src_unpack() {
	subversion_src_unpack ${A}
	cd ${S}
	chmod +x gen_py_constants.py
#	export WANT_AUTOMAKE="1.10"
	./bootstrap
}

src_compile() {
	econf || die "Configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Install failed"
	insinto /usr/lib/zynjacku
	doins zynjacku.so zynjacku.py zynjacku.glade
	fperms +x /usr/lib/zynjacku/zynjacku.py
	dosym /usr/share/zynjacku/gpl.txt /usr/lib/zynjacku/gpl.txt
	dosym /usr/bin/midi_led.py /usr/lib/zynjacku/midi_led.py
	make_wrapper "zynjacku" "/usr/lib/zynjacku/zynjacku.py" "/usr/lib/zynjacku"
#	dodoc README AUTHORS NEWS
}

pkg_postinst() {
	elog "to lauch eg. zynadd type:"
	elog "zynjacku http://home.gna.org/zyn/zynadd/0"
}
