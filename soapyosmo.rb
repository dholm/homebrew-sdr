class Soapyosmo < Formula
  homepage "https://github.com/pothosware/SoapyOsmo/wiki"
  head "https://github.com/pothosware/SoapyOsmo.git"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gr-osmosdr"
  depends_on "libosmosdr"
  depends_on "soapysdr"

  def install
    mkdir "build" do
      ENV.append "LDFLAGS", "-Wl,-undefined,dynamic_lookup"
      # Point Python library to existing path or CMake test will fail.
      args = %W[
        -DCMAKE_SHARED_LINKER_FLAGS='-Wl,-undefined,dynamic_lookup'
      ] + std_cmake_args

      system "cmake", "..", *args
      system "make", "install"
    end
  end
end
