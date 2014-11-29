require "formula"

class GrOsmocore < Formula
  homepage "http://bb.osmocom.org/trac/wiki/libosmocore"
  head "git://git.osmocom.org/libosmocore"

  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "pcsc-lite"
  depends_on "gnuradio"

  patch :DATA

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

__END__
diff --git i/include/osmocom/sim/sim.h w/include/osmocom/sim/sim.h
index 02cdcad..bb4b7d8 100644
--- i/include/osmocom/sim/sim.h
+++ w/include/osmocom/sim/sim.h
@@ -294,7 +294,7 @@ struct osim_card_hdl;
 char *osim_print_sw(const struct osim_card_hdl *ch, uint16_t sw_in);
 
 extern const struct tlv_definition ts102221_fcp_tlv_def;
-const struct value_string ts102221_fcp_vals[14];
+extern const struct value_string ts102221_fcp_vals[14];
 
 /* 11.1.1.3 */
 enum ts102221_fcp_tag {
diff --git i/src/ctrl/Makefile.am w/src/ctrl/Makefile.am
index 610d75c..24d6f6b 100644
--- i/src/ctrl/Makefile.am
+++ w/src/ctrl/Makefile.am
@@ -8,5 +8,5 @@ lib_LTLIBRARIES = libosmoctrl.la
 
 libosmoctrl_la_SOURCES = control_cmd.c control_if.c
 
-libosmoctrl_la_LDFLAGS = $(LTLDFLAGS_OSMOCTRL) -version-info $(LIBVERSION) -no-undefined
+libosmoctrl_la_LDFLAGS = $(LTLDFLAGS_OSMOCTRL) -version-info $(LIBVERSION)
 libosmoctrl_la_LIBADD = $(top_builddir)/src/libosmocore.la
diff --git i/src/macaddr.c w/src/macaddr.c
index 7bc4401..be8599a 100644
--- i/src/macaddr.c
+++ w/src/macaddr.c
@@ -47,7 +47,7 @@ int osmo_macaddr_parse(uint8_t *out, const char *in)
 	return 0;
 }
 
-#if defined(__FreeBSD__)
+#if defined(__FreeBSD__) || defined(__APPLE__)
 #include <sys/socket.h>
 #include <sys/types.h>
 #include <ifaddrs.h>
diff --git i/src/sim/sim_int.h w/src/sim/sim_int.h
index c10c5f0..7024743 100644
--- i/src/sim/sim_int.h
+++ w/src/sim/sim_int.h
@@ -36,6 +36,6 @@ struct osim_reader_ops {
 	int (*transceive)(struct osim_reader_hdl *rh, struct msgb *msg);
 };
 
-const struct osim_reader_ops pcsc_reader_ops;
+extern const struct osim_reader_ops pcsc_reader_ops;
 
 #endif
diff --git i/src/utils.c w/src/utils.c
index 6ece1a8..10a00e9 100644
--- i/src/utils.c
+++ w/src/utils.c
@@ -219,8 +219,7 @@ char *osmo_hexdump_nospc(const unsigned char *buf, int len)
 }
 
 	/* Compat with previous typo to preserve abi */
-char *osmo_osmo_hexdump_nospc(const unsigned char *buf, int len)
-	__attribute__((weak, alias("osmo_hexdump_nospc")));
+char *osmo_osmo_hexdump_nospc(const unsigned char *buf, int len);
 
 #include "../config.h"
 #ifdef HAVE_CTYPE_H
