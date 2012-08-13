import numpy as np
#import matplotlib.pyplot as plt
import nmdsetup as nmdsetup
import inputfunc as ipf
import sys

userin=ipf.InputParam()
print userin.t_fft

eig=nmdsetup.Eig('eigvec.dat')
print eig._file_name
vel=nmdsetup.Vel('dump.vel')
pos=nmdsetup.Pos('x0.dat')
kpt=np.loadtxt('kptlist.dat')

testnmd=nmdsetup.Nmd(vel,pos,eig,kpt,userin)

#testnmd.genscript(1)

#print testnmd.spctEnrg(1,1)



