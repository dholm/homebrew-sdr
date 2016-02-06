class OsmoSdr < Formula
  homepage "http://osmocom.org"
  url "http://cgit.osmocom.org/osmo-sdr/snapshot/osmo-sdr-0.1.tar.xz"
  sha256 "ac488768ad735dd6ca0ba594643f831e2b62747244da9a233264c11a96bc1f96"
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
