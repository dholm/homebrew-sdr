class GrIqbal < Formula
  homepage "http://www.osmocom.org/"
  url "http://git.osmocom.org/gr-iqbal/snapshot/gr-iqbal-0.37.2.tar.xz"
  sha256 "933d047e5be51020bc9a15386ddea7870103fb080c249af8aedf2dd4f1b499b2"
  head "git://git.osmocom.org/gr-iqbal"

  depends_on "cmake" => :build

  depends_on "boost"
  depends_on "fftw"
  depends_on "gnuradio"

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
      system "make", "install"
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
