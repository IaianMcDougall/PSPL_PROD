set search_path = :schema;

-- List BAPIDs of lng polygons to be used
drop table if exists :.bapid_overlaps;
Create table :.bapid_overlaps as

with t1 as
(select
a.gr_skey,
a.teis_id,
case when b.bapid is Not NULL
		then b.bapid
	 when c.bapid is Not NULL
		then c.bapid
else NULL
end as bapid
from :teisGrskeyTab a
left outer join :pemlngtable b on a.teis_id = b.teis_id
left outer join :temlngtable c on a.teis_id = c.teis_id
group by gr_skey),

t2 as (
SELECT  gr_skey,array_arg(bapid, order by bapid) as bapid_overlaps
from t1
group by gr_skey
)

select bapid_overlaps, count(*) as area from t1
group by bapid_overlaps
;