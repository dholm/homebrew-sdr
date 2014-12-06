require "formula"

class GrDrm < Formula
  homepage "https://github.com/kit-cel/gr-drm"
  head "https://github.com/kit-cel/gr-drm.git"

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "gnuradio"
  depends_on "boost"
  depends_on "cppunit"
  depends_on "faac"
  depends_on "faad2"

  def install
    mkdir "build" do
      args = %W[
        -DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'
      ] + std_cmake_args

      system "cmake", "../gr-drm", *args
      system "make install"
    end
  end
end
