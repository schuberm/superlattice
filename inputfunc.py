import numpy as np

#import latticmod as lt
#import strchg as stc
#import param as param

class InputParam:

	def __init__(self):
		self.Nx=4
		self.Ny=4
		self.Nz=4
		self.lattice='fcc'
		self.period=[4,1,1]
		self.alat=6.2529/4
		self.mass=[39.948,119.844]
		self.atype=['Ar1','Ar2']
		self.t_total = 2**20
		self.t_fft = 2**16
		self.t_step = 2**5
		self.dt = 0.002
		self.nseeds=5
		self.gulppath='/home/jason/GULP/gulp.4.0/Src'
		self.gulpexe='gulp_ifort'
		self.gulpwalltime=4
		self.gulpmem=2
		self.gulpcpu=1
		self.lammppath='/home/jason/lammps/lammps-2Nov10/src'
		self.lammpexe='lmp_generic'
		self.lammpwalltime=24
		self.lammpmem=2
		self.lammpcpu=8




