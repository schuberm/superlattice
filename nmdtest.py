import numpy as np
import nmdsetup as nmdsetup
import nmd as nmd

eig=nmdsetup.Eig4nmd('eigvec.dat')
vel=nmdsetup.Vel4nmd('dump.vel')
pos=nmdsetup.Pos4nmf('x0.dat')
kpt=np.loadtxt('kptlist.dat')

testnmd=nmd.Nmd(vel,pos,eig,kpt)

print testnmd.spctEnrg(1,1)


