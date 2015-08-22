require "formula"

class GrGsm < Formula
  homepage "https://github.com/ptrkrysik/gr-gsm"
  head "https://github.com/ptrkrysik/gr-gsm.git"

  patch :DATA

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "gnuradio"

  def install
    mkdir "build" do
      args = %W[
        -DPYTHON_LIBRARY='#{%x(python-config --prefix).chomp}/lib/libpython2.7.dylib'
      ] + std_cmake_args

      ENV.deparallelize
      system "cmake", "..", *args
      system "make install"
    end
  end
end

__END__
--- i/lib/misc_utils/extract_immediate_assignment_impl.cc
+++ w/lib/misc_utils/extract_immediate_assignment_impl.cc
@@ -28,7 +28,7 @@
 #include <grgsm/gsmtap.h>
 #include <unistd.h>
 #include <map>
-#include <endian.h>
+#include <grgsm/endian.h>
 #include <boost/foreach.hpp>
 
 #include "extract_immediate_assignment_impl.h"
--- i/lib/misc_utils/extract_system_info_impl.cc
+++ w/lib/misc_utils/extract_system_info_impl.cc
@@ -31,7 +31,7 @@
 #include <iterator>
 #include <algorithm>
 #include <iostream>
-#include <endian.h>
+#include <grgsm/endian.h>
 #include <boost/foreach.hpp>
 extern "C" {
     #include <osmocom/gsm/gsm48_ie.h>
