require "formula"

class Libosmocore < Formula
  homepage "http://bb.osmocom.org/trac/wiki/libosmocore"
  url "http://git.osmocom.org/libosmocore/snapshot/libosmocore-0.9.6.tar.gz"
  sha256 "7accf049891991c6a7b2b98e439cc5c7effe48ce623227745d0c24b4bc3411fc"
  head "git://git.osmocom.org/libosmocore"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "pcsc-lite"
  depends_on "python@2"
  depends_on "talloc"

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
