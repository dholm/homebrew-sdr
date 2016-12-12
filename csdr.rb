class Csdr < Formula
  desc "A simple DSP library and command-line tool for Software Defined Radio."
  homepage "https://github.com/simonyiszk/csdr"
  url "https://github.com/simonyiszk/csdr/archive/0.12.tar.gz"
  version "0.12"
  sha256 "2caf50784667258618b85428652cff46b13b6e5509a0457fccd645a5d53ad9ee"
  head "https://github.com/simonyiszk/csdr.git"

  patch :DATA

  def install
    system "make", "PARAMS_SIMD=-msse -msse2 -msse3 -msse4a -msse4", "PARAMS_LOOPVECT=-O3 -ffast-math", "PARAMS_LIBS=-g -lm -lfftw3f -DUSE_FFTW -DLIBCSDR_GPL -DUSE_IMA_ADPCM"
    lib.install("libcsdr.so")
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
--- a/csdr.c
+++ b/csdr.c
@@ -136,6 +136,26 @@ int bigbufs = 0;
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
+int clock_gettime(int clk_id, struct timespec *tp) {
+       clock_serv_t cclock;
+       mach_timespec_t mts;
+       host_get_clock_service(mach_host_self(), SYSTEM_CLOCK, &cclock);
+       clock_get_time(cclock, &mts);
+       mach_port_deallocate(mach_task_self(), cclock);
+       tp->tv_sec = mts.tv_sec;
+       tp->tv_nsec = mts.tv_nsec;
+       return 0;
+}
+#endif
+
 int badsyntax(char* why)
 {
        if(why==0) fprintf(stderr, "%s", usage);
