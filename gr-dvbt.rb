require "formula"

class GrDvbt < Formula
  homepage "https://github.com/BogdanDIA/gr-dvbt"
  head "https://github.com/BogdanDIA/gr-dvbt.git"

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
