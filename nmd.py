import numpy as np

class Nmd:

	def __init__(self,vel,pos,eig,kpt):
			self._vel=vel
			self._pos=pos
			self._eig=eig
			self._kpt=kpt
			self._nfft=len(vel.vxts)/len(pos.x)
			self._natomucell=len(eig.x[0,:])/3
			self._nrep=self._nfft*self._pos.natoms/self._natomucell

	def autoCorr(x):
		result = np.correlate(x, x, mode='full')
		return result[result.size/2:]

	def spctEnrg(self,kindex,mode):
		spatial=2*i*pi*(self._pos.x/self._pos.lx*self._kpt[kindex,0]+
			self._pos.y/self._pos.ly*self._kpt[kindex,1]+
			self._pos.z/self._pos.lz*self._kpt[kindex,2])
		qdot=exp(spatial)*(tile(self._eig.x(kindex,mode),(self._nrep,1))*self._vel.vxts+
		tile(self._eig.y(kindex,mode),(self._nrep,1))*self._vel.vyts+
		tile(self._eig.z(kindex,mode),(self._nrep,1))*self._vel.vzts)
		return np.fft(autoCorr(qdot))



