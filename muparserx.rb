class Muparserx < Formula
  homepage "http://articles.beltoforion.de/article.php?a=muparserx"
  # 4.0.4 does not build on OSX.
  #url "https://github.com/beltoforion/muparserx/archive/v4.0.4.tar.gz"
  #sha256 "d7ebcab8cb1de88e6dcba21651db8f6055b3e904c45afc387b06b5f4218dda40"
  head "https://github.com/beltoforion/muparserx.git"

  depends_on "cmake" => :build

  def install
    mkdir "cmake-build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
