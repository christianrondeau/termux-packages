TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/gdb/
TERMUX_PKG_DESCRIPTION="The standard GNU Debugger that runs on many Unix-like systems and works for many programming languages"
TERMUX_PKG_DEPENDS="liblzma, libexpat, readline"
TERMUX_PKG_VERSION=7.12.1
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/gdb/gdb-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=4607680b973d3ec92c30ad029f1b7dbde3876869e6b3a117d8a7e90081113186
# gdb can not build with our normal --disable-static: https://sourceware.org/bugzilla/show_bug.cgi?id=15916
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-system-readline --with-curses --enable-static ac_cv_func_getpwent=no ac_cv_func_getpwnam=no"
TERMUX_PKG_RM_AFTER_INSTALL="share/gdb/python share/gdb/syscalls share/gdb/system-gdbinit"
TERMUX_PKG_MAKE_INSTALL_TARGET="-C gdb install"
TERMUX_PKG_BUILD_IN_SRC="yes"

termux_step_pre_configure() {
	# For frexp(3) usage:
	LDFLAGS+=" -lm"

	# Fix "undefined reference to 'rpl_gettimeofday'" when building:
	export gl_cv_func_gettimeofday_clobber=no
	export gl_cv_func_gettimeofday_posix_signature=yes
	export gl_cv_func_realpath_works=yes
	export gl_cv_func_lstat_dereferences_slashed_symlink=yes
	export gl_cv_func_memchr_works=yes
	export gl_cv_func_stat_file_slash=yes
}

termux_step_post_extract_package () {
	if [ $TERMUX_ARCH = aarch64 ]; then
		# Fix problem with <stdlib.h> including <memory.h>:
		mv sim/aarch64/{memory.h,memory_sim.h}
		perl -p -i -e 's/memory.h/memory_sim.h/' $TERMUX_PKG_SRCDIR/sim/aarch64/*c
	fi
}
