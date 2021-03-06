function sedsymmf(k,nmdpath)

str.main=nmdpath
cumsed=zeros(size(load(strcat(str.main,'SED_000.txt'))));

for t=1:1:length(k(:,1))
[I,J]=find(...
         k(:,1)== k(t,1) & k(:,2)== k(t,2) & k(:,3)== k(t,3)...
       | k(:,1)==-k(t,1) & k(:,2)== k(t,2) & k(:,3)== k(t,3)...
       | k(:,1)== k(t,1) & k(:,2)== k(t,3) & k(:,3)== k(t,2)...
       | k(:,1)==-k(t,1) & k(:,2)== k(t,3) & k(:,3)== k(t,2)...
       | k(:,1)== k(t,1) & k(:,2)==-k(t,2) & k(:,3)== k(t,3)...
       | k(:,1)==-k(t,1) & k(:,2)==-k(t,2) & k(:,3)== k(t,3)...
       | k(:,1)== k(t,1) & k(:,2)== k(t,3) & k(:,3)==-k(t,2)...
       | k(:,1)==-k(t,1) & k(:,2)== k(t,3) & k(:,3)==-k(t,2)...
       | k(:,1)== k(t,1) & k(:,2)==-k(t,2) & k(:,3)==-k(t,3)...
       | k(:,1)==-k(t,1) & k(:,2)==-k(t,2) & k(:,3)==-k(t,3)...
       | k(:,1)== k(t,1) & k(:,2)==-k(t,3) & k(:,3)==-k(t,2)...
       | k(:,1)==-k(t,1) & k(:,2)==-k(t,3) & k(:,3)==-k(t,2)...
   );

for ised=1:1:length(I)
    cumsed=cumsed+load(strcat(str.main,'SED_',num2str(k(I(ised),1)),...
		num2str(k(I(ised),2)),num2str(k(I(ised),3)),'.txt'));
end

for ised=1:1:length(I)
    dlmwrite(strcat(str.main,'SED_',num2str(k(I(ised),1)),...
	      num2str(k(I(ised),2)),num2str(k(I(ised),3)),'.txt'),...
	      cumsed./length(I),'delimiter',' ');
end

cumsed=0;
end
