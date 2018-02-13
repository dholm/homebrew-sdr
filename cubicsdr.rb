require "formula"

class Cubicsdr < Formula
  homepage "https://github.com/cjcliffe/CubicSDR"
  url "https://github.com/cjcliffe/CubicSDR/archive/0.2.3.tar.gz"
  sha256 "b058883a82c466530000ec15aa6c7f690036efb0374ca4da87da441fbd2043cf"
  head "https://github.com/cjcliffe/CubicSDR.git"

  depends_on "cmake" => :build

  depends_on "fftw" => "without-fortran"
  depends_on "librtlsdr"
  depends_on "liquid-dsp"
  depends_on "pothosware/pothos/soapysdr"
  depends_on "wxmac"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"

      libexec.install Dir["x64/*"]
      (bin/"CubicSDR").write <<~EOS
        #!/usr/bin/env bash
        (
            cd #{libexec}
            ./CubicSDR
        )
      EOS
    end
  end
end
