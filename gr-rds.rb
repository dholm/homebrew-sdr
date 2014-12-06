require "formula"

class GrRds < Formula
  homepage "https://github.com/balint256/gr-rds"
  head "https://github.com/bastibl/gr-rds.git"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gnuradio"
  depends_on "boost"

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
