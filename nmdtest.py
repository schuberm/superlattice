import numpy as np
import nmdsetup as nmdsetup
import nmd as nmd

eig=nmdsetup.Eig('eigvec.dat')
vel=nmdsetup.Vel('dump.vel')
pos=nmdsetup.Pos('x0.dat')
kpt=np.loadtxt('kptlist.dat')

testnmd=nmd.Nmd(vel,pos,eig,kpt)

print testnmd.spctEnrg(1,1)


