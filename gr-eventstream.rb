require "formula"

class GrEventstream < Formula
  homepage "https://github.com/osh/gr-eventstream"
  head "https://github.com/osh/gr-eventstream.git"

  patch :DATA

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gnuradio"
  depends_on "boost"
  depends_on "cppunit"
  depends_on "ice"

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
diff --git i/CMakeLists.txt w/CMakeLists.txt
index e178d84..c595241 100644
--- i/CMakeLists.txt
+++ w/CMakeLists.txt
@@ -82,7 +82,7 @@ set(BOOST_REQUIRED_COMPONENTS
 MESSAGE("")
 #find_package(Threads REQUIRED)
 set(Boost_USE_MULTITHREADED ON)
-FIND_PACKAGE(Boost "1.53" COMPONENTS system)
+FIND_PACKAGE(Boost "1.53" COMPONENTS system thread)
 #FIND_PACKAGE(Boost "1.53" COMPONENTS ${BOOST_REQUIRED_COMPONENTS})
 
 IF(NOT Boost_FOUND)
