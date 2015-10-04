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
      ENV.append "LDFLAGS", "-Wl,-undefined,dynamic_lookup"
      # Point Python library to existing path or CMake test will fail.
      args = %W[
        -DCMAKE_SHARED_LINKER_FLAGS='-Wl,-undefined,dynamic_lookup'
        -DPYTHON_LIBRARY='#{HOMEBREW_PREFIX}/lib/libgnuradio-runtime.dylib'
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
