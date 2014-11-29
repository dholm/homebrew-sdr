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

class GrOsmosdr < Formula
  homepage "http://sdr.osmocom.org/trac/wiki/GrOsmoSDR"
  head "git://git.osmocom.org/gr-osmosdr"

  option "with-brewed-python", "Use the Homebrew version of Python"

  depends_on "cmake" => :build
  depends_on "gnuradio"
  depends_on "gr-iqbal"
  depends_on "rtl-sdr"
  depends_on BrewedPython if build.with? "brewed-python"
  depends_on UnbrewedPython if build.without? "brewed-python"

  def install
    mkdir "build" do
      args = %W[
        -DCMAKE_PREFIX_PATH=#{prefix}
      ]

      if build.with? "brewed-python"
        args << "-DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'"
      end

      system "cmake", "..", *args, *std_cmake_args
      system "make"
      system "make install"
    end
  end
end
