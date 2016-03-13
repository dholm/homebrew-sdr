class GrFosphor < Formula
  homepage "http://sdr.osmocom.org/trac/wiki/fosphor"
  head "git://git.osmocom.org/gr-fosphor"

  option "with-qt", "Build with QT widgets in addition to wxWidgets"

  depends_on "cmake" => :build
  depends_on "pyqt" if build.with? "qt"
  depends_on "freetype"
  depends_on "glfw3"
  depends_on "gnuradio"

  def install
    mkdir "build" do
      ENV.append "LDFLAGS", "-Wl,-undefined,dynamic_lookup"
      # Point Python library to existing path or CMake test will fail.
      args = %W[
        -DCMAKE_SHARED_LINKER_FLAGS='-Wl,-undefined,dynamic_lookup'
        -DPYTHON_LIBRARY='#{HOMEBREW_PREFIX}/lib/libgnuradio-runtime.dylib'
        -DFREETYPE2_INCLUDE_DIR_ftheader='#{Formula["freetype"].include}'
      ] + std_cmake_args
      args << "-DENABLE_QT=ON" if build.with? "qt"

      system "cmake", "..", *args
      system "make", "install"
    end
  end
end
