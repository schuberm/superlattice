function m_ald_create_in(NMD)

NMD = m_ald_superlattice_stringchanges( NMD );
m_change_file_strings(...
NMD.ald.filename , NMD.ald.orig, strcat(NMD.gulp.str.main,'/',num2str(NMD.x0.superlattice.period(1,1)),'p_ald.in') , NMD.ald.change);

end
