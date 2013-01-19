#include <vector>
#include <complex>

vector< vector<complex<double> > > f_eigkv (const vector< vector<complex<double> > > &eigveccomp, const int  &natomucell, const int  &natom, const int k, const int v )
{
    vector< vector<complex<double> > > table(3);
    table[0].resize(natom);
    table[1].resize(natom);
    table[2].resize(natom);
    int modcount=0;
	for (int i=0; i<natom ;i++)
	{
		if( modcount == natomucell )
			modcount = 0;		
		table[0][i]=eigveccomp[k*3*natomucell+modcount*natomucell][v];
		table[1][i]=eigveccomp[k*3*natomucell+modcount*natomucell+1][v];
		table[2][i]=eigveccomp[k*3*natomucell+modcount*natomucell+2][v];
		modcount+=modcount;
	}
   return table;
}

