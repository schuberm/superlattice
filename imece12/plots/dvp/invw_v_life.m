function plotwvk

NMD.x0.LJ.eps = 1.67E-21;              
NMD.x0.LJ.sigma = 3.4E-10;
NMD.x0.LJ.mass = 6.6326E-26;
NMD.x0.LJ.tau = sqrt((NMD.x0.LJ.mass*(NMD.x0.LJ.sigma)^2)/NMD.x0.LJ.eps);
kb = 1.3806E-23; 

%period=[4,6,8,10,12,16]
%period=[4,8,16]
period=[12]
colour=['b','g']

%bulk=load('bulk_life.dat');

figure

for i=1:1:length(period)

    str_freq=strcat(num2str(period(i)),'p_freq_0.8.dat');
    str_vel=strcat(num2str(period(i)),'p_vel_0.8.dat');
    str_x0=strcat(num2str(period(i)),'p_x0_0.8.dat');
    str_life=strcat(num2str(period(i)),'p_life_0.8.dat');

    [f,ip]=omegabin(str_freq,str_vel,str_life,str_x0);
    loglog(f,ip,'o','color',colour(i+1),'MarkerSize',3)
    hold on

    str_freq=strcat(num2str(period(i)),'p_freq.dat');
    str_vel=strcat(num2str(period(i)),'p_vel.dat');
    str_x0=strcat(num2str(period(i)),'p_x0.dat');
    str_life=strcat(num2str(period(i)),'p_life.dat');
    [f,ip]=omegabin(str_freq,str_vel,str_life,str_x0);
    
    legstr{i}=strcat(num2str(period(i)),'p');
    h(i)=loglog(f,ip,'o','color',colour(i),'MarkerSize',3)

    loglog(sort(f),sort(f),'-r');
   
end

ylabel('Lifetime $$[LJ units]$$','interpreter','latex','FontSize',12)
xlabel(' $$[2\pi \omega^-1]$$','interpreter','latex','FontSize',12)
%ylabel('Lifetime $$[s]$$','interpreter','latex','FontSize',14)
%legend(h,legstr); 
legend('0.8 diffusion','perfect'); 
%samexaxis('xmt','on','ytac','join','yld',1)

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
print -depsc2 12p_tau_v_invomega.eps

end

function [ f, mfp ]=omegabin(str_freq,str_vel,str_life,str_vol)

NMD.x0.LJ.eps = 1.67E-21;              
NMD.x0.LJ.sigma = 3.4E-10;
NMD.x0.LJ.mass = 6.6326E-26;
NMD.x0.LJ.tau = sqrt((NMD.x0.LJ.mass*(NMD.x0.LJ.sigma)^2)/NMD.x0.LJ.eps);
kb = 1.3806E-23; 

ff=reshape(load(str_freq)',[],1);
vel=load(str_vel)*(NMD.x0.LJ.sigma/NMD.x0.LJ.tau);
lifetime=load(str_life)./NMD.x0.LJ.tau;
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
khs = 3/2*(pi/6)^(1/3)*kb*(NUM_ATOMS/VOLUME)^(2/3)*(0.8*max(reshape(velx.',[],1)))

ll=reshape(lifetime.',[],1);
vx=reshape(velx.',[],1);
vy=reshape(vely.',[],1);
vz=reshape(velz.',[],1);


m(:,1)=ff;
%m(:,2)=sqrt(vel(:,1).^2+vel(:,2).^2+vel(:,3).^2).*ll;
m(:,2)=ll;

%m(:,2)=(kb/VOLUME).*ll.*(vx.^2);
%m(:,2)=((kb/VOLUME).*ll.*(vy.^2)+(kb/VOLUME).*ll.*(vz.^2))/2;

f=2*pi./ff;
mfp=m(:,2);


end



