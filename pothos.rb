class Pothos < Formula
  homepage "http://www.pothosware.com/"
  head "https://github.com/pothosware/pothos.git"

  depends_on "cmake" => :build
  depends_on "qt5"
  depends_on "poco"
  depends_on "portaudio"
  depends_on "graphviz"
  depends_on "soapysdr"

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
