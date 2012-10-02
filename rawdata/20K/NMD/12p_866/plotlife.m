
kpt=load('kptlist.dat');
nmode=48;

lifetime=zeros(size(kpt,1),144);

for ikpt=1:1:length(kpt(:,1))
    lifetime(ikpt,:)=load(strcat('lifetime_',num2str(kpt(ikpt,1)),...
                num2str(kpt(ikpt,2)),num2str(kpt(ikpt,3)),'.txt'));
end

freq=load('freq.dat');
semilogy(freq,lifetime,'ro')
dlmwrite('lifetime.dat',lifetime,'delimiter',' ')