class GrMac < Formula
  homepage "https://github.com/balint256/gr-mac"
  head "https://github.com/balint256/gr-mac.git"

  depends_on "cmake" => :build
  depends_on "gnuradio"

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
