class Inspectrum < Formula
  homepage "https://github.com/miek/inspectrum"
  head "https://github.com/miek/inspectrum.git"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "qt5"
  depends_on "fftw"
  depends_on "liquid-dsp"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
