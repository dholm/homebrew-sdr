class Pothos < Formula
  homepage "http://www.pothosware.com/"
  head "https://github.com/pothosware/pothos.git"

  depends_on "cmake" => :build
  depends_on "qt5"
  depends_on "poco"
  depends_on "portaudio"
  depends_on "graphviz"
  depends_on "soapysdr"

  patch :DATA

  def install
    mkdir "build" do
      ENV.append "LDFLAGS", "-Wl,-undefined,dynamic_lookup"
      # Point Python library to existing path or CMake test will fail.
      args = %W[
        -DCMAKE_SHARED_LINKER_FLAGS='-Wl,-undefined,dynamic_lookup'
        -DPYTHON_LIBRARY='#{HOMEBREW_PREFIX}/lib/libgnuradio-runtime.dylib'
        -DENABLE_APACHECONNECTOR=OFF
      ] + std_cmake_args

      system "cmake", "..", *args
      system "make", "install"
    end
  end
end

__END__
diff --git i/blocks/network/SocketEndpoint.cpp w/blocks/network/SocketEndpoint.cpp
index 18d6cfd..3510ffc 100644
--- i/blocks/network/SocketEndpoint.cpp
+++ w/blocks/network/SocketEndpoint.cpp
@@ -15,6 +15,7 @@
 #include <cassert>
 #include <iostream>
 #include <algorithm> //min/max
+#include <libkern/OSByteOrder.h>
 
 /***********************************************************************
  * The maximum number of bytes passed to a single send() call.
@@ -690,13 +691,13 @@ void PothosPacketSocketEndpoint::Impl::recv(uint16_t &flags, uint16_t &type, Pot
     if ((flags & PothosPacketFlagFlo) != 0 and buffer.length >= sizeof(uint64_t))
     {
         const uint64_t totalN = buffer.as<const uint64_t *>()[0];
-        this->lastFlowMsgRecv = Poco::ByteOrder::fromNetwork(totalN);
+        this->lastFlowMsgRecv = OSSwapBigToHostInt64(totalN);
     }
 
     //deal with flow control (outgoing)
     if (this->totalBytesRecv > this->lastFlowMsgSent + this->flowControlWindowBytes()/8)
     {
-        const uint64_t totalN = Poco::ByteOrder::toNetwork(this->totalBytesRecv);
+        const uint64_t totalN = OSSwapLittleToHostInt64(this->totalBytesRecv);
         this->send(PothosPacketFlagFlo, 0, &totalN, sizeof(totalN));
         this->lastFlowMsgSent = this->totalBytesRecv;
     }
diff --git i/comms/fft/kissfft.hh w/comms/fft/kissfft.hh
index bec8b54..09f9f14 100644
--- i/comms/fft/kissfft.hh
+++ w/comms/fft/kissfft.hh
@@ -265,11 +265,7 @@ class kissfft
             cpx_type * twiddles = &_twiddles[0];
             cpx_type t;
             int Norig = _nfft;
-            #ifdef _MSC_VER
             cpx_type *scratchbuf = (cpx_type *)alloca(p*sizeof(cpx_type));
-            #else
-            cpx_type scratchbuf[p];
-            #endif
 
             for ( u=0; u<m; ++u ) {
                 k=u;
