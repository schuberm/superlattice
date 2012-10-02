kpt=load('kptlist.dat');
nmode=96;
sample=1024;
nseeds=1;

for h=1:1:length(kpt(:,1))
    dummy=zeros(sample,nmode+1);
    for iseed=1:nseeds
        %str_read_single=strcat('SED_',num2str(kpt(h,1)),...
        %num2str(kpt(h,2)),num2str(kpt(h,3)),'_',int2str(iseed),'.txt');
        str_read_single=strcat('SED_-1-1-1_1.txt');
        dummy = dummy+dlmread(str_read_single);
    end
    dummy = dummy./nseeds;
    %dlmwrite(strcat('SED_',num2str(kpt(h,1)),...
    %    num2str(kpt(h,2)),num2str(kpt(h,3)),'_.txt'),dummy,'delimiter',' ')
    for l=2:1:(nmode+1)
		semilogy(dummy(:,1),dummy(:,l));
		title(strcat(int2str(l),'___',int2str(h)));
		pause(1)
		%hold on
    end
    %pause
    %hold off
end
