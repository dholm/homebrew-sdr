class Soapysdr < Formula
  homepage "https://github.com/pothosware/SoapySDR/wiki"
  url "https://github.com/pothosware/SoapySDR/archive/soapy-sdr-0.4.1.tar.gz"
  sha256 "134471fbcf2e29d679c6d1ef0b14e6337d37636d9a9460a05beff96945038340"
  head "https://github.com/pothosware/SoapySDR.git"

  depends_on "cmake" => :build
  depends_on "librtlsdr"

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
