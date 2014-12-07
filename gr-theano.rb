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
    url "https://github.com/Theano/Theano/archive/rel-0.6.tar.gz"
    sha1 "2eb96cb77ea86a528e0c7b9fec5f907194116a2e"
  end

  def install
    mkdir "build" do
      ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
      python_args = ["install", "--prefix=#{libexec}"]
      resource("theano").stage { system "python", "setup.py", *python_args }

      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end
end
