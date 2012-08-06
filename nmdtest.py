import numpy as np
import matplotlib.pyplot as plt
import nmdsetup as nmdsetup
import nmd as nmd

eig=nmdsetup.Eig('eigvec.dat')
vel=nmdsetup.Vel('dump.vel')
pos=nmdsetup.Pos('x0.dat')
kpt=np.loadtxt('kptlist.dat')

testnmd=nmd.Nmd(vel,pos,eig,kpt)

#print testnmd.spctEnrg(1,1)
plt.plot(np.real(testnmd.spctEnrg(1,1)))
plt.show()

