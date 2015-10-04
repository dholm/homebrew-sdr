require "formula"

class GrSmartnet < Formula
  homepage "https://www.cgran.org/wiki/Smartnet"
  head "https://github.com/robotastic/gr-smartnet.git"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "swig" => :build
  depends_on "gnuradio"
  depends_on "boost"

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
