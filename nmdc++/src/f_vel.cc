#include <vector>

double** f_vel (const vector< vector<double> > &vel,const int  &natom, const int &ntstep, const int dir )
{
    double **veli = new double*[natom];
	for (int i=0; i<natom ;i++)
	{
		veli [i] = new double[ntstep];
		for (int j=0; j<ntstep ;j++){
			veli[i][j]=vel[j*(natom)+i][dir];
		}
	}
   return veli;
}