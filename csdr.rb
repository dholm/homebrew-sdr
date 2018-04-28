class Csdr < Formula
  desc "A simple DSP library and command-line tool for Software Defined Radio."
  homepage "https://github.com/simonyiszk/csdr"
  url "https://github.com/simonyiszk/csdr/archive/0.15.tar.gz"
  sha256 "5273633dac6e7ed8d4abdbd8c5a9c466a3924e5853b18723701935067cdaa00b"
  head "https://github.com/simonyiszk/csdr.git"

  depends_on "python@2"

  patch :DATA

  def install
    system "make", "PARAMS_SIMD=-msse -msse2 -msse3 -msse4a -msse4", "PARAMS_LOOPVECT=-O3 -ffast-math", "PARAMS_LIBS=-g -lm -lfftw3f -DUSE_FFTW -DLIBCSDR_GPL -DUSE_IMA_ADPCM"
    lib.install("libcsdr.0.dylib")
    lib.install("libcsdr.dylib")
    bin.install("csdr")
    bin.install("csdr-fm")
  end

  test do
    system "#{bin}/csdr", "--help"
  end
end

__END__
diff --git a/csdr.c b/csdr.c
index 18160d6..b4b74fb 100644
--- a/Makefile
+++ b/Makefile
@@ -47,18 +47,19 @@
 
 .PHONY: clean-vect clean
 all: csdr nmux
-libcsdr.so: fft_fftw.c fft_rpi.c libcsdr_wrapper.c libcsdr.c libcsdr_gpl.c fastddc.c fastddc.h  fft_fftw.h  fft_rpi.h  ima_adpcm.h  libcsdr_gpl.h  libcsdr.h  predefined.h
+libcsdr.dylib: fft_fftw.c fft_rpi.c libcsdr_wrapper.c libcsdr.c libcsdr_gpl.c fastddc.c fastddc.h  fft_fftw.h  fft_rpi.h  ima_adpcm.h  libcsdr_gpl.h  libcsdr.h  predefined.h
 	@echo NOTE: you may have to manually edit Makefile to optimize for your CPU \(especially if you compile on ARM, please edit PARAMS_NEON\).
 	@echo Auto-detected optimization parameters: $(PARAMS_SIMD)
 	@echo
 	rm -f dumpvect*.vect
-	gcc -std=gnu99 $(PARAMS_LOOPVECT) $(PARAMS_SIMD) $(LIBSOURCES) $(PARAMS_LIBS) $(PARAMS_MISC) -fpic -shared -Wl,-soname,libcsdr.so.$(SOVERSION) -o libcsdr.so
+	gcc -std=gnu99 $(PARAMS_LOOPVECT) $(PARAMS_SIMD) $(LIBSOURCES) $(PARAMS_LIBS) $(PARAMS_MISC) -fpic -dynamiclib -install_name libcsdr.0.dylib -current_version $(SOVERSION) -compatibility_version 0 -o libcsdr.0.dylib
+	ln -s libcsdr.0.dylib libcsdr.dylib
 	-./parsevect dumpvect*.vect
-csdr: csdr.c libcsdr.so
+csdr: csdr.c libcsdr.dylib
 	gcc -std=gnu99 $(PARAMS_LOOPVECT) $(PARAMS_SIMD) csdr.c $(PARAMS_LIBS) -L. -lcsdr $(PARAMS_MISC) -o csdr
-ddcd: ddcd.cpp libcsdr.so ddcd.h
+ddcd: ddcd.cpp libcsdr.dylib ddcd.h
 	g++ $(PARAMS_LOOPVECT) $(PARAMS_SIMD) ddcd.cpp $(PARAMS_LIBS) -L. -lcsdr -lpthread $(PARAMS_MISC) -o ddcd
