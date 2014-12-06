require "formula"

class GrMediatools < Formula
  homepage "https://github.com/osh/gr-mediatools"
  head "https://github.com/osh/gr-mediatools.git"

  patch :DATA

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "gnuradio"
  depends_on "boost"
  depends_on "libav"

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
index a3374ac..a833f49 100644
--- i/CMakeLists.txt
+++ w/CMakeLists.txt
@@ -61,7 +61,7 @@ set(BOOST_REQUIRED_COMPONENTS
     system
     unit_test_framework
 )
-find_package(Boost "1.42")
+find_package(Boost "1.42" COMPONENTS system)
 
 if(NOT Boost_FOUND)
     message(FATAL_ERROR "Boost required to compile mediatools")
