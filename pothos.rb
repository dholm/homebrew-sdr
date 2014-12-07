require "formula"

class Pothos < Formula
  homepage "http://www.pothosware.com/"
  head "https://github.com/pothosware/pothos.git"

  depends_on "cmake" => :build
  depends_on "qt5"
  depends_on "portaudio"
  depends_on "graphviz"
  depends_on "soapysdr"

  def install
    mkdir "build" do
      args = %W[
        -DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'
        -DENABLE_APACHECONNECTOR=OFF
      ] + std_cmake_args

      system "cmake", "..", *args
      system "make install"
    end
  end
end
