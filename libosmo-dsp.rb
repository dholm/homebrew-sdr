require "formula"

class LibosmoDsp < Formula
  homepage "http://osmocom.org"
  head "git://git.osmocom.org/libosmo-dsp"

  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
