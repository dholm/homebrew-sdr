require "formula"

class BrewedPython < Requirement
  fatal true
  satisfy { Tab.for_name("gnuradio").with? "brewed-python" }

  def message; <<-EOS.undent
    If building formula with a brewed Python GNU Radio must be built that way
    too or it will crash on startup.
    EOS
  end
end

class UnbrewedPython < Requirement
  fatal true
  satisfy { not Tab.for_name("gnuradio").with? "brewed-python" }

  def message; <<-EOS.undent
    If GNU Radio was not built with brewed Python this formula can't be built
    using a brewed Python or GNU Radio will crash on startup.
    EOS
  end
end

class GrFosphor < Formula
  homepage "http://sdr.osmocom.org/trac/wiki/fosphor"
  head "git://git.osmocom.org/gr-fosphor"

  option "with-qt", "Build with QT widgets in addition to wxWidgets"
  option "with-brewed-python", "Use the Homebrew version of Python"

  depends_on "cmake" => :build
  depends_on "pyqt" if build.with? "qt"
  depends_on "glfw3"
  depends_on "gnuradio"
  depends_on BrewedPython if build.with? "brewed-python"
  depends_on UnbrewedPython if build.without? "brewed-python"

  def install
    mkdir "build" do
      args = %W[
        -DCMAKE_PREFIX_PATH=#{prefix}
      ]

      if build.with? "qt"
        args << "-DENABLE_QT=ON"
      else
        args << "-DENABLE_QT=OFF"
      end

      if build.with? "brewed-python"
        args << "-DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'"
      end

      system "cmake", "..", *args, *std_cmake_args
      system "make"
      system "make install"
    end
  end
end
