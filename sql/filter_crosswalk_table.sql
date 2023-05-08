set search_path = :schema;

--Create table of crosswalk rows where source does not match
drop table if exists :xwalk_source_mismatch;
Create table :xwalk_source_mismatch as
select 
distinct x.*, lk.source

from :updxwalk x join
:sibeclookupunique lk
on x.BGC_UNIT_X = lk.bgcunit and x.SITE_S_X = lk.siteseries and x.REGION_X = lk.region and x.source_x != lk.source;

--filter cross walk table by only keeping rows with SIBEC values
drop table if exists :xwalk_filtered;
Create table :xwalk_filtered as
select 
x.*
lookup, 
species, 
si,
lk.bgcunit as bgcunit,
lk.siteseries,
lk.region,
lk.source,
x.bapid || '~' || x.bgc_unit || '~' || x.site_s || '~' || x.SITEMC_S || '~' || x.seral as xwalkkey

from :updxwalk x left outer join
:sibeclookupunique lk
on x.BGC_UNIT_X = lk.bgcunit and x.SITE_S_X = lk.siteseries and x.REGION_X = lk.region and x.source_x = lk.source;

drop index if exists filtered_xwalk_ogc_inx;
create index filtered_xwalk_ogc_inx on :xwalk_filtered(xwalkkey);

