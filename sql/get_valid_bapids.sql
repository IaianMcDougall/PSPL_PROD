-- List BAPIDs of lng polygons to be used
drop table if exists :.bapid_overlaps;
Create table :.bapid_overlaps as

with t1 as
(select
a.gr_skey,
 array_arg(b.bapid, order by bapid) as bapid_overlaps
from :teisGrskeyTab a
left outer join :lngtable b on a.teis_id = b.teis_id
group by gr_skey)

select bapid_overlaps, count(*) as area from t1
group by bapid_overlaps
;