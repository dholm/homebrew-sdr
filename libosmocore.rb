require "formula"

class Libosmocore < Formula
  homepage "http://bb.osmocom.org/trac/wiki/libosmocore"
  url "http://git.osmocom.org/libosmocore/snapshot/libosmocore-0.9.0.tar.gz"
  sha256 "d09489630396941bdb4d123aba1a17595fd3ac9684a7a4874bc14387854bc2b4"
  head "git://git.osmocom.org/libosmocore"

  patch :DATA

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "pcsc-lite"

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end

__END__
diff --git i/src/stats.c w/src/stats.c
index 73b2703..c722ee3 100644
--- i/src/stats.c
+++ w/src/stats.c
@@ -345,7 +345,7 @@ int osmo_stats_reporter_send(struct osmo_stats_reporter *srep, const char *data,
 {
 	int rc;
 
-	rc = sendto(srep->fd, data, data_len, MSG_NOSIGNAL | MSG_DONTWAIT,
+	rc = sendto(srep->fd, data, data_len, MSG_DONTWAIT,
 		&srep->dest_addr, srep->dest_addr_len);
 
 	if (rc == -1)
