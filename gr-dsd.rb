require "formula"

class GrDsd < Formula
  homepage "https://github.com/argilo/gr-dsd"
  head "https://github.com/argilo/gr-dsd.git"

  patch :DATA

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "gnuradio"
  depends_on "boost"
  depends_on "cppunit"

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
diff --git i/CMakeLists.txt w/CMakeLists.txt
index f17a773..3e7b3b7 100644
--- i/CMakeLists.txt
+++ w/CMakeLists.txt
@@ -57,7 +57,7 @@ set(Boost_ADDITIONAL_VERSIONS
     "1.60.0" "1.60" "1.61.0" "1.61" "1.62.0" "1.62" "1.63.0" "1.63" "1.64.0" "1.64"
     "1.65.0" "1.65" "1.66.0" "1.66" "1.67.0" "1.67" "1.68.0" "1.68" "1.69.0" "1.69"
 )
-find_package(Boost "1.35")
+find_package(Boost "1.35" COMPONENTS system)
 
 if(NOT Boost_FOUND)
     message(FATAL_ERROR "Boost required to compile gr-dsd")
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
+set(GR_REQUIRED_COMPONENTS RUNTIME PMT)
+find_package(Gnuradio)
 
 if(NOT GNURADIO_RUNTIME_FOUND)
     message(FATAL_ERROR "GnuRadio Runtime required to compile gr-dsd")
