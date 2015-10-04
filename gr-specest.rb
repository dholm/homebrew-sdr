class GrSpecest < Formula
  homepage "https://github.com/kit-cel/gr-specest"
  head "https://github.com/kit-cel/gr-specest.git"

  patch :DATA

  depends_on :fortran => :build
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "openblas"
  depends_on "gnuradio"
  depends_on "boost"
  depends_on "cppunit"
  depends_on "fftw"
  depends_on "armadillo"

  def install
    mkdir "build" do
      ENV.append "LDFLAGS", "-Wl,-undefined,dynamic_lookup"
      # Point Python library to existing path or CMake test will fail.
      args = %W[
        -DCMAKE_SHARED_LINKER_FLAGS='-Wl,-undefined,dynamic_lookup'
        -DPYTHON_LIBRARY='#{HOMEBREW_PREFIX}/lib/libgnuradio-runtime.dylib'
      ] + std_cmake_args

      system "cmake", "..", *args
      system "make", "install"
    end
  end
end

__END__
diff --git i/lib/cyclo_fam_calcspectrum_algo.cc w/lib/cyclo_fam_calcspectrum_algo.cc
index fbb4e6a..c4adab0 100644
--- i/lib/cyclo_fam_calcspectrum_algo.cc
+++ w/lib/cyclo_fam_calcspectrum_algo.cc
@@ -93,10 +93,10 @@ namespace gr {
 
 		 // Copy input stream to d_complex_demodulates and do the phase shifting
 		 for(int m = 0; m < d_P*d_Np; m++) {
-		    d_complex_demodulates[p][i].real() = in[m].real()*cos(2*M_PI*i*(p*d_L)/d_Np)+
-		                                         in[m].imag()*sin(2*M_PI*i*(p*d_L)/d_Np);
-		    d_complex_demodulates[p][i].imag() = in[m].imag()*cos(2*M_PI*i*(p*d_L)/d_Np)-
-		                                         in[m].real()*sin(2*M_PI*i*(p*d_L)/d_Np);
+		    d_complex_demodulates[p][i].real(in[m].real()*cos(2*M_PI*i*(p*d_L)/d_Np)+
+		                                     in[m].imag()*sin(2*M_PI*i*(p*d_L)/d_Np));
+		    d_complex_demodulates[p][i].imag(in[m].imag()*cos(2*M_PI*i*(p*d_L)/d_Np)-
+		                                     in[m].real()*sin(2*M_PI*i*(p*d_L)/d_Np));
 		    i++;
 
 		    if((m+1)%d_Np==0){ // End of vector length Np
