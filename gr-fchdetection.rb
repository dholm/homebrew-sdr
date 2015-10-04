class GrFchdetection < Formula
  homepage "https://github.com/hzhua/gr-fchdetection"
  head "https://github.com/hzhua/gr-fchdetection.git"

  patch :DATA

  depends_on "cmake" => :build
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
index 6a9ad50..3329284 100644
--- i/CMakeLists.txt
+++ w/CMakeLists.txt
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
     message(FATAL_ERROR "GnuRadio Runtime required to compile fchdetection")
