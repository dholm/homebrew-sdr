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

class GrIqbal < Formula
  homepage "http://www.osmocom.org/"
  head "git://git.osmocom.org/gr-iqbal"

  option "with-brewed-python", "Use the Homebrew version of Python"

  depends_on "cmake" => :build
  depends_on "gnuradio"
  depends_on "boost"
  depends_on "fftw"
  depends_on BrewedPython if build.with? "brewed-python"
  depends_on UnbrewedPython if build.without? "brewed-python"

  patch :DATA

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

__END__
--- a/lib/optimize_c.cc	2014-11-29 19:47:42.000000000 +0100
+++ b/lib/optimize_c.cc	2014-11-29 19:48:07.000000000 +0100
@@ -31,7 +31,7 @@
 		__GNUC_PATCHLEVEL__	\
 	)
 
-#if GCC_VERSION >= 40800
+#if GCC_VERSION >= 40800 || defined(__clang__)
 # define complex _Complex
 # undef _GLIBCXX_HAVE_COMPLEX_H
 #endif
