clear
for i=1:1:10
%--------------------------------------------------------------------------
    [tmp,str.main]=system('pwd');
%str.main='/home/jason/lammps/LJ/amorphous/12x/prepare/';
%--------------------------------------------------------------------------

GK.dt_lj = 0.002; 
GK.sample_rate = 5;

GK.Lx = 50.0232 ; GK.Ly = 9.3794; GK.Lz = 9.3794;

GK.VOLUME = GK.Lx*GK.Ly*GK.Lz;


GK.SEEDS=[1,2,3,4,5,6,7,8,9,10]
GK.SEEDS(i)=[]

%--------------------------------------------------------------------------
 %GK.SEEDS(i)=[]
%--------------------------------------------------------------------------
GK.NUM_SEEDS=size(GK.SEEDS,2);
%--------------------------------------------------------------------------
GK.Tset = [20];
GK.NUM_TEMPS=size(GK.Tset,2);

GK.p = 5; GK.s = 25000; GK.d = GK.p*GK.s;
GK.total_steps = 500000;

%--------------------------------------------------------------------------



%--------------LJ----------------------------------------------------------
LJ.eps = 1.67E-21;              
LJ.sigma = 3.4E-10;                
LJ.mass = 6.6326E-26;               
LJ.tau = sqrt((LJ.mass*(LJ.sigma^2))/LJ.eps);
%--------------constants---------------------------------------------------
con.kb = 1.3806E-23;                  
con.hbar = 1.054E-34;      
con.i = sqrt(-1);
con.c = 29979245800.00019;      %cm/s
con.s2ps = 1E-12;
con.ang2m = 1E-10;
con.eV2J = 1.60217646E-19;
%--------------GK----------------------------------------------------------
GK.scaleJ = (LJ.eps)/((LJ.sigma^2)*LJ.tau);
%this includes the factor of 1/V
GK.dt = GK.dt_lj*LJ.tau;




%Average over seeds

GK.JJ(1:GK.s,1:2)=0;
GK.JJ(:,1,1) = (0:(size(GK.JJ,1)-1)')*GK.dt*GK.sample_rate;

    for iseed = 1:GK.NUM_SEEDS
%grep the JJ dump
        str.cmd = ['grep -A ' int2str(GK.s) ' "'...
            int2str(GK.total_steps) ' '...
            int2str(GK.s) '" J0Jt_' int2str(GK.SEEDS(iseed)) ...
            '.dat > J0Jt_'  int2str(GK.SEEDS(iseed)) ...
            'grep.dat'];
        system(str.cmd);
%average the grep JJ                 
        str.read = ['J0Jt_' int2str(GK.SEEDS(iseed)) ...
            'grep.dat'];
        dummy=dlmread(str.read);
      
       %GK.JJ(:,2) = GK.JJ(:,2) +...
       %    ((dummy(2:length(dummy),5)+dummy(2:length(dummy),6))/2);
       GK.JJ(:,2) = GK.JJ(:,2) +...
           (dummy(2:length(dummy),4));
%system volume
    end
    GK.JJ(:,2) = GK.JJ(:,2)/GK.NUM_SEEDS;
%    GK.VOLUME(itemp) = (GK.VOLUME(itemp)/GK.NUM_SEEDS);
%this is needed if you don't divide by vol in lammps    
    GK.JJ(:,2) = GK.JJ(:,2)/(GK.VOLUME^2);
    

   

%convert to real units
GK.VOLUME =GK.VOLUME*LJ.sigma^3;
GK.JJ(:,2) = GK.JJ(:,2)*GK.scaleJ^2;

%plot(GK.JJ(:,1,1),GK.JJ(:,2,1))
%--------------------------------------------------------------------------
%pause
%--------------------------------------------------------------------------        
                    

GK.intJJ( 1:size(GK.JJ(:,1)) ) = 0;    

for itemp=1:GK.NUM_TEMPS

            
    GK.intJJ(:) = cumtrapz(GK.JJ(:,1,1),GK.JJ(:,2))*...
        (GK.VOLUME/(con.kb*(GK.Tset^2)));

  %  plot(GK.JJ(:,1)/con.s2ps,GK.intJJ(:))
  %  xlabel('t (ps)','FontSize',24); 
  %  ylabel('\kappa (W/m-K)' ,'FontSize',24);
            
%--------------------------------------------------------------------------
%pause
%--------------------------------------------------------------------------   

%plot(GK.intJJ(:))
%pause
%plot(GK.intJJ(:)./max(GK.intJJ(:)))
%hold on
%plot(GK.JJ(:,2,1)./max(GK.JJ(:,2,1)))
%max(GK.intJJ(:))
%pause

%left = input('left ');
%CP
left = 7000
%IP
%left = 7000
%right = input('right ');
%CP
right = 8000
%IP
%right = 10000

GK.kappa(1) = mean(GK.intJJ(left:right));
GK.kappa(2) = std(GK.intJJ(left:right));

%output JJavg
str.write = strcat(str.main,'/JJavg.dat');
output = [GK.JJ(:,1,1) GK.JJ(:,2)];
dlmwrite(str.write,output,'delimiter',' ');

%output kappa


end

%output kappa

str.write = strcat(str.main,'/8p_CP_GK.dat');
output = [GK.kappa]

dlmwrite(str.write,output,'delimiter',' ','-append');

end


