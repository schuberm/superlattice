clear
NMD.x0.LJ.eps = 1.67E-21;              
NMD.x0.LJ.sigma = 3.4E-10;
NMD.x0.LJ.mass = 6.6326E-26;
NMD.x0.LJ.tau = sqrt((NMD.x0.LJ.mass*(NMD.x0.LJ.sigma)^2)/NMD.x0.LJ.eps);
kb = 1.3806E-23; 

nmddat=load('periodvL.dat');
nmddat(1,:)=nmddat(1,:).*NMD.x0.LJ.sigma

%plot(nmddat(1,:),nmddat(2,:),'ro','MarkerFaceColor','r');
%hold on
%plot(nmddat(1,:),nmddat(3,:),'rd','MarkerFaceColor','r');

errorbar(nmddat(1,:),nmddat(2,:),0.10*nmddat(2,:),'ro','MarkerFaceColor','r')
hold on
errorbar(nmddat(1,:),nmddat(3,:),0.06*nmddat(3,:),'rd','MarkerFaceColor','r')

period=[1,2,4,6,8,10,12,14];
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
    CP_GK(2,i)=mean(cp(:,2))
    IP_GK(1,i)=mean(ip(:,1))
    IP_GK(2,i)=mean(ip(:,2))
    IP_diff(i)=(period(i)*halfalat*bulk1+period(i)*halfalat*bulk3)...
        /(period(i)*halfalat+period(i)*halfalat);
    CP_diff(i)=(period(i)*halfalat+period(i)*halfalat)...
        /(period(i)*halfalat*1/bulk1+period(i)*halfalat*1/bulk3);
    k_avg(i)=(bulk1+bulk3)/2
end

errorbar(nmddat(1,:),CP_GK(1,:),CP_GK(2,:),'bo');
errorbar(nmddat(1,:),IP_GK(1,:),IP_GK(2,:),'bd');
plot(nmddat(1,:),IP_diff,'-.g','LineWidth',1.5);
plot(nmddat(1,:),CP_diff,'--g','LineWidth',1.5);
%plot(nmddat(1,:),k_avg,'--b','LineWidth',1);
plot(nmddat(1,:),nmddat(4,:),'g','LineWidth',1.5);

ylim([0 1])
xlim([0 10E-9])

hleg1=legend('Cross-Plane NMD','In-Plane NMD','Cross-Plane GK','In-Plane GK');
legend('boxoff','Location','NorthEastOutside')
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
  'LineWidth'   , 1         );

set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 KvL.eps


hold off