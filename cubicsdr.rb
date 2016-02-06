require "formula"

class Cubicsdr < Formula
  homepage "https://github.com/cjcliffe/CubicSDR"
  url "https://github.com/cjcliffe/CubicSDR/archive/v0.1.24-alpha.tar.gz"
  sha256 "5bbcea5f9b6e8b91ac3b5d532ca247ce38285ae434c3c64f62bd032f6c7b994c"
  head "https://github.com/cjcliffe/CubicSDR.git"

  depends_on "cmake" => :build

  depends_on "fftw"
  depends_on "librtlsdr"
  depends_on "liquid-dsp"
  depends_on "soapysdr"
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
