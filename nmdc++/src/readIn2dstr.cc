#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <vector>

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