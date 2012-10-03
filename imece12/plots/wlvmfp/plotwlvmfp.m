function plotwlvmfp

NMD.x0.LJ.eps = 1.67E-21;              
NMD.x0.LJ.sigma = 3.4E-10;
NMD.x0.LJ.mass = 6.6326E-26;
NMD.x0.LJ.tau = sqrt((NMD.x0.LJ.mass*(NMD.x0.LJ.sigma)^2)/NMD.x0.LJ.eps);
kb = 1.3806E-23;
c= 299792458;

%period=[4,6,8,10,12,16]
period=[4];
colour=['b','m','g','c','r','k'];

figure

for i=1:1:length(period)
    str_freq=strcat(num2str(period(i)),'p_freq.dat');
    str_vel=strcat(num2str(period(i)),'p_vel.dat');
    str_x0=strcat(num2str(period(i)),'p_x0.dat');
    str_life=strcat(num2str(period(i)),'p_life.dat');
    str_kpt=strcat(num2str(period(i)),'p_kptlist.dat');
    str_eig=strcat(num2str(period(i)),'p_eigvec.dat');
    [f,mfp1,mfp2]=diffuse(str_freq,str_vel,str_life,str_x0,str_kpt,period(i));
    
    %subplot(3,1,i,'align')
    %axis tight
    %subplot('Position',[0.1*i 0.1*i 0.5 0.5])
    %h(i)=semilogy(f,mfp1,'o','color','b','MarkerSize',3)
    %hold on
    %(i)=semilogy(f,mfp2,'o','color','r','MarkerSize',3)
    %legstr{i}=strcat(num2str(period(i)),'p');
    h(i)=semilogy(f,mfp1,'o','color',colour(i),'MarkerSize',3)
    hold on
    h(i)=semilogy(f,mfp2,'o','color',colour(i+1),'MarkerSize',3)
    %[ n1, xout1, freq1,life1, n2, xout2,freq2,life2 ]=ldos(str_freq,str_x0,str_kpt,str_life,str_eig,str_vel,period(i));
    
    %[n1, xout1] = hist(f,40);
    
    %plot(xout1,n1,'b')
    %hold on
    %plot(xout2,n2,'r')
    %f=load(str_freq)./NMD.x0.LJ.tau;
    %[n,xout]=hist(f(:),40);
    %plot(xout,n,'g')
    %[AX,H1,H2]=plotyy(xout1,n1,freq1,life1,'plot','semilogy')
    %axes(AX(1))
    %set(H1,'LineStyle','-','Color','b')
    %axes(AX(2))
    %axis tight
    %set(H2,'LineStyle','o','color','b')
    %plot(xout1,n1,'b');
    
    %[AX,H1,H2]=plotyy(xout2,n2,f,mfp2,'plot','semilogy')
    %[AX,H1,H2]=plotyy(xout2,n2,freq2,life2,'plot','semilogy')
    %set(H1,'LineStyle','-','Color','r')
    %set(H2,'LineStyle','o','color','r')
    
    ylabel('MFP $$[m]$$','interpreter','latex','FontSize',14)
    
    yL = get(gca,'YLim');
    %line([period(i)*1*0.78161*NMD.x0.LJ.sigma period(i)*1*0.78161*NMD.x0.LJ.sigma],yL,'Color','r')
    
    xL = get(gca,'XLim');
    line(xL,[period(i)*1*0.78161*NMD.x0.LJ.sigma period(i)*1*0.78161*NMD.x0.LJ.sigma],'Color','r')
    
    %semilogy(bulk(:,1),bulk(:,3)/(2*pi/(2^16*0.002*NMD.x0.LJ.tau)),'ro','MarkerSize',3);
    
    %set(gca, ...
  %'Box'         , 'on'     , ...
  %'TickDir'     , 'in'     , ...
  %'TickLength'  , [.02 .02] , ...
  %'XMinorTick'  , 'off'      , ...
  %'YMinorTick'  , 'on'      , ...
  %'YGrid'       , 'off'      , ...
  %'XColor'      , [.3 .3 .3], ...
  %'YColor'      , [.3 .3 .3], ...
  %'LineWidth'   , 1         );
    
end

xlabel('Frequency $$[Hz]$$','interpreter','latex','FontSize',14)
%ylabel('Lifetime $$[s]$$','interpreter','latex','FontSize',14)
%legend(h,legstr); 
%samexaxis('xmt','on','ytac','join','yld',1)

set(gcf, 'PaperPositionMode', 'auto');
strprint=strcat(num2str(period(1)), 'p_MFPvomega.eps')
print -depsc2 16p_MFPvomega.eps
%print -depsc2 strprint

end





