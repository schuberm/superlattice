    geom_file = fopen('ScanA_GDL2_structure_200.plt', 'wt');
    fprintf(geom_file,'TITLE= "Geometry-Aydin Nabovati" \n');
    fprintf(geom_file,'VARIABLES= "I","J","K","U","V","W"  \n');
    fprintf(geom_file, ['ZONE T="U profile", I = ',num2str(NX),', J = ',num2str(NY),', K = ',num2str(NZ),', F=POINT \n']);

    for K = 1 : NZ 
        for J = 1 : NY 
            for I = 1 : NX 
                fprintf(geom_file,'%4.0f %4.0f %4.0f %4.0f  %4.0f %4.0f \n', I , J , K , U(I,J,K), V(I,J,K), W(I,J,K) );
            end
        end
    end
    fclose(geom_file);
