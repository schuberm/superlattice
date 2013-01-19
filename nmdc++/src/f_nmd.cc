#include <complex>
#include <fftw3.h>


complex<double>* f_nmd (complex<double>* qdot, const int &ntstep)
{
    int N=ntstep;
    complex<double>* in= new complex<double> [N];
    complex<double>* out= new complex<double> [N];
    fftw_plan p = fftw_plan_dft_1d(N,reinterpret_cast<fftw_complex*>(in), 
                                     reinterpret_cast<fftw_complex*>(out),
                                     FFTW_FORWARD, FFTW_ESTIMATE);   
 
    for (int i=0; i<N ;i++)
    {
	in[i]=qdot[i];
    }
    fftw_execute(p);
    fftw_destroy_plan(p);
    return out;
}