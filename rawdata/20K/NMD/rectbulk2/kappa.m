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

w_step = 2*pi/(2^16*0.002*NMD.x0.LJ.tau);
lifetime=load('lifetime.dat')%./w_step./NMD.x0.LJ.tau;

lifetime(1,2)

vel=(load('vel.dat')*(NMD.x0.LJ.sigma/NMD.x0.LJ.tau));
velx=reshape(vel(:,1),size(lifetime,2),size(lifetime,1))';
vely=reshape(vel(:,2),size(lifetime,2),size(lifetime,1))';
velz=reshape(vel(:,3),size(lifetime,2),size(lifetime,1))';

kappax = sum(sum((kb/VOLUME).*lifetime.*((velx).^2)))
kappay = sum(sum((kb/VOLUME).*lifetime.*(vely.^2)))
kappaz = sum(sum((kb/VOLUME).*lifetime.*(velz.^2)))
khs = 3/2*(pi/6)^(1/3)*kb*(NUM_ATOMS/VOLUME)^(2/3)*(0.8*max(reshape(velx.',[],1)))

ll=reshape(lifetime.',[],1);
ll(2)
vx=reshape(velx.',[],1);
vy=reshape(vely.',[],1);
vz=reshape(velz.',[],1);
ff=reshape(load('freq.dat')',[],1);

m(:,1)=ff;
%m(:,1)=sqrt(vx.^2+vy.^2+vz.^2).*ll;
%m(:,1)=sqrt(vel(:,1).^2+vel(:,2).^2+vel(:,3).^2).*ll;
m(:,2)=(kb/VOLUME).*ll.*(vx.^2);
sum(m(:,2))
%m(:,3)=vx

m=sortrows(m,1);
%m = m(all(m,2),:);
indices = find(m(:,1)==0);
m(indices,:) = [];

m(1,:);
max(m(:,1));
%hist(m)
semilogy(m(:,1),m(:,2),'o')
%n_elements = histc(m(:,2),m(:,1))
%c_elements = cumsum(n_elements)
%bar(1:length(m(:,1)),c_elements,'BarWidth',1)

kw=zeros(100,1);
dw=floor(length(m(:,1))/length(kw));
fdw=max(m(:,1))/length(kw);

for j=1:1:length(kw)
    [I]=logical(fdw*(j-1)<m(:,1) & m(:,1)<fdw*j );
    kw(j)=sum(m(I,2));
end
dw*j;
sum(kw);

semilogx(fdw*(1:1:length(kw)),kw,'o')
