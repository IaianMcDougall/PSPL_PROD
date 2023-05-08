set search_path = :schema;

-- List BAPIDs of lng polygons to be used
drop table if exists :teisBapidOverlapTbl;
Create table :teisBapidOverlapTbl as

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
from :teisGrskeyTbl a
left outer join :pemfilterTbl b on a.teis_id = b.teis_id
left outer join :temfilterTbl c on a.teis_id = c.teis_id 
),

t2 as (select
a.*,
b.proj_type,
b.proj_name,
b.esil,
b.aa_compl,
b.tsr_appr,
b.aa_level,
b.compl_date,
b.approved

from t1 a
left outer join pspl.bapids b on a.bapid = b.bapid
)

SELECT  gr_skey,
ARRAY_TO_STRING(array_agg(bapid order by bapid), '-','') as bapidjoin,
array_agg(bapid order by bapid) as bapid_overlaps,
array_agg(approved order by bapid) as approved_overlaps,
array_agg(teis_id order by bapid) as teis_id_overlaps,
array_agg(proj_type order by bapid) as proj_type_overlaps,
array_agg(proj_name order by bapid) as proj_name_overlaps,
array_agg(compl_date order by bapid) as compl_date_overlaps,
array_agg(esil order by bapid) as esil_overlaps,
array_agg(aa_compl order by bapid) as aa_compl_overlaps,
array_agg(tsr_appr order by bapid) as tsr_appr_overlaps,
array_agg(aa_level order by bapid) as aa_level_overlaps
from t2
group by gr_skey;

----------- Create table of every overlapping bapid combination and the relavant corresponding attributes for each bapid  

drop table if exists :bapidOverlapTbl;
Create table :bapidOverlapTbl as
select 
bapid_overlaps, 
ARRAY_TO_STRING(bapid_overlaps, '-','') as bapidjoin,
count(*) as area ,
approved_overlaps,
proj_type_overlaps,
proj_name_overlaps,
compl_date_overlaps,
esil_overlaps,
aa_compl_overlaps,
tsr_appr_overlaps,
aa_level_overlaps

from :teisBapidOverlapTbl
group by
approved_overlaps,
compl_date_overlaps,
bapid_overlaps,
proj_type_overlaps,
proj_name_overlaps,
esil_overlaps,
aa_compl_overlaps,
tsr_appr_overlaps,
aa_level_overlaps;


---------- JOin the list of overlap winners previous created in 2021 to the overlapping bapid combination table

drop table if exists :bapidOverlapTblwin;
Create table :bapidOverlapTblwin as
with t1 as
(select ROW_NUMBER() OVER() as fid,
case when bapid1 <= bapid2
 		then bapid1
 	else bapid2
end as bapida,
case when bapid2 >= bapid1
 		then bapid2
 	else bapid1
end as bapidb,
*
 from :previousWinnerPG),

t2 as (select bapida || '-' || bapidb as bapidjoin, *
from t1 )

select 
ARRAY_LENGTH(bapid_overlaps, 1) as num_of_overlaps,
case when ARRAY_LENGTH(bapid_overlaps, 1) = 1  then a.bapidjoin::integer
	 when winner > 0 then winner
	 else Null
end as winners,
a.*
from :bapidOverlapTbl a left outer join  t2 b on a.bapidjoin = b.bapidjoin
order by
 ARRAY_LENGTH(bapid_overlaps, 1),
case when ARRAY_LENGTH(bapid_overlaps, 1) = 1  then a.bapidjoin::integer
	 when winner > 0 then winner
	 else Null
end
;





