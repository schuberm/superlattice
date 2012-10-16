clear
NMD.x0.LJ.eps = 1.67E-21;              
NMD.x0.LJ.sigma = 3.4E-10;
NMD.x0.LJ.mass = 6.6326E-26;
NMD.x0.LJ.tau = sqrt((NMD.x0.LJ.mass*(NMD.x0.LJ.sigma)^2)/NMD.x0.LJ.eps);
kb = 1.3806E-23; 

nmddat=load('periodvL_update.dat');
nmddat(1,:)=nmddat(1,:).*NMD.x0.LJ.sigma

%plot(nmddat(1,:),nmddat(2,:),'ro','MarkerFaceColor','r');
%hold on
plot(nmddat(1,:),nmddat(3,:),'ro','MarkerFaceColor','r');

%plot(nmddat(1,:),nmddat(4,:),'ro','MarkerFaceColor','r');
hold on
plot(nmddat(1,:),nmddat(5,:),'rd','MarkerFaceColor','r');
%plot(nmddat(1,:),nmddat(8,:),'gd','MarkerFaceColor','g');

%errorbar(nmddat(1,:),nmddat(2,:),0.10*nmddat(2,:),'ro','MarkerFaceColor','r')
%hold on
%errorbar(nmddat(1,:),nmddat(3,:),0.06*nmddat(3,:),'rd','MarkerFaceColor','r')

period=[2,4,6,8,10,12,14];
bulk1=1.2;
bulk3=3^(-0.5)*bulk1;
halfalat = 0.78161;

%plot(nmddat(1,:),k_avg,'--b','LineWidth',1);
plot(nmddat(1,:),nmddat(8,:),'ko','MarkerFaceColor','k');
plot(nmddat(1,:),nmddat(9,:),'kd','MarkerFaceColor','k');
plot(nmddat(1,:),nmddat(10,:),'g','LineWidth',1.5);

ylim([0 1])
xlim([0 10E-9])

hleg1=legend('Cross-Plane perfect','In-Plane perfect','Cross-Plane 0.8 diffuse','In-Plane 0.8 diffuse');
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
  'LineWidth'   , 1         ,...
  'units',       'inches', ...
  'Position', [1 1 3.5 3.5]);


set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 KvL_diffuse.eps


hold off
