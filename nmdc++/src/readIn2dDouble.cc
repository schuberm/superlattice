#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <vector>

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
