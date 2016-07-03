require "formula"

class LiquidDsp < Formula
  homepage "http://liquidsdr.org/"
  head "https://github.com/jgaeddert/liquid-dsp.git"
  # inspectrum needs a recent version of liquid-dsp and the latest release is from 2012.
  url "https://github.com/jgaeddert/liquid-dsp.git", :revision => "1191179b786703b3af20abf7e1404d91099b335d"

  depends_on "fftw"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./bootstrap.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
