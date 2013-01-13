#include <iostream>
#include <math.h>
#include <fftw3.h>
#include <vector>
#include <string>
#include <sstream>
#include <fstream>
#include <stdio.h>
#include <iterator>
#include<complex.h>

std::vector< std::vector<double> > readIn2dData(const char* filename)
{
    std::vector< std::vector<double> > table; 
    std::fstream ifs;
    ifs.open(filename);

    while (true)
    {
        std::string line;
        double buf;

        getline(ifs, line);	
        std::stringstream ss(line, std::ios_base::out|std::ios_base::in|std::ios_base::binary);

        if (!ifs)
            break;
        if (line[0] == '#' || line.empty() || line == "--" )
            continue;
        std::vector<double> row;
        while (ss >> buf){
            	row.push_back(buf);           
	}
	table.push_back(row);
    }
    ifs.close();
    return table;
}

std::vector< std::vector<_Complex double> > readIn2dComplex(const char* filename)
{
    std::vector< std::vector<_Complex double> > table; 
    std::fstream ifs;
    ifs.open(filename);

    while (true)
    {
        std::string line;
        _Complex buf;

        getline(ifs, line);	
        std::stringstream ss(line, std::ios_base::out|std::ios_base::in|std::ios_base::binary);

        if (!ifs)
            break;
        if (line[0] == '#' || line.empty() || line == "--" )
            continue;
        std::vector<_Complex double> row;
        while (ss >> buf){
            	row.push_back(buf);           
	}
	table.push_back(row);
    }
    ifs.close();
    return table;
}


std::vector< std::vector<double> > velvec (const std::vector< std::vector<double> > &vel,const int  &natom, const int &ntstep, const int dir )
{
    std::vector< std::vector<double> > table;
	for (int i=0; i<natom ;i++){
		std::vector<double> row;
		for (int j=0; j<ntstep ;j++){
			row.push_back(vel[j*(natom)+i][dir]);
		}
		table.push_back(row);
	}
   return table;
}


///*
int main () {
	const int atom=256;
	const int tstep=2048;
	std::vector< std::vector<double> > vel;
	std::vector< std::vector<double> > velx,vely,velz;
	std::vector< std::vector<_Complex double> > eig;
	vel = readIn2dData("dump_1_1.vel");
	std::cout << vel.size() << std::endl;
	velx = velvec(vel, atom, tstep, 0);
	vely = velvec(vel, atom, tstep, 1);
	velz = velvec(vel, atom, tstep, 2);	
	std::cout << velx[1][1] << std::endl;
	eig = readIn2dComplex("eigvec.dat");
	std::cout << eig[4][1] << std::endl;	
	return 0;
}
/*/
/*
int main() {

    std::fstream infile;
    infile.open("dump_1_1.vel");
    while (true)
    {
	std::string line;
 	getline(infile, line);
	std::cout << line << std::endl;	
    }
    infile.close();
    return 0;
}

/*
int main()
{
        std::string line = "12 14 16 18 20 24";

        std::stringstream is(line);
        int n;
        while (is >> n)
                std::cout << n << std::endl;

        return 0;
}
*/
