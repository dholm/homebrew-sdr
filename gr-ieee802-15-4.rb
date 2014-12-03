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

class GrIeee802154 < Formula
  homepage "https://github.com/bastibl/gr-ieee802-15-4"
  head "https://github.com/bastibl/gr-ieee802-15-4.git"

  option "with-brewed-python", "Use the Homebrew version of Python"

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "gnuradio"
  depends_on "boost"
  depends_on "cppunit"
  depends_on BrewedPython if build.with? "brewed-python"
  depends_on UnbrewedPython if build.without? "brewed-python"

  def install
    mkdir "build" do
      args = std_cmake_args
      if build.with? "brewed-python"
        args << "-DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'"
      end

      system "cmake", "..", *args
      system "make install"
    end
  end
end
