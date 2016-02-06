require "formula"

class LibosmoDsp < Formula
  homepage "http://osmocom.org"
  url "http://git.osmocom.org/libosmo-dsp/snapshot/libosmo-dsp-0.3.tar.xz"
  sha256 "bad3b544ff5b65c4db486f951258cdaefc0fe2a6b60d497416aec7574931eae5"
  head "git://git.osmocom.org/libosmo-dsp"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "fftw"

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
