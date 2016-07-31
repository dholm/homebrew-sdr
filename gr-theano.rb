require "formula"

class GrTheano < Formula
  homepage "https://github.com/osh/gr-theano"
  head "https://github.com/osh/gr-theano.git"

  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "gnuradio"
  depends_on "boost"
  depends_on "cppunit"

  resource "theano" do
    url "https://github.com/Theano/Theano/archive/rel-0.8.2.tar.gz"
    sha256 "144e67a5bec9748d80381654b06e2b1164d034f8679028c59b7bb384d2e53a04"
  end

  def install
    mkdir "build" do
      ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
      python_args = ["install", "--prefix=#{libexec}"]
      resource("theano").stage { system "python", "setup.py", *python_args }

      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
