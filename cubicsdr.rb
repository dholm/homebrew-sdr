require "formula"

class Cubicsdr < Formula
  homepage "https://github.com/cjcliffe/CubicSDR"
  head "https://github.com/cjcliffe/CubicSDR.git"

  depends_on "cmake" => :build
  depends_on "liquid-dsp"
  depends_on "fftw"
  depends_on "librtlsdr"
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
