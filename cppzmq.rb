require "formula"

class Cppzmq < Formula
  homepage "https://github.com/zeromq/cppzmq"
  head "https://github.com/zeromq/cppzmq.git"

  depends_on "zeromq"

  def install
    include.install "zmq.hpp"
  end
end
