require "formula"

class PreCog < Formula
  homepage "https://github.com/jmalsbury/pre-cog"
  head "https://github.com/jmalsbury/pre-cog.git"

  depends_on "cmake" => :build
  depends_on "swig" => :build
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
