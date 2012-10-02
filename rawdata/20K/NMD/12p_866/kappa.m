clear
NMD.x0.LJ.eps = 1.67E-21;              %aJ (1.67E-21 Joules) aJ=1E-18 J
NMD.x0.LJ.sigma = 3.4E-10;                 %Angstroms 3.4E-10 meters
NMD.x0.LJ.a_0 = 5.2686E-10/NMD.x0.LJ.sigma; %the lattice constant of Ar: http://www.infoplease.com/periodictable.php?id=18
NMD.x0.LJ.mass = 6.6326E-26;               %1E-28 kg (6.6326E-26 kg)
NMD.x0.LJ.tau = sqrt((NMD.x0.LJ.mass*(NMD.x0.LJ.sigma)^2)/NMD.x0.LJ.eps);
kb = 1.3806E-23; 

x0=load('lmp.in.x0.superlattice');
NUM_ATOMS = x0(1,1); NUM_ATOMS_UCELL = x0(1,2); 
NUM_UCELL_COPIES=NUM_ATOMS/NUM_ATOMS_UCELL;
NUM_UCELL_INX = (NUM_ATOMS/NUM_ATOMS_UCELL)^(1/3);
L(1) = x0(1,3); L(2) = x0(1,4); L(3) = x0(1,5); 
LC = L(1)/(NUM_UCELL_INX);
%VOLUME = (NUM_UCELL_INX*LC*NMD.x0.LJ.sigma)^3;
VOLUME = (L(1)*L(2)*L(3)*NMD.x0.LJ.sigma^3);

lifetime=load('lifetime.dat');
freq=load('freq.dat');
vel=(load('vel.dat')*(NMD.x0.LJ.sigma/NMD.x0.LJ.tau));
velx=reshape(vel(:,1),size(lifetime,2),size(lifetime,1))';
vely=reshape(vel(:,2),size(lifetime,2),size(lifetime,1))';
velz=reshape(vel(:,3),size(lifetime,2),size(lifetime,1))';

kappax = sum(sum((kb/VOLUME).*lifetime.*(velx.^2)))
kappay = sum(sum((kb/VOLUME).*lifetime.*(vely.^2)))
kappaz = sum(sum((kb/VOLUME).*lifetime.*(velz.^2)))
