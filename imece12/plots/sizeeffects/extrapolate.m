function extrapolate

NMD.x0.LJ.eps = 1.67E-21;              
NMD.x0.LJ.sigma = 3.4E-10;
NMD.x0.LJ.mass = 6.6326E-26;
NMD.x0.LJ.tau = sqrt((NMD.x0.LJ.mass*(NMD.x0.LJ.sigma)^2)/NMD.x0.LJ.eps);
kb = 1.3806E-23; 

cp=load('CPperfect.dat');
len=load('length.dat');
kext=zeros(1,length(cp(1,:)));

for l=1:1:length(cp(1,:))
	kext(l)=linfitkappa(len(:,l),cp(:,l))
end
nmddat=load('periodvL_update.dat');
nmddat(1,:)=nmddat(1,:).*NMD.x0.LJ.sigma;
plot(nmddat(1,:),cp(1,:),'r')
hold on
plot(nmddat(1,:),cp(2,:),'g')
plot(nmddat(1,:),cp(3,:),'k')
plot(nmddat(1,:),kext)


period=[2,4,6,8,10,12,14];
bulk1=1.2;
bulk3=3^(-0.5)*bulk1;
halfalat = 0.78161;

CP_GK=zeros(2,length(period));
IP_GK=zeros(2,length(period));

for i=1:1:length(period)
    str_cp=strcat(num2str(period(i)),'p_CP_GK.dat')
    str_ip=strcat(num2str(period(i)),'p_IP_GK.dat')
    cp=load(str_cp);
    ip=load(str_ip);
    CP_GK(1,i)=mean(cp(:,1))
    CP_GK(2,i)=std(cp(:,1))
    IP_GK(1,i)=mean(ip(:,1))
    IP_GK(2,i)=std(ip(:,1))
    IP_diff(i)=(period(i)*halfalat*bulk1+period(i)*halfalat*bulk3)...
        /(period(i)*halfalat+period(i)*halfalat);
    CP_diff(i)=(period(i)*halfalat+period(i)*halfalat)...
        /(period(i)*halfalat*1/bulk1+period(i)*halfalat*1/bulk3);
    k_avg(i)=(bulk1+bulk3)/2
end


errorbar(nmddat(1,:),CP_GK(1,:),CP_GK(2,:),'bo');
%errorbar(nmddat(1,:),IP_GK(1,:),IP_GK(2,:),'bd');
%plot(nmddat(1,:),IP_diff,'-.g','LineWidth',1.5);
plot(nmddat(1,:),CP_diff,'--g','LineWidth',1.5);

legend('4x6x6','6x6x6','8x6x6','Extrapolated from NMD','GK');
xlabel('Period Length $$[m]$$','interpreter','latex','FontSize',14);
ylabel('Thermal Conductivity $$[W m^{-1} K^{-1}]$$','interpreter','latex','FontSize',14)

set(gca, ...
  'Box'         , 'on'     , ...
  'TickDir'     , 'in'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'on'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'on'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'LineWidth'   , 1         , ...
  'units',       'inches', ...
  'Position', [1 1 3.5 3.5]);


set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 sizeeffects.eps

end

function kext=linfitkappa(L,K)

p = polyfit(1./L,1./K,1)

%plot(1./L,1./K,'o');
%hold;
%plot(1./L, p(1)*1./L+p(2));

Kfit =  p(1) * 1./L + p(2);
Kresid = 1./K - Kfit;
SSresid = sum(Kresid.^2);
SStotal = (length(1./K)-1) * var(1./K);
rsq = 1 - SSresid/SStotal

kext=1./p(2)

end
