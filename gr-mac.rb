require "formula"

class GrMac < Formula
  homepage "https://github.com/balint256/gr-mac"
  head "https://github.com/balint256/gr-mac.git"

  depends_on "cmake" => :build
  depends_on "gnuradio"

  def install
    mkdir "build" do
      args = %W[
        -DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'
      ] + std_cmake_args

      system "cmake", "..", *args
      system "make install"
    end
  end
end
