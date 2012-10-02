clear
NMD.x0.LJ.eps = 1.67E-21;              %aJ (1.67E-21 Joules) aJ=1E-18 J
NMD.x0.LJ.sigma = 3.4E-10;                 %Angstroms 3.4E-10 meters
NMD.x0.LJ.a_0 = 5.2686E-10/NMD.x0.LJ.sigma; %the lattice constant of Ar: http://www.infoplease.com/periodictable.php?id=18
NMD.x0.LJ.mass = 6.6326E-26;               %1E-28 kg (6.6326E-26 kg)
NMD.x0.LJ.tau = sqrt((NMD.x0.LJ.mass*(NMD.x0.LJ.sigma)^2)/NMD.x0.LJ.eps);
kb = 1.3806E-23;

kpt=load('kptlist.dat');
freq=load('freq.dat');
nmode=length(freq(1,:));

lifetime=zeros(size(kpt,1),nmode);

for ikpt=1:1:length(kpt(:,1))
    lifetime(ikpt,:)=load(strcat('lifetime_',num2str(kpt(ikpt,1)),...
                num2str(kpt(ikpt,2)),num2str(kpt(ikpt,3)),'.txt'));
end

semilogy(freq./NMD.x0.LJ.tau,lifetime,'ro')
hold
freq=reshape(freq',[],1)./NMD.x0.LJ.tau;
freq=sort(freq);
semilogy(freq, 5E13./(freq.^2),'b')
hold off
dlmwrite('lifetime.dat',lifetime,'delimiter',' ')