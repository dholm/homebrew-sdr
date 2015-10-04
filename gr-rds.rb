class GrRds < Formula
  homepage "https://github.com/balint256/gr-rds"
  head "https://github.com/bastibl/gr-rds.git"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gnuradio"
  depends_on "boost"

  def install
    mkdir "build" do
      ENV.append "LDFLAGS", "-Wl,-undefined,dynamic_lookup"
      args = %W[
        -DCMAKE_SHARED_LINKER_FLAGS='-Wl,-undefined,dynamic_lookup'
        -DPYTHON_LIBRARY='#{HOMEBREW_PREFIX}/lib/libgnuradio-runtime.dylib'
      ] + std_cmake_args

      system "cmake", "..", *args
      system "make", "install"
    end
  end
end
