class Libosmosdr < Formula
  homepage "http://osmocom.org"
  head "git://git.osmocom.org/osmo-sdr.git"

  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    mkdir "build" do
      system "cmake", "../software/libosmosdr", *std_cmake_args
      system "make", "install"
    end
  end
end
