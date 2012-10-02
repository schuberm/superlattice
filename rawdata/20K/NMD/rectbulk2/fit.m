function fit()

clear;
NMD.x0.LJ.eps = 1.67E-21;              %aJ (1.67E-21 Joules) aJ=1E-18 J
NMD.x0.LJ.sigma = 3.4E-10;                 %Angstroms 3.4E-10 meters
NMD.x0.LJ.a_0 = 5.2686E-10/NMD.x0.LJ.sigma; %the lattice constant of Ar: http://www.infoplease.com/periodictable.php?id=18
NMD.x0.LJ.mass = 6.6326E-26;               %1E-28 kg (6.6326E-26 kg)
NMD.x0.LJ.tau = sqrt((NMD.x0.LJ.mass*(NMD.x0.LJ.sigma)^2)/NMD.x0.LJ.eps);
w_step = 2*pi/(2^16*0.002*NMD.x0.LJ.tau)
%w_step=2.2372e+10
global sys

kpt=load('kptlist.dat');
nseeds=5;
nmode=96;
numomega=1024;

for ikpt=1:1:length(kpt(:,1))
   dummy=zeros(numomega,nmode+1);
        for iseed=1:nseeds
                str_read_single=strcat('SED_',num2str(kpt(ikpt,1)),...
                num2str(kpt(ikpt,2)),num2str(kpt(ikpt,3)),'_',num2str(iseed),'.txt')
                dummy = dummy+dlmread(str_read_single);
        end
    dummy=dummy./nseeds
    %b=load(strcat('SED_',num2str(kpt(ikpt,1)),...
    %    num2str(kpt(ikpt,2)),num2str(kpt(ikpt,3)),'_1.txt'));
    sys.w=dummy(:,1);
    for imode=2:1:nmode+1
        %lifetime(ikpt,imode-1)=1/(2*lorfit(3.4E10.*b(:,imode)))/w_step;
        lifetime(ikpt,imode-1)=1/(2*lorfit(dummy(:,imode)))*NMD.x0.LJ.tau;
        pause(1)
    end
end

dlmwrite('lifetime.dat',lifetime)

function dummy = lorfit(b)
	global sys
	PT_PERC=1E-3;
    PEAK_PERC = 1.5;
    gamma_guess = 0.5;
	[Ipeak,Jpeak]=max(b);
    INV_PERC=0.5;
	w=sys.w;

	[I,J] = find(b(1:Jpeak)<PT_PERC*b(Jpeak));
    %I
    if any(I<1)
        wleft = 1;
    else
        wleft = I(length(I));
    end
    
	[I,J] = find(b(Jpeak:length(w))>PT_PERC*b(Jpeak));
	wright = Jpeak + I(length(I));
    if wright > length(b)
        wright=length(b);
    end
    
    weights = ones(length(w(wleft:wright)),1);
    weights(1:5) = INV_PERC/PT_PERC;
    weights(length(weights)-5:length(weights)) = INV_PERC/PT_PERC;
    
	lor_func = @(c,w)weights.*(c(1))./(1 + ((w - c(3))./ c(2) ).^2 );
	options = optimset('MaxIter',10000,'MaxFunEvals',10000,'ScaleProblem','Jacobian','TolX',1e-6,'TolFun',1e-6);
	c0 = [ PEAK_PERC*Ipeak, gamma_guess, w(Jpeak)];
	lb(1:length(c0)) = 0.0; 
        %ub(1:3:length(c0)) = PEAK_PERC*Ipeak; 
        ub(1:3:length(c0)) = max(b)*10; 
        ub(2:3:length(c0)) = 1000; 
        ub(3:3:length(c0)) = w(length(w));
	[c_fit,resnorm,residual,exitflag] = lsqcurvefit(lor_func,c0,w(wleft:wright),b(wleft:wright).*weights,lb,ub,options);
	resnorm
    exitflag
    dummy=c_fit(2)
	%dummy=lor_func;
    %semilogy(w(wleft:wright),lor_func(c0,w(wleft:wright))./weights)
	%hold on
	semilogy(w(wleft:wright),lor_func(c_fit,w(wleft:wright))./weights)
	hold on
	semilogy(w,b,'ro')
	hold off


