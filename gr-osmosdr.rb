class GrOsmosdr < Formula
  homepage "http://sdr.osmocom.org/trac/wiki/GrOsmoSDR"
  url "http://git.osmocom.org/gr-osmosdr/snapshot/gr-osmosdr-0.1.4.tar.xz"
  sha256 "1945d0d98fd4b600cb082970267ec2041528f13150422419cbd7febe2b622721"
  head "git://git.osmocom.org/gr-osmosdr"

  depends_on "cmake" => :build

  depends_on "Cheetah" => :python
  depends_on "gnuradio"
  depends_on "gr-fosphor"
  depends_on "gr-iqbal"
  depends_on "librtlsdr"
  depends_on "pothosware/pothos/soapysdr"

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
