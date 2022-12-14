library(faibDataManagement)

gr_skey_tif_2_pg_geom(
  grskeyTIF = 'S:\\FOR\\VIC\\HTS\\ANA\\workarea\\PROVINCIAL\\bc_01ha_gr_skey.tif',
  maskTif = 'S:\\FOR\\VIC\\HTS\\ANA\\workarea\\PROVINCIAL\\BC_Lands_and_Islandsincluded.tif',
  cropExtent = c(273287.5,1870587.5,367787.5,1735787.5),
  outCropTifName = 'D:\\Projects\\provDataProject\\gr_skey_cropped.tif',
  connList = faibDataManagement::get_pg_conn_list(),
  pgtblname = "whse.all_bc_gr_skey"  
  )