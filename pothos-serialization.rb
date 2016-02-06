class PothosSerialization < Formula
  homepage "https://github.com/pothosware/pothos-serialization/"
  url "https://github.com/pothosware/pothos-serialization/archive/pothos-serialization-0.2.0.tar.gz"
  sha256 "a75842a33d94182795f9ed2862d0f9adac01377b3c71ee7fd9a6220133f44491"
  head "https://github.com/pothosware/pothos-serialization.git"

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
