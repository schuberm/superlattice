#include <iostream>
#include <string>
#include <vector>
#include <complex>

vector< vector<complex<double> > > str2d2complex2d(vector< vector<string> > &vectorname)
{
    vector< vector<complex<double> > > table;
    int rows = vectorname.size();
    int cols = vectorname[0].size();
    double real;
    double imag;
    int num;
    char sign;
    const char *in_str;
    
	for (int i=0; i<rows ;i++)
	{
		vector<complex<double> > row;
		for (int j=0; j<cols ;j++)
		{			
    			in_str = vectorname[i][j].c_str();
			sscanf( in_str, "%lf %c %lfi", &real, &sign, &imag);
    			if( sign == '-' )
        			imag *= -1;
			row.push_back(complex <double> (real,imag));
		}
		table.push_back(row);
	}
   return table;
}
