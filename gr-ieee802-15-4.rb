require "formula"

class GrIeee802154 < Formula
  homepage "https://github.com/bastibl/gr-ieee802-15-4"
  head "https://github.com/bastibl/gr-ieee802-15-4.git"

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "gnuradio"
  depends_on "boost"
  depends_on "cppunit"

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
