require "formula"

class GrLte < Formula
  homepage "https://github.com/kit-cel/gr-lte"
  head "https://github.com/kit-cel/gr-lte.git"

  patch :DATA

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "gnuradio"
  depends_on "boost"
  depends_on "cppunit"
  depends_on "fftw"

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
diff --git i/CMakeLists.txt w/CMakeLists.txt
index 335d348..a36ec1f 100644
--- i/CMakeLists.txt
+++ w/CMakeLists.txt
@@ -97,6 +97,7 @@ find_package(FFTW3f)
 
 set(GR_REQUIRED_COMPONENTS RUNTIME FILTER)
 find_package(Gnuradio "3.7.2" REQUIRED)
+find_package(Volk)
 
 if(NOT GNURADIO_RUNTIME_FOUND)
     message(FATAL_ERROR "GnuRadio Runtime required to compile lte")
@@ -116,6 +117,7 @@ include_directories(
     ${Boost_INCLUDE_DIRS}
     ${CPPUNIT_INCLUDE_DIRS}
     ${GNURADIO_ALL_INCLUDE_DIRS}
+    ${VOLK_INCLUDE_DIRS}
 )
 
 link_directories(
diff --git i/lib/CMakeLists.txt w/lib/CMakeLists.txt
index 2ac95b3..21d8592 100644
--- i/lib/CMakeLists.txt
+++ w/lib/CMakeLists.txt
@@ -62,7 +62,7 @@ list(APPEND lte_sources
     mimo_remove_cp_impl.cc )
 
 add_library(gnuradio-lte SHARED ${lte_sources})
-target_link_libraries(gnuradio-lte ${Boost_LIBRARIES} ${GNURADIO_RUNTIME_LIBRARIES} ${FFTW3F_LIBRARIES})
+target_link_libraries(gnuradio-lte ${Boost_LIBRARIES} ${GNURADIO_RUNTIME_LIBRARIES} ${FFTW3F_LIBRARIES} ${VOLK_LIBRARIES})
 set_target_properties(gnuradio-lte PROPERTIES DEFINE_SYMBOL "gnuradio_lte_EXPORTS")
 
 ########################################################################
