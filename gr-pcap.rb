require "formula"

class GrPcap < Formula
  homepage "https://github.com/osh/gr-pcap"
  head "https://github.com/osh/gr-pcap.git"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "pkg-config" => :build
  depends_on "gnuradio"
  depends_on "boost"
  depends_on "cppunit"

  def install
    mkdir "build" do
      args = %W[
        -DCMAKE_SHARED_LINKER_FLAGS='-Wl,-undefined,dynamic_lookup'
      ] + std_cmake_args

      system "cmake", "..", *args
      system "make install"
    end
  end
end
