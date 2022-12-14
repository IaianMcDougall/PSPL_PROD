library(faibDataManagement)

faibDataManagement::add_batch_2_pg_grskey_grid(
  inCSV = 'D:/Projects/PSPL_2022/IAIAN_VERSION/R_SCRIPTS/inputs/inputsDatasets2load2PG.csv',
  connList = faibDataManagement::get_pg_conn_list(),
  oraConnList = faibDataManagement::get_ora_conn_list(),
  cropExtent = c(273287.5,1870587.5,367787.5,1735787.5),
  gr_skey_tbl = 'all_bc_gr_skey',
  wrkSchema = 'whse',
  rasSchema = 'raster',
  grskeyTIF = 'S:\\FOR\\VIC\\HTS\\ANA\\workarea\\PROVINCIAL\\bc_01ha_gr_skey.tif',
  maskTif='S:\\FOR\\VIC\\HTS\\ANA\\workarea\\PROVINCIAL\\BC_Lands_and_Islandsincluded.tif',
  dataSourceTblName = 'data_sources',
  setwd='D:/Projects/PSPL_2022/IAIAN_VERSION/R_SCRIPTS',
  outTifpath = 'D:/Projects/PSPL_2022/IAIAN_VERSION',
  importrast2pg = FALSE

)

keyring::key_get('dbservicename', keyring = 'oracle')
