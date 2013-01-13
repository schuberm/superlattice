function NMD=m_ald_superlattice_stringchanges( NMD )

NMD.ald.filename = strcat(NMD.ald.matlab.lib,'/ald.temp.in');

NMD.ald.orig(1).str = 'EPSILON';
NMD.ald.change(1).str = num2str(NMD.x0.LJ.eps);
NMD.ald.orig(2).str = 'SIGMA';
NMD.ald.change(2).str = num2str(NMD.x0.LJ.sigma);
NMD.ald.orig(3).str = 'ATOM_MASS_1';
NMD.ald.change(3).str = num2str(NMD.x0.amass(1)*1.660538921E-27,'%1.5e');
NMD.ald.orig(4).str = 'ATOM_MASS_2';
NMD.ald.change(4).str = num2str(NMD.x0.amass(2)*1.660538921E-27,'%1.5e');
if strcmp(NMD.x0.type(2).str,'GAMMA')
  NMD.ald.orig(5).str = 'ALATX';
  NMD.ald.change(5).str = num2str(NMD.x0.LJ.sigma.*NMD.x0.alat(1)*NMD.x0.superlattice.period(1,1)*NMD.x0.Nx);
  NMD.ald.orig(6).str = 'ALATY';
  NMD.ald.change(6).str = num2str(NMD.x0.LJ.sigma.*NMD.x0.alat(1)*NMD.x0.superlattice.period(2,2)*NMD.x0.Ny);
  NMD.ald.orig(7).str = 'ALATZ';
  NMD.ald.change(7).str = num2str(NMD.x0.LJ.sigma.*NMD.x0.alat(1)*NMD.x0.superlattice.period(3,3)*NMD.x0.Nz);
else
  NMD.ald.orig(5).str = 'ALATX';
  NMD.ald.change(5).str = num2str(NMD.x0.LJ.sigma.*NMD.x0.alat(1));
  NMD.ald.orig(6).str = 'ALATY';
  NMD.ald.change(6).str = num2str(NMD.x0.LJ.sigma.*NMD.x0.alat(2));
  NMD.ald.orig(7).str = 'ALATZ';
  NMD.ald.change(7).str = num2str(NMD.x0.LJ.sigma.*NMD.x0.alat(3));
end
NMD.ald.orig(8).str = 'NX';
NMD.ald.change(8).str = num2str(NMD.x0.Nx);
NMD.ald.orig(9).str = 'NY';
NMD.ald.change(9).str = num2str(NMD.x0.Ny);
NMD.ald.orig(10).str = 'NZ';
NMD.ald.change(10).str = num2str(NMD.x0.Nz);
NMD.ald.orig(11).str = 'NUMATOMSUCELL';
NMD.ald.change(11).str = num2str(length(NMD.x0.superlattice.direct(:,1)));


%gulp = m_coords2gulp( NMD.gulp, NMD.x0 )

%NMD.ald.orig(9).str = 'COORDS';
%NMD.ald.change(9).str = gulp.coords;


NMD = m_coords2ald( NMD )

NMD.ald.orig(12).str = 'COORDS';
NMD.ald.change(12).str = NMD.ald.coords;
end
