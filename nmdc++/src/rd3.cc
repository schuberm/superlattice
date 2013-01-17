#include <iostream>
#include <math.h>
#include <fftw3.h>
#include <vector>
#include <string>
#include <sstream>
#include <fstream>
#include <stdlib.h>
#include <stdio.h>
#include <iterator>
#include <complex>
using namespace std;

vector< vector<double> > readIn2dDouble(const char* filename)
{
    vector< vector<double> > table; 
    fstream ifs;
    ifs.open(filename);

    while (true)
    {
        string line;
	string dash ("--");
        double buf;

        getline(ifs, line);	
        stringstream ss(line, ios_base::out|ios_base::in|ios_base::binary);

        if (!ifs)
            break;
        if (line[0] == '#' || line.empty() || line == "--" )
            continue;
        vector<double> row;
        while (ss >> buf){
            	row.push_back(buf);           
	}
	table.push_back(row);
    }
    ifs.close();
    return table;
}


vector< vector<string> > readIn2dstr(const char* filename)
{
    vector< vector<string> > table; 
    fstream ifs;
    ifs.open(filename);

    while (true)
    {
        string line;
	string dash ("--");
        string buf;

        getline(ifs, line);	
        stringstream ss(line, ios_base::out|ios_base::in|ios_base::binary);

        if (!ifs)
            break;
        if (line[0] == '#' || line.empty() || line == "--" )
            continue;
        vector<string> row;
        while (ss >> buf){
            	row.push_back(buf);           
	}
	table.push_back(row);
    }
    ifs.close();
    return table;
}


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

/*
vector< vector<double> > f_vel (const vector< vector<double> > &vel,const int  &natom, const int &ntstep, const int dir )
{
    vector< vector<double> > table;
	for (int i=0; i<natom ;i++)
	{
		vector<double> row;
		for (int j=0; j<ntstep ;j++){
			row.push_back(vel[j*(natom)+i][dir]);
		}
		table.push_back(row);
	}
   return table;
}
*/

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

/*
vector<complex<double> > f_qdot (const vector< vector<complex<double> > > &eigkv, const vector< vector<double> > &velx, const vector< vector<double> > &vely, const vector< vector<double> > &velz)
{
   vector<complex<double> >  table;
   int rows = velx.size();
   int cols = velx[0].size();
   
	for (int j=0; j<cols ;j++)
	{
		table.push_back(0);
		for (int i=0; i<rows ;i++)
		{
			table[i]=table[i]+(velx[i][j]*eigkv[i][0]+vely[i][j]*eigkv[i][1]+velz[i][j]*eigkv[i][2]);
		}
	}

   return table;
}
*/

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

complex<double>* f_nmd (complex<double>* qdot, const int &ntstep)
{
    int N=ntstep;
    complex<double>* in= new complex<double> [N];
    complex<double>* out= new complex<double> [N];
    fftw_plan p = fftw_plan_dft_1d(N,reinterpret_cast<fftw_complex*>(in), 
                                     reinterpret_cast<fftw_complex*>(out),
                                     FFTW_FORWARD, FFTW_ESTIMATE);
//     double pi=acos(-1.);
//     for (int i=0;i<N;i++)
//        in[i]=sin(2*pi*0.2*i);   
 
    for (int i=0; i<N ;i++)
    {
	in[i]=qdot[i];
//	cout << i;
    }
    fftw_execute(p);
    fftw_destroy_plan(p);
    return out;
}

///*
int main () 
{
	const int natomucell=4;	
	const int natom=256;
	const int ntstep=2048;
	
	vector< vector<string> > eigvec;
	vector< vector<complex<double> > > eigveccomp;
	vector< vector<complex<double> > > eigkv;
        complex<double>* qdot;
        complex<double>* sed;
	vector< vector<double> > vel;
//	vector< vector<double> > velx;
//	vector< vector<double> > vely;
//	vector< vector<double> > velz;

	double** velx;
	double** vely;
	double** velz;	
	
	eigvec = readIn2dstr("eigvec.dat");
	vel = readIn2dDouble("dump_1_1.vel");
	//cout << eigvec.size() << endl;
	//cout << eigvec[0].size() << endl;
	eigveccomp = str2d2complex2d(eigvec);
        velx = f_vel (vel, natom, ntstep, 0 );
	vely = f_vel (vel, natom, ntstep, 1 );
	velz = f_vel (vel, natom, ntstep, 2 );
	//cout << eigveccomp.size() << endl;
	eigkv = f_eigkv(eigveccomp, natomucell, natom, 0, 0);
	qdot = f_qdot(eigkv,velx,vely,velz,natom,ntstep);
	//for(int i=0; i<ntstep; i++)
	//	cout << qdot[i];
	sed = f_nmd(qdot,ntstep);
	for(int i=0; i<ntstep; i++)
		cout << sed[i];
			
	return 0;
}

