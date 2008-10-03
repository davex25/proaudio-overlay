# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit flag-o-matic eutils multilib subversion linux-info autotools unipatch-001

NETJACK="netjack-0.12"
JACKDBUS="jackdbus-patches-0.12.tar.bz2"

RESTRICT="nostrip nomirror"
DESCRIPTION="A low-latency audio server"
HOMEPAGE="http://www.jackaudio.org"
SRC_URI="
    netjack? ( mirror://sourceforge/netjack/${NETJACK}.tar.bz2 )
	!jackdmp? (
	dbus? ( http://download.tuxfamily.org/proaudio/distfiles/${JACKDBUS} )
	)"

ESVN_REPO_URI="http://subversion.jackaudio.org/jack/trunk/jack"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="3dnow altivec alsa caps coreaudio cpudetection dbus doc debug jack-tmpfs
mmx oss portaudio sse netjack freebob ieee1394 jackdmp"

RDEPEND="jackdmp? ( >=media-sound/jackdmp-9999-r1 )
	!jackdmp? ( 
	>=media-libs/libsndfile-1.0.0
	sys-libs/ncurses
	caps? ( sys-libs/libcap )
	portaudio? ( =media-libs/portaudio-18* )
	alsa? ( >=media-libs/alsa-lib-0.9.1 )
    dbus? ( sys-apps/dbus
		dev-python/dbus-python )
	freebob? ( sys-libs/libfreebob !media-libs/libffado )
	ieee1394? ( =media-libs/libffado-9999 !sys-libs/libfreebob )
	!media-sound/jackdmp )"

DEPEND="${RDEPEND}
	!jackdmp? ( 
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )
	netjack? ( dev-util/scons )
	)"

pkg_setup() {
	if use jackdmp; then
		ewarn "You have enabled the jackdmp useflag. This ebuild will just pull"
		ewarn "in jackdmp and will NOT compile and install ${PN}!"
		sleep 3
		return # no more to do
	fi

	if use caps; then
		if kernel_is 2 4 ; then
			einfo "will build jackstart for 2.4 kernel"
		else
			einfo "using compatibility symlink for jackstart"
		fi
	fi

	if use netjack; then
		einfo "including support for experimental netjack, see http://netjack.sourceforge.net/"
	fi
}

src_unpack() {
	if use jackdmp; then
		einfo "You requested to install jackdmp. Nothing to do"
		return # no more to do
	fi
	use netjack && unpack ${A}
	subversion_src_unpack

	cd "${S}"
	# jack transport patch from Torben Hohn
	epatch "${FILESDIR}/jack-transport-start-at-zero-fix.diff"
	
	# dbus patches from Nedko Arnaudov
	if use dbus; then
		UNIPATCH_LIST="${DISTDIR}/${JACKDBUS}"
		unipatch
	fi

	sed -i -e "s:include/nptl/:include/:g" configure.ac || die
	eautoreconf
}

src_compile() {
	if use jackdmp; then
		einfo "You requested to install jackdmp. Nothing to do"
		return # no more to do
	fi

	local myconf

	sed -i "s/^CFLAGS=\$JACK_CFLAGS/CFLAGS=\"\$JACK_CFLAGS $(get-flag -march)\"/" configure

	use doc && myconf="--with-html-dir=/usr/share/doc/${PF}"

	if use jack-tmpfs; then
		myconf="${myconf} --with-default-tmpdir=/dev/shm"
	else
		myconf="${myconf} --with-default-tmpdir=/var/run/jack"
	fi

	if use dbus; then
		myconf="${myconf} --enable-dbus --enable-pkg-config-dbus-service-dir"
	fi

	if [[ ${CHOST} == *-darwin* ]] ; then
		append-flags -fno-common
		use altivec && append-flags -force_cpusubtype_ALL \
			-maltivec -mabi=altivec -mhard-float -mpowerpc-gfxopt
	fi

	# CPU Detection (dynsimd) uses asm routines which requires 3dnow, mmx and sse.
	# Also, without -O2 it will not compile as well.
	# we test if it is present before enabling the configure flag.
	if use cpudetection ; then
		if (! grep 3dnow /proc/cpuinfo >/dev/null) ; then
			ewarn "Can't build cpudetection (dynsimd) without cpu 3dnow support. see bug #136565."
		elif (! grep sse /proc/cpuinfo >/dev/null) ; then
			ewarn "Can't build cpudetection (dynsimd) without cpu sse support. see bug #136565."
		elif (! grep mmx /proc/cpuinfo >/dev/null) ; then
			ewarn "Can't build cpudetection (dynsimd) without cpu mmx support. see bug #136565."
		else
			einfo "Enabling cpudetection (dynsimd). Adding -mmmx, -msse, -m3dnow and -O2 to CFLAGS."
			myconf="${myconf} --enable-dynsimd"

			filter-flags -O*
			append-flags -mmmx -msse -m3dnow -O2
		fi
	fi

	econf \
		$(use_enable ieee1394 firewire) \
		$(use_enable freebob) \
		$(use_enable altivec) \
		$(use_enable alsa) \
		$(use_enable caps capabilities) $(use_enable caps stripped-jackd) \
		$(use_enable coreaudio) \
		$(use_enable debug) \
		$(use_enable doc html-docs) \
		$(use_enable mmx) \
		$(use_enable oss) \
		$(use_enable portaudio) \
		$(use_enable sse)  \
		$(use_enable 3dnow dynsimd) \
		--disable-dependency-tracking \
		${myconf} || die "configure failed"
	emake || die "compilation failed"

	if use caps && kernel_is 2 4 ; then
		einfo "Building jackstart for 2.4 kernel"
		cd "${S}"/jackd
		emake jackstart || die "jackstart build failed."
	fi

	if use netjack; then
		cd "${WORKDIR}/${NETJACK}"
		scons jack_source_dir="${S}"
	fi

}

src_install() {
	if use jackdmp; then
		einfo "You requested to install jackdmp. Nothing to do"
		return # no more to do
	fi

	emake DESTDIR="${D}" install || die "install failed"

	if use caps; then
		if kernel_is 2 4 ; then
			cd "${S}/jackd"
			dobin jackstart
		else
			dosym /usr/bin/jackd /usr/bin/jackstart
		fi
	fi

	if ! use jack-tmpfs; then
		keepdir /var/run/jack
		chmod 4777 ${D}/var/run/jack
	fi

	if use doc; then
		mv ${D}/usr/share/doc/${PF}/reference/html \
		   ${D}/usr/share/doc/${PF}/

		insinto /usr/share/doc/${PF}
		doins -r "${S}/example-clients"
	else
		rm -rf ${D}/usr/share/doc
	fi

	rm -rf ${D}/usr/share/doc/${PF}/reference

	if use netjack; then
		cd "${WORKDIR}/${NETJACK}"
		dobin alsa_in
		dobin alsa_out
		dobin jacknet_client
		insinto /usr/$(get_libdir)/jack
		doins jack_net.so
	fi
}
