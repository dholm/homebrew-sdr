require "formula"

class Cubicsdr < Formula
  homepage "https://github.com/cjcliffe/CubicSDR"
  url "https://github.com/cjcliffe/CubicSDR/archive/0.2.0-beta-rc5.tar.gz"
  version "0.2.0b5"
  sha256 "20f9cfeb24717a177b1d57692c54985d16d576fcbed97e9a9415a8bfa9a5510d"
  head "https://github.com/cjcliffe/CubicSDR.git"

  depends_on "cmake" => :build

  depends_on "fftw"
  depends_on "librtlsdr"
  depends_on "liquid-dsp"
  depends_on "pothosware/pothos/soapysdr"
  depends_on "wxwidgets"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"

      libexec.install Dir["x64/*"]
      (bin/"CubicSDR").write <<-EOS.undent
        #!/usr/bin/env bash
        (
            cd #{libexec}
            ./CubicSDR
        )
      EOS
    end
  end
end
