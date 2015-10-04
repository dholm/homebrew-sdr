require "formula"

class LiquidDsp < Formula
  homepage "http://liquidsdr.org/"
  head "https://github.com/jgaeddert/liquid-dsp.git"
  url "https://github.com/jgaeddert/liquid-dsp/archive/v1.2.0.tar.gz"
  sha1 "79bd76e0844778a16459e8cd8da747c87bd951fd"

  depends_on "fftw"
  head do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end
  stable do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  patch :DATA if build.stable?

  def install
    system "./bootstrap.sh" if build.head?
    system "./reconf" if build.stable?
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end

__END__
diff -aur liquid-dsp-1.2.0.orig/configure.ac liquid-dsp-1.2.0/configure.ac
--- liquid-dsp-1.2.0.orig/configure.ac	2015-10-04 20:21:26.000000000 +0200
+++ liquid-dsp-1.2.0/configure.ac	2015-10-04 20:22:57.000000000 +0200
@@ -158,12 +158,6 @@
 AC_FUNC_MALLOC
 AC_FUNC_REALLOC
 # AC_CHECK_LIB (library, function, [action-if-found], [action-if-not-found], [other-libraries])
-AC_CHECK_LIB([c], [malloc, realloc, free, memset, memmove], [],
-             [AC_MSG_ERROR(Need standard c library!)],
-             [])
-AC_CHECK_LIB([m], [sinf, cosf, expf, cargf, cexpf, crealf, cimagf, sqrtf], [],
-             [AC_MSG_ERROR(Need standard (complex) math library!)],
-             [])
 
 # Check for necessary header files
 AC_CHECK_HEADERS([stdio.h stdlib.h complex.h string.h getopt.h sys/resource.h float.h inttypes.h limits.h stdlib.h string.h unistd.h])
