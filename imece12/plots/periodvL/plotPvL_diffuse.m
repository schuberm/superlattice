clear
NMD.x0.LJ.eps = 1.67E-21;              
NMD.x0.LJ.sigma = 3.4E-10;
NMD.x0.LJ.mass = 6.6326E-26;
NMD.x0.LJ.tau = sqrt((NMD.x0.LJ.mass*(NMD.x0.LJ.sigma)^2)/NMD.x0.LJ.eps);
kb = 1.3806E-23; 
kappabulk=1.2;

nmddat=load('periodvL_update.dat');
nmddat(1,:)=nmddat(1,:).*NMD.x0.LJ.sigma

plot(nmddat(1,:),nmddat(3,:)./kappabulk,'ro','MarkerFaceColor','r');
hold on
plot(nmddat(1,:),nmddat(5,:)./kappabulk,'rd','MarkerFaceColor','r');
plot(nmddat(1,:),nmddat(8,:)./kappabulk,'ko','MarkerFaceColor','k');
plot(nmddat(1,:),nmddat(9,:)./kappabulk,'kd','MarkerFaceColor','k');
%plot(nmddat(1,:),nmddat(10,:)./kappabulk,'g','LineWidth',1.5);

ylim([0 1])
xlim([0 10E-9])

hleg1=legend('Cross-Plane perfect','In-Plane perfect','Cross-Plane 0.8 diffuse','In-Plane 0.8 diffuse');
legend('boxoff','Location','NorthEastOutside')
xlabel('Period Length $$[m]$$','interpreter','latex','FontSize',14);
ylabel('$$\kappa/ \kappa_{bulk}$$','interpreter','latex','FontSize',14)

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
