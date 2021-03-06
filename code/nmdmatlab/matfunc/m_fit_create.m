function m_fit_create(NMD)

iseed=1;

if isfield(NMD,'cofreq')

	freq=load(strcat(NMD.str.main,'/freq.dat'));
	[I,J]=find(freq<NMD.cofreq);

	for ii=1:1:length(I)
		%NMD_ISEED_IKSLICE.sh------------------------------------------------------        
		str.orig = 'fit_temp';
		str.change = ['fit_' int2str(I(ii)) '_' int2str(J(ii))];
		str.cmd1 = ['-e ''s/\<' str.orig '\>/' str.change '/g'' '];
		str.orig = 'runpath';
		str.change = strcat(NMD.str.main,'/',int2str(NMD.seed.superlattice) );
		str.temp = strcat('-e ''s|',str.orig,'|',str.change);
		str.cmd2 = [str.temp '|g'' '];
		str.orig = 'fit_TEMP.m';
		str.change = ['fit_' int2str(I(ii)) '_' int2str(J(ii)) '.m'];
		str.cmd3 = ['-e ''s/\<' str.orig '\>/' str.change '/g'' '];
		str.cmd4 =...
		['fit.sh.temp > ./' int2str(NMD.seed.superlattice) '/fit_' int2str(I(ii)) '_' int2str(J(ii)) '.sh'];


		str.cmd = ['sed ' str.cmd1 str.cmd2 str.cmd3 str.cmd4];
		system(str.cmd);
		%NMD_ISEED_IKSLICE.m-------------------------------------------------------        
		str.orig = 'ISEED';
		str.change = [int2str(1)];
		str.cmd1 = ['-e ''s/\<' str.orig '\>/' str.change '/g'' '];
		str.orig = 'IMSLICE';
		str.change = [int2str(I(ii))];
		str.cmd2 = ['-e ''s/\<' str.orig '\>/' str.change '/g'' '];
		str.orig = 'IMODE'
		str.change = strcat(int2str(J(ii)))
		str.cmd3 = ['-e ''s/\<' str.orig '\>/' str.change '/g'' '];
		str.cmd4 =...
		['fit.m.temp > ./' int2str(NMD.seed.superlattice) '/fit_' int2str(I(ii)) '_' int2str(J(ii)) '.m'];
		str.cmd = ['sed ' str.cmd1 str.cmd2 str.cmd3 str.cmd4];
		system(str.cmd);
		%NMD_submit.sh------------------------------------------------------------- 
		if strcmp(NMD.env,'gilgamesh') 	
			output =...
			['qsub -l walltime=' int2str(NMD.matlab.walltime)...
			':00:00,nodes=' int2str(NMD.matlab.cpu)...
			',mem=' int2str(NMD.matlab.mem)...
			'gb fit_' int2str(I(ii)) '_' int2str(J(ii)) '.sh'];

			str.write = strcat(NMD.str.main,'/',int2str(NMD.seed.superlattice),'/fit_submit.sh');
			dlmwrite(str.write,output,'-append','delimiter','');
	elseif strcmp(NMD.env,'ntpl')
		str.tmp=strcat(NMD.str.main,'/')
		output =['qsub  ' str.tmp int2str(NMD.seed.superlattice) '/NMD_' int2str(I(ii)) '_' int2str(J(ii)) '.sh'];

		str.write = strcat(NMD.str.main,'/',int2str(NMD.seed.superlattice),'/fit_submit.sh');
		dlmwrite(str.write,output,'-append','delimiter','');
	end


end


else 

	for imode = 1:NMD.NUM_MODESLICES
		%NMD_ISEED_IKSLICE.sh------------------------------------------------------        
		str.orig = 'fit_temp';
		str.change = ['fit_' int2str(iseed) '_' int2str(imode)];
		str.cmd1 = ['-e ''s/\<' str.orig '\>/' str.change '/g'' '];
		str.orig = 'runpath';
		str.change = strcat(NMD.str.main,'/',int2str(NMD.seed.superlattice) );
		str.temp = strcat('-e ''s|',str.orig,'|',str.change);
		str.cmd2 = [str.temp '|g'' '];
		str.orig = 'fit_TEMP.m';
		str.change = ['fit_' int2str(iseed) '_' int2str(imode) '.m'];
		str.cmd3 = ['-e ''s/\<' str.orig '\>/' str.change '/g'' '];
		str.cmd4 =...
		['fit.sh.temp > ./' int2str(NMD.seed.superlattice) '/fit_' int2str(iseed) '_' int2str(imode) '.sh'];


		str.cmd = ['sed ' str.cmd1 str.cmd2 str.cmd3 str.cmd4];
		system(str.cmd);
		%NMD_ISEED_IKSLICE.m-------------------------------------------------------        
		str.orig = 'ISEED';
		str.change = [int2str(iseed)];
		str.cmd1 = ['-e ''s/\<' str.orig '\>/' str.change '/g'' '];
		str.orig = 'IMSLICE';
		str.change = [int2str(imode)];
		str.cmd2 = ['-e ''s/\<' str.orig '\>/' str.change '/g'' '];
		str.cmd3 =...
		['fit.m.temp > ./' int2str(NMD.seed.superlattice) '/fit_' int2str(iseed) '_' int2str(imode) '.m'];
		str.cmd = ['sed ' str.cmd1 str.cmd2 str.cmd3];
		system(str.cmd);
		%NMD_submit.sh------------------------------------------------------------- 
		if strcmp(NMD.env,'gilgamesh') 	
			output =...
			['qsub -l walltime=' int2str(NMD.matlab.walltime)...
			':00:00,nodes=' int2str(NMD.matlab.cpu)...
			',mem=' int2str(NMD.matlab.mem)...
			'gb fit_' int2str(iseed) '_' int2str(imode) '.sh'];

			str.write = strcat(NMD.str.main,'/',int2str(NMD.seed.superlattice),'/fit_submit.sh');
			dlmwrite(str.write,output,'-append','delimiter','');
	elseif strcmp(NMD.env,'ntpl')
		str.tmp=strcat(NMD.str.main,'/')
		output =['qsub  ' str.tmp int2str(NMD.seed.superlattice) '/NMD_' int2str(iseed) '_' int2str(imode) '.sh'];

		str.write = strcat(NMD.str.main,'/',int2str(NMD.seed.superlattice),'/fit_submit.sh');
		dlmwrite(str.write,output,'-append','delimiter','');
	end

end

end

end
