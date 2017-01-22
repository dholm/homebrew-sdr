class Rtl433 < Formula
  homepage "https://github.com/merbanan/rtl_433/"
  url "https://github.com/merbanan/rtl_433/archive/0.1.tar.gz"
  sha256 "827a3b368a9ed3a3fc744c63459b66d192d26f33a89add2458780412cef82328"
  head "https://github.com/merbanan/rtl_433.git"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "librtlsdr"

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
