class GrOp25 < Formula
  homepage "http://op25.osmocom.org/trac/wiki"
  head "git://op25.osmocom.org/op25.git"

  patch :DATA

  depends_on "cmake" => :build
  depends_on "gnuradio"
  depends_on "gr-osmosdr"
  depends_on "boost"
  depends_on "itpp"

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
diff --git i/op25/gr-op25/CMakeLists.txt w/op25/gr-op25/CMakeLists.txt
index 9711a91..e661b9a 100644
--- i/op25/gr-op25/CMakeLists.txt
+++ w/op25/gr-op25/CMakeLists.txt
@@ -83,7 +83,6 @@ set(GRC_BLOCKS_DIR      ${GR_PKG_DATA_DIR}/grc/blocks)
 ########################################################################
 # Find gnuradio build dependencies
 ########################################################################
-find_package(GnuradioRuntime)
 find_package(CppUnit)
 
 # To run a more advanced search for GNU Radio and it's components and
@@ -91,8 +90,8 @@ find_package(CppUnit)
 # of GR_REQUIRED_COMPONENTS (in all caps) and change "version" to the
 # minimum API compatible version required.
 #
-# set(GR_REQUIRED_COMPONENTS RUNTIME BLOCKS FILTER ...)
-# find_package(Gnuradio "version")
+set(GR_REQUIRED_COMPONENTS RUNTIME FILTER PMT)
+find_package(Gnuradio)
 
 if(NOT GNURADIO_RUNTIME_FOUND)
     message(FATAL_ERROR "GnuRadio Runtime required to compile op25")
diff --git i/op25/gr-op25_repeater/CMakeLists.txt w/op25/gr-op25_repeater/CMakeLists.txt
index c3859be..e335106 100644
--- i/op25/gr-op25_repeater/CMakeLists.txt
+++ w/op25/gr-op25_repeater/CMakeLists.txt
@@ -83,7 +83,6 @@ set(GRC_BLOCKS_DIR      ${GR_PKG_DATA_DIR}/grc/blocks)
 ########################################################################
 # Find gnuradio build dependencies
 ########################################################################
-find_package(GnuradioRuntime)
 find_package(CppUnit)
 
 # To run a more advanced search for GNU Radio and it's components and
@@ -91,8 +90,8 @@ find_package(CppUnit)
 # of GR_REQUIRED_COMPONENTS (in all caps) and change "version" to the
 # minimum API compatible version required.
 #
-# set(GR_REQUIRED_COMPONENTS RUNTIME BLOCKS FILTER ...)
-# find_package(Gnuradio "version")
+set(GR_REQUIRED_COMPONENTS RUNTIME FILTER PMT)
+find_package(Gnuradio)
 
 if(NOT GNURADIO_RUNTIME_FOUND)
     message(FATAL_ERROR "GnuRadio Runtime required to compile op25_repeater")
diff --git i/op25/gr-op25_repeater/lib/CMakeLists.txt w/op25/gr-op25_repeater/lib/CMakeLists.txt
index 9493837..83138fa 100644
--- i/op25/gr-op25_repeater/lib/CMakeLists.txt
+++ w/op25/gr-op25_repeater/lib/CMakeLists.txt
@@ -50,9 +50,7 @@ list(APPEND op25_repeater_sources
 )
 
 add_library(gnuradio-op25_repeater SHARED ${op25_repeater_sources})
-find_library(GR_FILTER_LIBRARY libgnuradio-filter.so )
-set(GR_FILTER_LIBRARIES ${GR_FILTER_LIBRARY})
-target_link_libraries(gnuradio-op25_repeater ${Boost_LIBRARIES} ${GNURADIO_RUNTIME_LIBRARIES} ${GR_FILTER_LIBRARIES} imbe_vocoder)
+target_link_libraries(gnuradio-op25_repeater ${Boost_LIBRARIES} ${GNURADIO_RUNTIME_LIBRARIES} ${GNURADIO_FILTER_LIBRARIES} imbe_vocoder)
 set_target_properties(gnuradio-op25_repeater PROPERTIES DEFINE_SYMBOL "gnuradio_op25_repeater_EXPORTS")
 
 ########################################################################
