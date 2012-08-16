function [ freq, p]=pfactor(str_freq,str_eig)

NMD.x0.LJ.eps = 1.67E-21;
NMD.x0.LJ.sigma = 3.4E-10;
NMD.x0.LJ.mass = 6.6326E-26;
NMD.x0.LJ.tau = sqrt((NMD.x0.LJ.mass*(NMD.x0.LJ.sigma^2))/NMD.x0.LJ.eps);

eigenvec=load(str_eig);
freq=load(str_freq)./NMD.x0.LJ.tau;

NUM_ATOMS_UCELL=length(freq(1,:))/3
nucell=length(freq(:,1));
period=NUM_ATOMS_UCELL*3;

ii=eye(natom_ucell*3);

for imode = 1:1:3*natom_ucell
     for  ikpt = 1:1:nucell
          %eig(((iucell-1)*period+1+3*natom_ucell/2):iucell*period,imode)=(1/sqrt(3)).*eig(((iucell-1)*period+1+3*natom_ucell/2):iucell*period,imode);
          %p(iucell,imode)=(sum((ii*abs(eig((iucell-1)*period+1:iucell*period,imode))).^4))/natom_ucell;
           %p(iucell,imode)=conj(eig((iucell-1)*period+1:iucell*period,imode))'*eig((iucell-1)*period+1:iucell*period,imode);
          %p(ikpt,imode)=conj(eigenvec(((NUM_ATOMS_UCELL*3)*(ikpt-1)+1) :((NUM_ATOMS_UCELL*3)*ikpt),imode))'...
          %   *eigenvec(((NUM_ATOMS_UCELL*3)*(ikpt-1)+1):((NUM_ATOMS_UCELL*3)*ikpt),imode);
          p(ikpt,imode)=norm(eigenvec(((NUM_ATOMS_UCELL*3)*(ikpt-1)+1):((NUM_ATOMS_UCELL*3)*ikpt),imode));
          %p(iucell,imode)=(norm(eig((iucell-1)*period+1:iucell*period,imode),2)).^4;
     end
end

