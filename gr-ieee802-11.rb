class GrIeee80211 < Formula
  homepage "https://github.com/bastibl/gr-ieee802-11"
  head "https://github.com/bastibl/gr-ieee802-11.git"

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "gnuradio"
  depends_on "boost"
  depends_on "cppunit"
  depends_on "itpp"

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
