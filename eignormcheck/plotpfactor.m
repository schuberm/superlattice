function plotpfactor

NMD.x0.LJ.eps = 1.67E-21;              
NMD.x0.LJ.sigma = 3.4E-10;
NMD.x0.LJ.mass = 6.6326E-26;
NMD.x0.LJ.tau = sqrt((NMD.x0.LJ.mass*(NMD.x0.LJ.sigma)^2)/NMD.x0.LJ.eps);
kb = 1.3806E-23;
c= 299792458;

%period=[4,6,8,10,12,16]
period=['8'];
colour=['b'];

figure

for i=1:1:length(period)
    str_freq=strcat(num2str(period(i)),'freq.dat');
    str_eig=strcat(num2str(period(i)),'eigvec.dat');
    [freq,p]=pfactor(str_freq,str_eig);
    plot(freq,p,'ro')
    
end


ylabel('p','interpreter','latex','FontSize',14)
xlabel('Frequency $$[Hz]$$','interpreter','latex','FontSize',14)

 set(gca, ...
  'Box'         , 'on'     , ...
  'TickDir'     , 'in'     , ...
  'TickLength'  , [.02 .02] , ...
  'XMinorTick'  , 'off'      , ...
  'YMinorTick'  , 'on'      , ...
  'YGrid'       , 'off'      , ...
  'XColor'      , [.3 .3 .3], ...
  'YColor'      , [.3 .3 .3], ...
  'LineWidth'   , 1         );

set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 pfactor.eps

end





