require "formula"

class GrFosphor < Formula
  homepage "http://sdr.osmocom.org/trac/wiki/fosphor"
  head "git://git.osmocom.org/gr-fosphor"

  option "with-qt", "Build with QT widgets in addition to wxWidgets"

  depends_on "cmake" => :build
  depends_on "pyqt" if build.with? "qt"
  depends_on "glfw3"
  depends_on "gnuradio"

  def install
    mkdir "build" do
      args = %W[
        -DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'
      ] + std_cmake_args
      args << "-DENABLE_QT=ON" if build.with? "qt"

      system "cmake", "..", *args
      system "make install"
    end
  end
end
