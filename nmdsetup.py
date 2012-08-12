#Author samuel.huberman@gmail.com

import numpy as np

class Pos:

	def __init__(self,file_name=None):
		self._file_name=file_name
		self._all=np.loadtxt(str(file_name),skiprows=17)

	def natoms(self):
		return len(self._all[:,0])

	def x(self):
		return self._all[:,2]

	def y(self):
		return self._all[:,3]

	def z(self):
		return self._all[:,4]
	def lx(self):
#		return np.maximum(self._all[:,2])
		return self._all[-1,2]
	def ly(self):
#               return np.maximum(self._all[:,3]) 
		return self._all[-1,3]
	def lz(self):
#               return np.maximum(self._all[:,4]) 
		return self._all[-1,4]
class Vel:

	def __init__(self,file_name=None):
		self._file_name=file_name
		self._all=np.loadtxt(str(file_name),comments='--')

	def vxts(self):
		return self._all[:,0]

	def vyts(self):
		return self._all[:,1]

	def vzts(self):
		return self._all[:,2]
	def nvel(self):
		return len(self._all[:,0])
class Eig:

	def __init__(self,file_name=None):
		self._file_name=file_name
		self._all=np.loadtxt(str(file_name),dtype=complex)

	def x(self,kindex=None,mode=None):
		if kindex == None and mode == None:
			return self._all[0::3,:]
		if mode != None and kindex == None:
			return self._all[0::3,mode]
		else:
			return self._all[len(self._all[0,:])*kindex:(len(self._all[0,:])*(kindex+1)-1):3,mode]

	def y(self,kindex=None,mode=None):
		if kindex == None and mode == None:
			return self._all[1::3,:]
		if mode != None and kindex == None:
			return self._all[1::3,mode]
		else:
			return self._all[len(self._all[0,:])*kindex+1:(len(self._all[0,:])*(kindex+1)):3,mode]

	def z(self,kindex=None,mode=None):
		if kindex == None and mode == None:
			return self._all[2::3,:]
		if mode != None and kindex == None:
			return self._all[2::3,mode]
		else:
			return self._all[len(self._all[0,:])*kindex+2:(len(self._all[0,:])*(kindex+1)+1):3,mode]

	def natomucell(self):
		return len(self._all[0,:])/3

class Nmd:

	def __init__(self,vel,pos,eig,kpt):
			self._vel=vel
			self._pos=pos
			self._eig=eig
			self._kpt=kpt
			self._nfft=vel.nvel()/pos.natoms()
			self._natomucell=eig.natomucell()
			self._nrep=self._nfft*pos.natoms()/self._natomucell

	def genscript(self,nseeds):
		for j in range(nseeds):
			for i in range(len(self._kpt[:,0])):
				print_file = open('nmd_'+str(j)+'_'+str(i)+'.py', 'w')
				print_file.write('import numpy as np\n')
				print_file.write('import nmdsetup as nmdsetup\n')
				print_file.write('import sys\n')
				print_file.write('\n')
				print_file.write('eig=nmdsetup.Eig('"'"+str(self._eig._file_name)+"'"')\n')
				print_file.write('pos=nmdsetup.Pos('"'"+str(self._pos._file_name)+"'"')\n')
				print_file.write('kpt=np.loadtxt('"'kptlist.dat'"')\n')
				print_file.write('\n')
				print_file.write('for i in range('+str(self._nfft)+'):\n')
				print_file.write('\tvel=nmdsetup.Vel('"'dump_"+str(j)+"_'"'+str(i)+'"'.vel'"')\n')
				print_file.write('\tfor j in range('+str(3*self._natomucell)+'):\n')
				print_file.write('\t\tcalc=nmdsetup.Nmd(vel,pos,eig,kpt)\n')
				print_file.write('\t\tnp.savetxt('"'SED_"+str(i)+".out'"',calc.spctEnrg('+str(i)+',j))\n')

	def autoCorr(x):
		result = np.correlate(x, x, mode='full')
		return result[result.size/2:]

	def spctEnrg(self,kindex,mode):

		spatial=2*np.complex(0,1)*np.pi*(self._pos.x()/self._pos.lx()*self._kpt[kindex,0]+
			self._pos.y()/self._pos.ly()*self._kpt[kindex,1]+
			self._pos.z()/self._pos.lz()*self._kpt[kindex,2])
		qdot=np.exp(spatial)*(np.tile(self._eig.x(kindex,mode),(self._nrep,1)).flatten(1)*self._vel.vxts()+
		np.tile(self._eig.y(kindex,mode),(self._nrep,1)).flatten(1)*self._vel.vyts()+
		np.tile(self._eig.z(kindex,mode),(self._nrep,1)).flatten(1)*self._vel.vzts())
		return np.fft.fft(np.correlate(qdot,qdot,mode='full'))

