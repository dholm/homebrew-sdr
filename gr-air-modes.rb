require "formula"

class GrAirModes < Formula
  homepage "https://github.com/bistromath/gr-air-modes"
  head "https://github.com/bistromath/gr-air-modes.git"

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "gnuradio"
  depends_on "gr-osmosdr"
  depends_on "sqlite"

  def install
    mkdir "build" do
      args = %W[
        -DCMAKE_PREFIX_PATH=#{prefix}
        -DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'
      ] + std_cmake_args

      system "cmake", "..", *args
      system "make install"
    end
  end
end