-nmux: nmux.cpp libcsdr.so nmux.h tsmpool.cpp tsmpool.h
+nmux: nmux.cpp libcsdr.dylib nmux.h tsmpool.cpp tsmpool.h
 	g++ $(PARAMS_LOOPVECT) $(PARAMS_SIMD) nmux.cpp tsmpool.cpp $(PARAMS_LIBS) -L. -lcsdr -lpthread $(PARAMS_MISC) -o nmux
 arm-cross: clean-vect
 	#note: this doesn't work since having added FFTW
@@ -66,19 +67,20 @@
 clean-vect:
 	rm -f dumpvect*.vect
 clean: clean-vect
-	rm -f libcsdr.so csdr ddcd nmux
+	rm -f libcsdr.dylib libcsdr.0.dylib csdr ddcd nmux
 install: all 
-	install -m 0755 libcsdr.so $(PREFIX)/lib
+	install -m 0755 libcsdr.0.dylib $(PREFIX)/lib
+	install -m 0755 libcsdr.dylib $(PREFIX)/lib
 	install -m 0755 csdr $(PREFIX)/bin
 	install -m 0755 csdr-fm $(PREFIX)/bin
 	install -m 0755 nmux $(PREFIX)/bin
 	#-install -m 0755 ddcd $(PREFIX)/bin
 	@ldconfig || echo please run ldconfig
 uninstall:
-	rm $(PREFIX)/lib/libcsdr.so $(PREFIX)/bin/csdr $(PREFIX)/bin/csdr-fm
+	rm $(PREFIX)/lib/libcsdr.dylib $(PREFIX)/lib/libcsdr.0.dylib $(PREFIX)/bin/csdr $(PREFIX)/bin/csdr-fm
 	ldconfig
 disasm:
-	objdump -S libcsdr.so > libcsdr.disasm
+	objdump -S libcsdr.0.dylib > libcsdr.disasm
 emcc-clean:
 	-rm sdr.js/sdr.js
 	-rm sdr.js/sdrjs-compiled.js
--- a/parsevect
+++ b/parsevect
@@ -1,4 +1,4 @@
-#!/usr/bin/python2
+#!/usr/bin/env python2
 print "" # python2.7 is required to run parsevect instead of python3
 """
 This software is part of libcsdr, a set of simple DSP routines for 
--- a/csdr.c
+++ b/csdr.c
@@ -136,6 +136,16 @@ int bigbufs = 0;
 #define TRY_YIELD
 //unsigned yield_counter=0;

+
+#ifdef __MACH__
+#include <mach/mach.h>
+// value here doesn't matter.
+#define CLOCK_MONOTONIC_RAW 0
+// later, in main(), we call fcntl() on stdout and stdin to increase the buffer size.
+// let's turn that call into a noop.
+#define F_SETPIPE_SZ F_GETFL
+#endif
+
 int badsyntax(char* why)
 {
        if(why==0) fprintf(stderr, "%s", usage);
--- a/nmux.cpp
+++ b/nmux.cpp
@@ -215,6 +215,9 @@
 				fprintf(stderr, "\x1b[0m\n");
 			}
 
+			const int set = 1;
+			setsockopt(new_socket, SOL_SOCKET, SO_NOSIGPIPE, &set, sizeof(set));
+
 			//We're the parent, let's create a new client and initialize it
 			client_t* new_client = new client_t;
 			new_client->error = 0;
@@ -329,7 +329,7 @@
 
 		//Read data from global tsmpool and write it to client socket
 		if(NMUX_DEBUG) fprintf(stderr, "client 0x%x: sending...", (intptr_t)param);
-		ret = send(this_client->socket, pool_read_buffer + client_buffer_index, lpool->size - client_buffer_index, MSG_NOSIGNAL);
+		ret = send(this_client->socket, pool_read_buffer + client_buffer_index, lpool->size - client_buffer_index, 0);
 		if(NMUX_DEBUG) fprintf(stderr, "client sent.\n");
 		if(ret == -1) 
 		{
