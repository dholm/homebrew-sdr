class GrHam < Formula
  homepage "https://github.com/argilo/gr-ham"
  head "https://github.com/argilo/gr-ham.git"

  depends_on "cmake" => :build
  depends_on "swig" => :build
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
