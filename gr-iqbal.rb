require "formula"

class GrIqbal < Formula
  homepage "http://www.osmocom.org/"
  head "git://git.osmocom.org/gr-iqbal"

  depends_on "cmake" => :build
  depends_on "gnuradio"
  depends_on "boost"
  depends_on "fftw"

  patch :DATA

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
