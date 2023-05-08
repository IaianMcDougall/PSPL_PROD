set search_path = :schema;




drop table if exists :clean_teis_id_gr_skey;
Create table :clean_teis_id_gr_skey as
with 
t1 as (select 
gr_skey,
unnest(teis_id_overlaps) as teis_id,
unnest(a.bapid_overlaps) as bapid,
teis_id_overlaps,
a.bapid_overlaps,
a.bapidjoin,
winners
from  :teisBapidOverlapTbl a
left outer join :completeWinnersPG b on a.bapidjoin = b.bapidjoin)

select * 
from t1 
where  bapid = winners;

----------------------------

