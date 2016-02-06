class Spuce < Formula
  homepage "https://github.com/audiofilter/spuce/"
  url "https://github.com/audiofilter/spuce/archive/0.4.3.tar.gz"
  sha256 "5688e107b57640ba0485790d64eb16bff855f54f6fa5b2fdab568ee91f6dc687"
  head "https://github.com/audiofilter/spuce.git"

  depends_on "cmake" => :build

  depends_on "qt5"

  def install
    mkdir "build" do
      args = %W[
        -DCMAKE_PREFIX_PATH=#{HOMEBREW_PREFIX}/opt/qt5
      ] + std_cmake_args
      system "cmake", "..", "", *args
      system "make", "install"
    end
  end
end
