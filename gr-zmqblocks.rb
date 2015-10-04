require "formula"

class GrZmqblocks < Formula
  homepage "https://github.com/iohannez/gr-zmqblocks"
  head "https://github.com/iohannez/gr-zmqblocks.git"

  patch :DATA

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "gnuradio"
  depends_on "boost"
  depends_on "cppunit"
  depends_on "zeromq"
  depends_on "cppzmq"

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
index 130ee78..063e4f4 100644
--- i/CMakeLists.txt
+++ w/CMakeLists.txt
@@ -86,7 +86,6 @@ set(GRC_BLOCKS_DIR      ${GR_PKG_DATA_DIR}/grc/blocks)
 ########################################################################
 # Find gnuradio build dependencies
 ########################################################################
-find_package(GnuradioRuntime)
 find_package(CppUnit)
 find_package(ZeroMQ REQUIRED)
 
@@ -95,8 +94,8 @@ find_package(ZeroMQ REQUIRED)
 # of GR_REQUIRED_COMPONENTS (in all caps) and change "version" to the
 # minimum API compatible version required.
 #
-# set(GR_REQUIRED_COMPONENTS RUNTIME BLOCKS FILTER ...)
-# find_package(Gnuradio "version")
+set(GR_REQUIRED_COMPONENTS RUNTIME PMT)
+find_package(Gnuradio)
 
 if(NOT GNURADIO_RUNTIME_FOUND)
     message(FATAL_ERROR "GnuRadio Runtime required to compile zmqblocks")
