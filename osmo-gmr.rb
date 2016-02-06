require "formula"

class OsmoGmr < Formula
  homepage "http://osmocom.org"
  url "http://cgit.osmocom.org/osmo-gmr/snapshot/osmo-gmr-0.2.tar.xz"
  sha256 "40af2bacbc5ec4529f0894097ffce748e6bea551af81e21cadc9b5169c91735d"
  head "git://git.osmocom.org/osmo-gmr"

  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "libosmocore"
  depends_on "libosmo-dsp"

  def install
    inreplace "configure.ac" do |s|
      s.gsub! "libosmocore >= 0.4.1", "libosmocore"
    end

    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
