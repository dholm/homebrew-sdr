require "formula"

class Libosmocore < Formula
  homepage "http://bb.osmocom.org/trac/wiki/libosmocore"
  head "git://git.osmocom.org/libosmocore"

  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "pcsc-lite"

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
