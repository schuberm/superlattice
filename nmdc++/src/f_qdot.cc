#include <complex>
#include <vector>

complex<double>* f_qdot (const vector< vector<complex<double> > > &eigkv, double **velx, double **vely, double **velz, const int  &natom, const int &ntstep)
{
   complex<double>* table = new complex<double>[ntstep];
   int rows = natom;
   int cols = ntstep;
   
	for (int j=0; j<cols ;j++)
	{
		for (int i=0; i<rows ;i++)
		{
			table[j]=table[j]+(velx[i][j]*eigkv[0][i]+vely[i][j]*eigkv[1][i]+velz[i][j]*eigkv[2][i]);
		}
	}

   return table;
}