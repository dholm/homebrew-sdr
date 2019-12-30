class RtlBiast < Formula
  desc "Bias tee software for the RTL-SDR.com V3 Dongle"
  homepage "https://github.com/rtlsdrblog/rtl_biast"
  url "https://github.com/rtlsdrblog/rtl_biast/archive/1.0.tar.gz"
  sha256 "58c369c5ffc8106494d4d52fd65fcd87f5a54eb1991ace28515db02c18007ce9"
  head "https://github.com/rtlsdrblog/rtl_biast.git"

  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
