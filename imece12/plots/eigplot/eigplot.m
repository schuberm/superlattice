x=load('x0.dat');
eigvec=dlmread('eigvec.dat');
vel=load('dump_1_1.vel');

NMD.x0.LJ.eps = 1.67E-21;              %aJ (1.67E-21 Joules) aJ=1E-18 J
NMD.x0.LJ.sigma = 3.4E-10;
NMD.x0.LJ.mass = 6.6326E-26;   
NMD.x0.LJ.tau = sqrt((NMD.x0.LJ.mass*(NMD.x0.LJ.sigma))/NMD.x0.LJ.eps);

outout=[vel(:,1),vel(:,2),vel(:,3)]
dlmwrite('vel.csv',outout,'delimiter',',','precision', '%.6f');
outout=[x(:,3),x(:,4),x(:,5)]
dlmwrite('x0.csv',outout,'delimiter',',','precision', '%.6f');

for imode = 20:1:3*(length(x(:,1)))
    eig=repmat(eigvec(1:length(eigvec(1,:)),imode),3*length(x(:,1))/length(eigvec(1,:)),1);
    outout=[eig(1:3:size(eig,1)),eig(2:3:size(eig,1)),eig(3:3:size(eig,1))];
	
    plot3(x(:,3),x(:,4),x(:,5),'.');
    %x0=[x(:,3),x(:,4),x(:,5)];
    %ev=[eig(1:3:size(eig,1)),eig(2:3:size(eig,1)),eig(3:3:size(eig,1))]
    %hold on
    %arrow3(x0,real(ev),'1.5_b')
    %x(:,1)='b'; 
    hold on
    geom_file = fopen('eigvec.plt', 'wt');
    fprintf(geom_file,'TITLE= "Eigenvector-Sam H" \n');
    fprintf(geom_file,'VARIABLES= "I","J","K","U","V","W"  \n');
    fprintf(geom_file, ['ZONE T="U profile", I = ',num2str(ceil(max(x(:,3)))),', J = ',num2str(ceil(max(x(:,4)))),', K = ',num2str(ceil(max(x(:,5)))),', F=POINT \n']);

    for K = 1 : length(x(:,3)) 
                fprintf(geom_file,'%4.0f %4.0f %4.0f %4.4f %4.4f %4.4f \n', ceil(x(K,3)+1) , ceil(x(K,4)+1 ), ceil(x(K,5)+1) , abs(outout(K,1)), abs(outout(K,2)), abs(outout(K,3)));
          
    end
    fclose(geom_file);
   
   q=quiver3(x(:,3),x(:,4),x(:,5),eig(1:3:size(eig,1)),...
     eig(2:3:size(eig,1)),... 
     eig(3:3:size(eig,1)),2,'color','b','LineWidth',1.0);
	 %view(-37.5,30);
    view(15,60) 
    xlim([0 max(x(:,3))])
    ylim([0 max(x(:,4))])
    zlim([0 max(x(:,5))])

    quiver3(x(:,3),x(:,4),x(:,5),vel(:,1),vel(:,2),vel(:,3),2,'color','r','LineWidth',1.0);
    light('position',[-1 -1 -1],'style','local')
    light('position',[0 1 1]), lighting gouraud
    set(gca, ...
  	'Box'         , 'on'     , ...
	'YGrid'       , 'off'      , ...
	'XGrid'       , 'off'      , ...
	'ZGrid'       , 'off'      , ...
	'XTick'       ,   []       , ...
  	'YTick'       ,   []       , ...
	'ZTick'       ,   []       , ...
  	'LineWidth'   , 1        );
  	%'units',       'inches', ...
  	%'Position', [1 1 5 5]);

%set(gcf, 'PaperPositionMode', 'auto');
	print -depsc2 eigplot.eps	
 	pause
end

