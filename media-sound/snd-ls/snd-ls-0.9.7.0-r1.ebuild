# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""

#inherit multilib

RESTRICT=nomirror
DESCRIPTION="Snd is a sound editor"
HOMEPAGE="http://ccrma.stanford.edu/~kjetil/"
SRC_URI="http://ccrma.stanford.edu/~kjetil/src/${P}.tar.gz"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND=">=dev-scheme/guile-1.6.7
	>=x11-libs/gtk+-2.0.0
	media-libs/liblrdf"

RDEPEND="${DEPEND}
    sci-libs/gsl
	sci-libs/fftw
	media-sound/jack-audio-connection-kit
	media-libs/ladspa-sdk
	media-libs/libsamplerate
	=sci-libs/fftw-3*"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e 's:\(define\ prefix\)\(.*\):\1 \"\'${D}'/usr/share\"):' config.scm
}

src_compile() {
	./build || die "build failed"
}

src_install () {
	dodoc README 
	dohtml -r snd-8/*.html snd-8/*.png snd-8/tutorial
	rm -f snd-8/*.html snd-8/*.png snd-8/snd.1
	rm -rf snd-8/tutorial
	./install || die "installation failed"
	mv ${D}/usr/share/bin/snd-ls ${S}/
	rm -rf ${D}/usr/share/bin
	sed -i -e 's:'${D}'::g' snd-ls
	dobin snd-ls
	sed -i -e 's:'${D}'::g' ${D}/usr/share/snd-ls/init.scm
}

pkg_postinst() {
	ewarn ""
	ewarn "This version of Snd is very different from the"
	ewarn "one used in Dave Phillips Snd tutorial, so"
	ewarn "reading that one is not useful for this package."
	ewarn "Instead, look in the help menu of the program."
	ewarn ""
	ewarn "First time snd-ls is ran, it will spend some time"
	ewarn "compiling. It will not use the same amount of time"
	ewarn "at next startup"
}
