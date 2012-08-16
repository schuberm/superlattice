

NUM_ATOMS_UCELL=4;
NUM_MODES = 3*NUM_ATOMS_UCELL;

x0.ucell.cart =      [0.0  0.0  0.0
                        0.5  0.5  0.0
                        0.5  0.0  0.5
                        0.0  0.5  0.5];

fid=fopen('eig2.dat');
dummy = textscan(fid,'%f%f%f%f%f%f%f','Delimiter','\t', 'commentStyle', '--');
fclose(fid);

eigvec = zeros(NUM_ATOMS_UCELL*3,NUM_MODES); 
for imode = 1:(NUM_MODES/3)
			eigvec(:,(imode-1)*3+1) = dummy{2}((imode-1)*3*NUM_ATOMS_UCELL+1:(imode)*3*NUM_ATOMS_UCELL) + i*dummy{3}((imode-1)*3*NUM_ATOMS_UCELL+1:(imode)*3*NUM_ATOMS_UCELL);
			eigvec(:,(imode-1)*3+2) = dummy{4}((imode-1)*3*NUM_ATOMS_UCELL+1:(imode)*3*NUM_ATOMS_UCELL) + i*dummy{5}((imode-1)*3*NUM_ATOMS_UCELL+1:(imode)*3*NUM_ATOMS_UCELL);
			eigvec(:,(imode-1)*3+3) = dummy{6}((imode-1)*3*NUM_ATOMS_UCELL+1:(imode)*3*NUM_ATOMS_UCELL) + i*dummy{7}((imode-1)*3*NUM_ATOMS_UCELL+1:(imode)*3*NUM_ATOMS_UCELL);
end

for imode = 1:1:3*NUM_ATOMS_UCELL
     for  ikpt = 1:1:1
p(imode)=conj(eigvec(((NUM_ATOMS_UCELL*3)*(ikpt-1)+1) :((NUM_ATOMS_UCELL*3)*ikpt),imode))'...
             *eigvec(((NUM_ATOMS_UCELL*3)*(ikpt-1)+1):((NUM_ATOMS_UCELL*3)*ikpt),imode)
         
    end
end

%Put Real and Imag in right place		
eigvec = zeros(3*size(x0.ucell.cart,1),3*size(x0.ucell.cart,1)); 
    for imode = 1:(3*size(x0.ucell.cart,1)/3)
        eigvec(:,(imode-1)*3+1) =...
            dummy{2}((imode-1)*3*size(x0.ucell.cart,1)+1:(imode)*3*size(x0.ucell.cart,1))...
            + i*dummy{3}((imode-1)*3*size(x0.ucell.cart,1)+1:(imode)*3*size(x0.ucell.cart,1));
        eigvec(:,(imode-1)*3+2) =...
            dummy{4}((imode-1)*3*size(x0.ucell.cart,1)+1:(imode)*3*size(x0.ucell.cart,1))...
            + i*dummy{5}((imode-1)*3*size(x0.ucell.cart,1)+1:(imode)*3*size(x0.ucell.cart,1));
        eigvec(:,(imode-1)*3+3) =...
            dummy{6}((imode-1)*3*size(x0.ucell.cart,1)+1:(imode)*3*size(x0.ucell.cart,1))...
            + i*dummy{7}((imode-1)*3*size(x0.ucell.cart,1)+1:(imode)*3*size(x0.ucell.cart,1));
    end
    
for imode = 1:1:3*NUM_ATOMS_UCELL
     for  ikpt = 1:1:1
p(imode)=conj(eigvec(((NUM_ATOMS_UCELL*3)*(ikpt-1)+1) :((NUM_ATOMS_UCELL*3)*ikpt),imode))'...
             *eigvec(((NUM_ATOMS_UCELL*3)*(ikpt-1)+1):((NUM_ATOMS_UCELL*3)*ikpt),imode)
         
    end
end

plot(p)
