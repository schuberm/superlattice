//f_qdot.hh

#ifndef __FQDOT_HH_INCLUDED
#define __FQDOT_HH_INCLUDED

complex<double>* f_qdot (const vector< vector<complex<double> > > &eigkv, double **velx, double **vely, double **velz, const int  &natom, const int &ntstep);

#endif
