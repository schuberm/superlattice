function plotwvk

NMD.x0.LJ.eps = 1.67E-21;              
NMD.x0.LJ.sigma = 3.4E-10;
NMD.x0.LJ.mass = 6.6326E-26;
NMD.x0.LJ.tau = sqrt((NMD.x0.LJ.mass*(NMD.x0.LJ.sigma)^2)/NMD.x0.LJ.eps);
kb = 1.3806E-23; 

%period=[4,6,8,10,12]
period=[4,12,24]
%period=[4,12]
%colour=['b','c','g','m','r','k']
colour=['b','r','g']

for i=1:1:length(period)
    str_freq=strcat(num2str(period(i)),'p_freq.dat');
    str_vel=strcat(num2str(period(i)),'p_vel.dat');
    str_x0=strcat(num2str(period(i)),'p_x0.dat');
    str_life=strcat(num2str(period(i)),'p_life.dat');
    [f,ip,cp]=omegabin(str_freq,str_vel,str_life,str_x0);
    
    legstr{i}=strcat(num2str(period(i)),'p');
   %h(i)=semilogx(f(1:length(diff(cp,3))),diff(cp,3),colour(i),'LineWidth',1.5)
    h(i)=semilogx(f,smooth(cp),colour(i),'LineWidth',1.5)
    trapz(smooth(cp))
    hold on
    %semilogx(f(1:length(diff(cp))),diff(cp),colour(i),'LineWidth',2);

    %str_freq=strcat(num2str(period(i)),'p_freq_0.8.dat');
    %str_vel=strcat(num2str(period(i)),'p_vel_0.8.dat');
    %str_x0=strcat(num2str(period(i)),'p_x0_0.8.dat');
    %str_life=strcat(num2str(period(i)),'p_life_0.8.dat');

    %[f,ip,cp]=omegabin(str_freq,str_vel,str_life,str_x0);
    %semilogx(f(1:length(diff(cp,3))),diff(cp,3),colour(i),'LineWidth',1.5,'LineStyle','-.')
    %semilogx(f,smooth(cp),colour(i),'LineWidth',1.5,'LineStyle','-.')
    %trapz(smooth(cp))
    ylim([0 0.07]) 
    yL = get(gca,'YLim');
    line([period(i)*2*0.78161*NMD.x0.LJ.sigma period(i)*2*0.78161*NMD.x0.LJ.sigma],yL,'Color',colour(i));
end

    %str_freq=strcat('bulk_freq.dat');
    %str_vel=strcat('bulk_vel.dat');
    %str_x0=strcat('bulk_x0.dat');
    %str_life=strcat('bulk_life.dat');
    %[f,ip,cp]=omegabin(str_freq,str_vel,str_life,str_x0);
    
    %semilogx(f,smooth(cp),'k','LineWidth',1.5)

xlabel('Phonon Mean Free Path $$[m]$$','interpreter','latex','FontSize',11)
ylabel('$$\kappa$$ contribution $$[arb. units]$$','interpreter','latex','FontSize',11)
%ylabel('Thermal Conductivity $$[W m^{-1} K^{-1}]$$','interpreter','latex','FontSize',12)
line([2.5*NMD.x0.LJ.sigma 2.5*NMD.x0.LJ.sigma],yL,'Color','y');
legend(h,legstr); 

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
print -depsc2 MFP_perfect_contribution.eps

end

function [fkw,kwip,kwcp]=omegabin(str_freq,str_vel,str_life,str_vol)

NMD.x0.LJ.eps = 1.67E-21;              
NMD.x0.LJ.sigma = 3.4E-10;
NMD.x0.LJ.mass = 6.6326E-26;
NMD.x0.LJ.tau = sqrt((NMD.x0.LJ.mass*(NMD.x0.LJ.sigma)^2)/NMD.x0.LJ.eps);
kb = 1.3806E-23; 

ff=reshape(load(str_freq)',[],1);
vel=load(str_vel)*(NMD.x0.LJ.sigma/NMD.x0.LJ.tau);
lifetime=load(str_life);
x0=load(str_vol);

NUM_ATOMS=x0(1,1);
L(1) = x0(1,3); L(2) = x0(1,4); L(3) = x0(1,5); 
VOLUME = (L(1)*L(2)*L(3)*NMD.x0.LJ.sigma^3);

velx=reshape(vel(:,1),size(lifetime,2),size(lifetime,1))';
vely=reshape(vel(:,2),size(lifetime,2),size(lifetime,1))';
velz=reshape(vel(:,3),size(lifetime,2),size(lifetime,1))';

kappax = sum(sum((kb/VOLUME).*lifetime.*((velx).^2)))
kappay = sum(sum((kb/VOLUME).*lifetime.*(vely.^2)))
kappaz = sum(sum((kb/VOLUME).*lifetime.*(velz.^2)))
khs = 3/2*(pi/6)^(1/3)*kb*(NUM_ATOMS/VOLUME)^(2/3)*(0.8*max(reshape(velx.',[],1)));

ll=reshape(lifetime.',[],1);
vx=reshape(velx.',[],1);
vy=reshape(vely.',[],1);
vz=reshape(velz.',[],1);


%m(:,1)=ff;
m(:,1)=sqrt(vel(:,1).^2+vel(:,2).^2+vel(:,3).^2).*ll;
m(:,2)=(kb/VOLUME).*ll.*(vx.^2);
m(:,3)=((kb/VOLUME).*ll.*(vy.^2)+(kb/VOLUME).*ll.*(vz.^2))/2;


m=sortrows(m,1);
indices = find(m(:,1)==0);
m(indices,:) = [];

kwcp=zeros(200,1);
kwip=zeros(200,1);
dw=floor(length(m(:,1))/length(kwcp));
fdw=max(m(:,1))/length(kwcp);
fkw=fdw*(1:1:length(kwcp));

for j=2:1:length(kwcp)
    [I]=logical(fdw*(j-1)<m(:,1) & m(:,1)<fdw*j );
    %kwcp(j)=kwcp(j-1)+sum(m(I,2));
    %kwip(j)=kwip(j-1)+sum(m(I,3));
    kwcp(j)=sum(m(I,2))/kappax;
    kwip(j)=sum(m(I,3))/((kappay+kappaz)/2);
end

%semilogx(fdw*(1:1:length(kw)),kw,'o')
end


