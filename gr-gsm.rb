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

      system "cmake", "..", *args
      system "make install"
    end
  end
end

__END__
--- a/cmake/Modules/FindGnuradioRuntime.cmake
+++ b/cmake/Modules/FindGnuradioRuntime.cmake
@@ -16,7 +16,33 @@ if(PC_GNURADIO_RUNTIME_FOUND)
   # look for libs
   FIND_LIBRARY(
     GNURADIO_RUNTIME_LIBRARIES
-    NAMES gnuradio-runtime
+    NAMES gnuradio-runtime gnuradio-pmt
+    HINTS $ENV{GNURADIO_RUNTIME_DIR}/lib
+          ${PC_GNURADIO_RUNTIME_LIBDIR}
+          ${CMAKE_INSTALL_PREFIX}/lib/
+          ${CMAKE_INSTALL_PREFIX}/lib64/
+    PATHS /usr/local/lib
+          /usr/local/lib64
+          /usr/lib
+          /usr/lib64
+    )
+
+  FIND_LIBRARY(
+    GNURADIO_PMT_LIBRARIES
+    NAMES gnuradio-pmt
+    HINTS $ENV{GNURADIO_RUNTIME_DIR}/lib
+          ${PC_GNURADIO_RUNTIME_LIBDIR}
+          ${CMAKE_INSTALL_PREFIX}/lib/
+          ${CMAKE_INSTALL_PREFIX}/lib64/
+    PATHS /usr/local/lib
+          /usr/local/lib64
+          /usr/lib
+          /usr/lib64
+    )
+
+  FIND_LIBRARY(
+    VOLK_LIBRARIES
+    NAMES volk
     HINTS $ENV{GNURADIO_RUNTIME_DIR}/lib
           ${PC_GNURADIO_RUNTIME_LIBDIR}
           ${CMAKE_INSTALL_PREFIX}/lib/
@@ -32,5 +58,7 @@ endif(PC_GNURADIO_RUNTIME_FOUND)
 
 INCLUDE(FindPackageHandleStandardArgs)
 # do not check GNURADIO_RUNTIME_INCLUDE_DIRS, is not set when default include path us used.
-FIND_PACKAGE_HANDLE_STANDARD_ARGS(GNURADIO_RUNTIME DEFAULT_MSG GNURADIO_RUNTIME_LIBRARIES)
-MARK_AS_ADVANCED(GNURADIO_RUNTIME_LIBRARIES GNURADIO_RUNTIME_INCLUDE_DIRS)
+FIND_PACKAGE_HANDLE_STANDARD_ARGS(GNURADIO_RUNTIME DEFAULT_MSG
+  GNURADIO_RUNTIME_LIBRARIES GNURADIO_PMT_LIBRARIES VOLK_LIBRARIES)
+MARK_AS_ADVANCED(GNURADIO_RUNTIME_LIBRARIES GNURADIO_PMT_LIBRARIES
+  VOLK_LIBRARIES GNURADIO_RUNTIME_INCLUDE_DIRS)
--- /dev/null
+++ b/include/gsm/endian.h
@@ -0,0 +1,15 @@
+#ifndef GSM_ENDIAN_H
+#define GSM_ENDIAN_H
+
+#if defined(__linux__)
+#  include <endian.h>
+#elif defined(__APPLE__)
+#  include <libkern/OSByteOrder.h>
+
+#  define htobe16(x) OSSwapHostToBigInt16(x)
+#  define htobe32(x) OSSwapHostToBigInt32(x)
+
+#  define be32toh(x) OSSwapBigToHostInt32(x)
+#endif
+
+#endif /* GSM_ENDIAN_H */
--- a/lib/CMakeLists.txt
+++ b/lib/CMakeLists.txt
@@ -42,7 +42,8 @@ list(APPEND gsm_sources
 )
 
 add_library(gnuradio-gsm SHARED ${gsm_sources})
-target_link_libraries(gnuradio-gsm ${Boost_LIBRARIES} ${GNURADIO_RUNTIME_LIBRARIES}  
+target_link_libraries(gnuradio-gsm ${Boost_LIBRARIES}
+  ${GNURADIO_RUNTIME_LIBRARIES} ${GNURADIO_PMT_LIBRARIES} ${VOLK_LIBRARIES}
     boost_iostreams
     boost_system
     boost_filesystem
--- a/lib/demapping/get_bcch_or_ccch_bursts_impl.cc
+++ b/lib/demapping/get_bcch_or_ccch_bursts_impl.cc
@@ -23,6 +23,7 @@
 #endif
 
 #include <gnuradio/io_signature.h>
+#include <gsm/endian.h>
 #include <gsm/gsmtap.h>
 #include "get_bcch_or_ccch_bursts_impl.h"
 
--- a/lib/demapping/universal_ctrl_chans_demapper_impl.cc
+++ b/lib/demapping/universal_ctrl_chans_demapper_impl.cc
@@ -24,6 +24,7 @@
 
 #include <gnuradio/io_signature.h>
 #include "universal_ctrl_chans_demapper_impl.h"
+#include <gsm/endian.h>
 #include <gsm/gsmtap.h>
 
 namespace gr {
--- a/lib/receiver/receiver_impl.cc
+++ b/lib/receiver/receiver_impl.cc
@@ -38,6 +38,7 @@
 #include <iomanip>
 #include <assert.h>
 #include <boost/scoped_ptr.hpp>
+#include <gsm/endian.h>
 
 //files included for debuging
 //#include "plotting/plotting.hpp"
@@ -643,13 +644,13 @@ int receiver_impl::get_sch_chan_imp_resp(const gr_complex *input, gr_complex * c
 void receiver_impl::detect_burst(const gr_complex * input, gr_complex * chan_imp_resp, int burst_start, unsigned char * output_binary)
 {
     float output[BURST_SIZE];
-    gr_complex rhh_temp[CHAN_IMP_RESP_LENGTH*d_OSR];
+    std::vector<gr_complex> rhh_temp(CHAN_IMP_RESP_LENGTH*d_OSR);
     gr_complex rhh[CHAN_IMP_RESP_LENGTH];
     gr_complex filtered_burst[BURST_SIZE];
     int start_state = 3;
     unsigned int stop_states[2] = {4, 12};
 
-    autocorrelation(chan_imp_resp, rhh_temp, d_chan_imp_length*d_OSR);
+    autocorrelation(chan_imp_resp, &rhh_temp[0], d_chan_imp_length*d_OSR);
     for (int ii = 0; ii < (d_chan_imp_length); ii++)
     {
         rhh[ii] = conj(rhh_temp[ii*d_OSR]);
--- c/lib/receiver/assert.h
+++ i/lib/receiver/assert.h
@@ -26,7 +26,7 @@
 #include "stdio.h"
 #include <iostream>
 
-//#define NDEBUG
+#define NDEBUG
 
 /**@name Macros for standard messages. */
 //@{
