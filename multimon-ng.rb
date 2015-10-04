require "formula"

class MultimonNg < Formula
  homepage "https://github.com/EliasOenal/multimon-ng"
  head "https://github.com/EliasOenal/multimon-ng.git"

  depends_on "qt" => :build
  depends_on :x11

  def install
    mkdir "build" do
      system "qmake",  "../multimon-ng.pro", "PREFIX=#{prefix}"
      system "make", "install"
    end
  end
end
