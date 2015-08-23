require "formula"

class GrGsm < Formula
  homepage "https://github.com/ptrkrysik/gr-gsm"
  head "https://github.com/ptrkrysik/gr-gsm.git"

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
