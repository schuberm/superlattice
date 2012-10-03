function [ n1, xout1,f1,life1, n2, xout2, f2,life2]=ldos(str_freq,str_vol,str_kpt,str_life,str_eig,str_vel,nmonolayer)

NMD.x0.LJ.eps = 1.67E-21;              %aJ (1.67E-21 Joules) aJ=1E-18 J
NMD.x0.LJ.sigma = 3.4E-10;
NMD.x0.LJ.mass = 6.6326E-26;
NMD.x0.LJ.tau = sqrt((NMD.x0.LJ.mass*(NMD.x0.LJ.sigma^2))/NMD.x0.LJ.eps);

x_min=0.78161;

eig=load(str_eig);
freq=load(str_freq)./NMD.x0.LJ.tau;
x=load(str_vol);
kpt=load(str_kpt);
lifetime=load(str_life);
vel=load(str_vel);
magkpt=zeros(length(kpt(:,1)),1);

for l=1:1:length(kpt(:,1))
    magkpt(l)=NMD.x0.LJ.sigma*x_min*2/sqrt((kpt(l,1)/nmonolayer).^2+kpt(l,2).^2+kpt(l,3).^2);
end

magkpt=repmat(magkpt,1,size(lifetime,2));

velx=reshape(vel(:,1),size(lifetime,2),size(lifetime,1))';
vely=reshape(vel(:,2),size(lifetime,2),size(lifetime,1))';
velz=reshape(vel(:,3),size(lifetime,2),size(lifetime,1))';

mfp=sqrt(velx.^2+vely.^2+velz.^2).*lifetime;

natom_ucell=x(1,2);
nucell=x(1,1)/x(1,2);
period=natom_ucell*3;
match=size(eig,1)/period;


mask=repmat(x(2:natom_ucell+1,3)<=(nmonolayer*x_min),1,3);
%mask=repmat(x(2:end,3)<=(nmonolayer*x_min),1,3);
V1=reshape(mask.',[],1) ;
mask=repmat(x(2:natom_ucell+1,3)>(nmonolayer*x_min),1,3);

V3=reshape(mask.',[],1);
%V3
%pause
for imode = 1:1:3*natom_ucell
	%p(imode)=(eig(:,imode).*V)^2;
     for iucell = 1:1:nucell
         eig(((iucell-1)*period+1+3*natom_ucell/2):iucell*period,imode)=(1/sqrt(3)).*eig(((iucell-1)*period+1+3*natom_ucell/2):iucell*period,imode);
         %size(eig(((iucell-1)*period+1+3*natom_ucell/2):iucell*period,imode))
         checkzero1=sum(abs(eig((iucell-1)*period+1:iucell*period,imode)...
                        .*V1));
         checkzero3=sum(abs(eig((iucell-1)*period+1:iucell*period,imode)...
                        .*V3));
            %size(eig((iucell-1)*period+1:iucell*period,imode))
            %size(V3)
        %checkzero=sum(abs(repmat(eig((iucell-1)*period+1:iucell*period,imode),match,1).*V));
        %checkzero=nnz(repmat(eig((iucell-1)*period+1:iucell*period,imode),match,1).*V);
        if checkzero1<2 
            %&& checkzero3>1
         p(iucell,imode)=0;
           %quiver3(x(2:natom_ucell+1,3),x(2:natom_ucell+1,4),x(2:natom_ucell+1,5),...
           %eig((iucell-1)*period+1:3:iucell*period,imode),...
	       %eig((iucell-1)*period+2:3:iucell*period,imode),...
	       %eig((iucell-1)*period+3:3:iucell*period,imode));
	       %view(0,0);
          %pause
         q(iucell,imode)=1;
        elseif checkzero3<2
         q(iucell,imode)=0;
         p(iucell,imode)=1;
        else
         p(iucell,imode)=1;
         q(iucell,imode)=1;
        end
     end
end
[i]=find(p>0);
[n1, xout1] = hist(freq(i),40);
life1=mfp(i);
%life1=lifetime(i);
f1=freq(i);

[i]=find(q>0);
[n2, xout2] = hist(freq(i),40);
life2=lifetime(i);
f2=freq(i);

