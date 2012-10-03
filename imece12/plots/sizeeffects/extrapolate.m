NMD.x0.LJ.eps = 1.67E-21;              
NMD.x0.LJ.sigma = 3.4E-10;
NMD.x0.LJ.mass = 6.6326E-26;
NMD.x0.LJ.tau = sqrt((NMD.x0.LJ.mass*(NMD.x0.LJ.sigma)^2)/NMD.x0.LJ.eps);
kb = 1.3806E-23; 

%12p
%K=[0.1380,0.1805,0.1954];
%L=[75.0348,112.5522,150.0696];

%K=[0.1805,0.1954];
%L=[112.5522,150.0696];


%14p
K=[0.1729,0.1861];
L=[131.3109,175.0812]

p = polyfit(1./L,1./K,1)

plot(1./L,1./K,'o');
hold
plot(1./L, p(1)*1./L+p(2))

Kfit =  p(1) * 1./L + p(2);
Kresid = 1./K - Kfit;
SSresid = sum(Kresid.^2);
SStotal = (length(1./K)-1) * var(1./K);
rsq = 1 - SSresid/SStotal

1./p(2)