\echo :latlongtbl;

drop table if exists :latlongtbl;

create table :latlongtbl as
select 
gr_skey,
 ROW_NUMBER() OVER() AS row_id,
ST_X(ST_TRANSFORM(geom,4326)) AS LONG_WGS84,
ST_Y(ST_TRANSFORM(geom,4326)) AS LAT_WGS84
from :geomTable;

DROP INDEX IF EXISTS :indexName;
Create INDEX :indexName on  :latlongtbl (GR_SKEY);