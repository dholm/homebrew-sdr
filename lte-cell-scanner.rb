require "formula"

class LteCellScanner < Formula
  homepage "https://github.com/JiaoXianjun/LTE-Cell-Scanner"
  head "https://github.com/JiaoXianjun/LTE-Cell-Scanner.git"

  patch :DATA

  depends_on "cmake" => :build
  depends_on "librtlsdr"
  depends_on "hackrf"
  depends_on "boost"
  depends_on "itpp"
  depends_on "openblas"
  depends_on "fftw"

  def install
    mkdir "build" do
      args = %W[
        -DUSE_RTLSDR=1
        -DUSE_HACKRF=1
      ] + std_cmake_args

      system "cmake", "..", *args
      system "make", "install"
    end
  end
end

__END__
diff --git i/include/dsp.h w/include/dsp.h
index fcba157..3c68a67 100644
--- i/include/dsp.h
+++ w/include/dsp.h
@@ -44,8 +44,8 @@ inline itpp::cvec fshift(const itpp::cvec &seq,const double f,const double fs) {
   itpp::cvec r(len);
   std::complex<double>coeff;
   for (uint32 t=0;t<len;t++) {
-    coeff.real()=cos(k*t);
-    coeff.imag()=sin(k*t);
+    coeff.real(cos(k*t));
+    coeff.imag(sin(k*t));
     //r(t)=seq(t)*exp(k*((double)t));
     r(t)=seq(t)*coeff;
   }
@@ -61,8 +61,8 @@ inline void fshift_inplace(itpp::cvec &seq,const double f,const double fs) {
   const uint32 len=length(seq);
   std::complex<double>coeff;
   for (uint32 t=0;t<len;t++) {
-    coeff.real()=cos(k*t);
-    coeff.imag()=sin(k*t);
+    coeff.real(cos(k*t));
+    coeff.imag(sin(k*t));
     //r(t)=seq(t)*exp(k*((double)t));
     seq(t)*=coeff;
   }
diff --git i/src/producer_thread.cpp w/src/producer_thread.cpp
index 73f8c10..723dc6b 100644
--- i/src/producer_thread.cpp
+++ w/src/producer_thread.cpp
@@ -143,9 +143,9 @@ void producer_thread(
           n_samples=t;
           break;
         }
-        sample_temp.real()=(sampbuf_sync.fifo.front())/128.0; // 127 should be 128?
+        sample_temp.real((sampbuf_sync.fifo.front())/128.0); // 127 should be 128?
         sampbuf_sync.fifo.pop_front();
-        sample_temp.imag()=(sampbuf_sync.fifo.front())/128.0; // 127 should be 128?
+        sample_temp.imag((sampbuf_sync.fifo.front())/128.0); // 127 should be 128?
         sampbuf_sync.fifo.pop_front();
         samples(t)=sample_temp;
         sample_time+=(FS_LTE/16)/(fs_programmed*k_factor);
diff --git i/src/tracker_thread.cpp w/src/tracker_thread.cpp
index 79d9d95..2681e2e 100644
--- i/src/tracker_thread.cpp
+++ w/src/tracker_thread.cpp
@@ -181,10 +181,10 @@ void get_fd(
   const complex <double> bpo_coeff=complex<double>(cos(bulk_phase_offset),sin(bulk_phase_offset));
   for (uint8 t=1;t<=36;t++) {
     phase=-k*t;
-    coeff.real()=cos(phase);
-    coeff.imag()=sin(phase);
+    coeff.real(cos(phase));
+    coeff.imag(sin(phase));
     syms(35+t)*=bpo_coeff*coeff;
-    coeff.imag()=-coeff.imag();
+    coeff.imag(-coeff.imag());
     syms(36-t)*=bpo_coeff*coeff;
   }
   // At this point, we have the frequency domain data for this slot and
