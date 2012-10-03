function [ f, mfp1, mfp2 ]=diffuse(str_freq,str_vel,str_life,str_vol,str_kpt,period)

NMD.x0.LJ.eps = 1.67E-21;              
NMD.x0.LJ.sigma = 3.4E-10;
NMD.x0.LJ.mass = 6.6326E-26;
NMD.x0.LJ.tau = sqrt((NMD.x0.LJ.mass*(NMD.x0.LJ.sigma)^2)/NMD.x0.LJ.eps);
kb = 1.3806E-23;
c= 299792458;

ff=reshape(load(str_freq)',[],1)./NMD.x0.LJ.tau;
vel=load(str_vel)*(NMD.x0.LJ.sigma/NMD.x0.LJ.tau);
lifetime=load(str_life);
size(lifetime)
x0=load(str_vol);
kpt=load(str_kpt);
magkpt=zeros(length(kpt(:,1)),1);

for l=1:1:length(kpt(:,1))
    magkpt(l)=NMD.x0.LJ.sigma*1.5*1/sqrt((kpt(l,1)/period).^2+kpt(l,2).^2+kpt(l,3).^2);
end


magkpt=repmat(magkpt,1,size(lifetime,2));
size(magkpt)

NUM_ATOMS=x0(1,1);
L(1) = x0(1,3); L(2) = x0(1,4); L(3) = x0(1,5); 
VOLUME = (L(1)*L(2)*L(3)*NMD.x0.LJ.sigma^3);

velx=reshape(vel(:,1),size(lifetime,2),size(lifetime,1))';
vely=reshape(vel(:,2),size(lifetime,2),size(lifetime,1))';
velz=reshape(vel(:,3),size(lifetime,2),size(lifetime,1))';

kappax = sum(sum((kb/VOLUME).*lifetime.*((velx).^2)));
kappay = sum(sum((kb/VOLUME).*lifetime.*(vely.^2)));
kappaz = sum(sum((kb/VOLUME).*lifetime.*(velz.^2)));
khs = 3/2*(pi/6)^(1/3)*kb*(NUM_ATOMS/VOLUME)^(2/3)*(0.8*max(reshape(velx.',[],1)));

ll=reshape(lifetime.',[],1);
vx=reshape(velx.',[],1);
vy=reshape(vely.',[],1);
vz=reshape(velz.',[],1);
k=reshape(magkpt.',[],1);

m(:,1)=sqrt(vel(:,1).^2+vel(:,2).^2+vel(:,3).^2).*ll;
%m(:,1)=vel(:,1)./sqrt(vel(:,1).^2+vel(:,2).^2+vel(:,3).^2).*ll;
%m(:,1)=vel(:,1).*ll;
m(:,2)=m(:,1);

%f=1./ff.*c;
f=ff;
%for l=1:1:length(k)
%    if m(l,1)>k(l)/2
%        m(l,1)=0;
%    else
%       m(l,2)=0;
%    end
%end

I=m(:,1)>vel(:,1)./sqrt(vel(:,1).^2+vel(:,2).^2+vel(:,3).^2).*k;
m(:,1)=I.*m(:,1);

I=m(:,2)<=vel(:,1)./sqrt(vel(:,1).^2+vel(:,2).^2+vel(:,3).^2).*k;;
m(:,2)=I.*m(:,2);


mfp1=m(:,1);
mfp2=m(:,2);


end