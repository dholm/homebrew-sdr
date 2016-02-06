class Pothos < Formula
  homepage "http://www.pothosware.com/"
  url "https://github.com/pothosware/pothos/archive/pothos-0.3.1.tar.gz"
  sha256 "17abc96c446615a6f0fd5f265993137185f687b58ac855bb699da564d6d154d9"
  head "https://github.com/pothosware/pothos.git"

  depends_on "cmake" => :build

  depends_on "graphviz"
  depends_on "muparserx"
  depends_on "poco"
  depends_on "portaudio"
  depends_on "pothos-serialization"
  depends_on "qt5"
  depends_on "soapysdr"
  depends_on "spuce"

  def install
    mkdir "build" do
      ENV.append "LDFLAGS", "-Wl,-undefined,dynamic_lookup"
      # Point Python library to existing path or CMake test will fail.
      args = %W[
        -DCMAKE_SHARED_LINKER_FLAGS='-Wl,-undefined,dynamic_lookup'
        -DPYTHON_LIBRARY='#{HOMEBREW_PREFIX}/lib/libgnuradio-runtime.dylib'
        -DENABLE_APACHECONNECTOR=OFF
      ] + std_cmake_args

      system "cmake", "..", *args
      system "make", "install"
    end
  end
end
