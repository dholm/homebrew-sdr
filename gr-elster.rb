class GrElster < Formula
  homepage "https://github.com/argilo/gr-elster"
  head "https://github.com/argilo/gr-elster.git"

  depends_on "cmake" => :build
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
      system "make", "install"
    end
  end
end
