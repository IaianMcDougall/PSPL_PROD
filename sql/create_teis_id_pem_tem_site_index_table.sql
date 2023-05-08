set search_path = :schema;

drop table if exists :teis_id_pem_tem_si;
Create table :teis_id_pem_tem_si as

with t1 as
(select 
teis_id,
unnest(species1_xwalk) as species1,
unnest(si1) as si1,
coalesce(sdec_1,0) as sdec_1
from :longTableSkinny_filter
where use = 1),

t2 as
(select 
teis_id,
unnest(species2_xwalk) as species2,
unnest(si2) as si2,
coalesce(sdec_2,0) as sdec_2
from :longTableSkinny_filter
where use = 1),

t3 as
(select 
teis_id,
unnest(species3_xwalk) as species3,
unnest(si3) as si3,
coalesce(sdec_3,0) as sdec_3
from :longTableSkinny_filter
where use = 1),

t4 as
(select
case when a.teis_id is Null
		then b.teis_id
	when  b.teis_id is Null
		then a.teis_id
	else a.teis_id
end as teis_id,
case when species1 is Null
		then species2
	when species2 is Null
		then species1
	else species1
end as species,
species1,
species2,
si1,
si2,
coalesce(sdec_1,0) as sdec_1,
coalesce(sdec_2,0) as sdec_2
from t1 a
full outer join t2 b on a.teis_id = b.teis_id and  species1 = species2),

t5 as (select
case when a.teis_id is Null
		then b.teis_id
	when  b.teis_id is Null
		then a.teis_id
	else a.teis_id
end as teis_id,
case when species is Null
		then species3
	when species3 is Null
		then species
	else species
end as species,
species1,
species2,
species3,

coalesce(si1,0) as si1,
coalesce(si2,0) as si2,
coalesce(si3,0) as si3,
coalesce(sdec_1,0) as sdec_1,
coalesce(sdec_2,0) as sdec_2,
coalesce(sdec_3,0) as sdec_3,
coalesce(sdec_1,0) + coalesce(sdec_2,0) + coalesce(sdec_3,0) as total_species_sdec,
case when (coalesce(sdec_1,0) + coalesce(sdec_2,0) + coalesce(sdec_3,0)) > 0
    	then   coalesce(si1,0) * (coalesce(sdec_1,0)::double precision/(coalesce(sdec_1,0) + coalesce(sdec_2,0) + coalesce(sdec_3,0))) +
	   		   coalesce(si2,0) * (coalesce(sdec_2,0)::double precision/(coalesce(sdec_1,0) + coalesce(sdec_2,0) + coalesce(sdec_3,0))) +
	 		   coalesce(si3,0) * (coalesce(sdec_3,0)::double precision/(coalesce(sdec_1,0) + coalesce(sdec_2,0) + coalesce(sdec_3,0))) 
	 else 0
	 
end as site_index
from t4 a
full outer join t3 b on a.teis_id = b.teis_id and  species = species3
order by case when a.teis_id is Null
		then b.teis_id
	when  b.teis_id is Null
		then a.teis_id
	else a.teis_id
end,
case when species is Null
		then species3
	when species3 is Null
		then species
	else species
end)


SELECT teis_id,
      MAX(CASE WHEN species ='Acb' THEN site_index END) as acb_si_pem_tem,
      MAX(CASE WHEN species ='At' THEN site_index END) as at_si_pem_tem,
      MAX(CASE WHEN species ='Ba' THEN site_index END) as ba_si_pem_tem,
      MAX(CASE WHEN species ='Bg' THEN site_index END) as bg_si_pem_tem,
      MAX(CASE WHEN species ='Bl' THEN site_index END) as bl_si_pem_tem,	  
      MAX(CASE WHEN species ='Cw' THEN site_index END) as cw_si_pem_tem,	  
      MAX(CASE WHEN species ='Dr' THEN site_index END) as dr_si_pem_tem,	  
      MAX(CASE WHEN species ='Ep' THEN site_index END) as ep_si_pem_tem,	  
      MAX(CASE WHEN species ='Fd' THEN site_index END) as fd_si_pem_tem,	  
      MAX(CASE WHEN species ='Hm' THEN site_index END) as hm_si_pem_tem,	  
      MAX(CASE WHEN species ='Hw' THEN site_index END) as hw_si_pem_tem,	  
      MAX(CASE WHEN species ='Lw' THEN site_index END) as lw_si_pem_tem,	  
      MAX(CASE WHEN species ='Pa' THEN site_index END) as pa_si_pem_tem,	  
      MAX(CASE WHEN species ='Pl' THEN site_index END) as pl_si_pem_tem,
      MAX(CASE WHEN species ='Pw' THEN site_index END) as pw_si_pem_tem,	  
      MAX(CASE WHEN species ='Py' THEN site_index END) as py_si_pem_tem,	  
      MAX(CASE WHEN species ='Sb' THEN site_index END) as sb_si_pem_tem,	  
      MAX(CASE WHEN species ='Se' THEN site_index END) as se_si_pem_tem,	  
      MAX(CASE WHEN species ='Ss' THEN site_index END) as ss_si_pem_tem,	  
      MAX(CASE WHEN species ='Sw' THEN site_index END) as sw_si_pem_tem,
      MAX(CASE WHEN species ='Sx' THEN site_index END) as sx_si_pem_tem,
      MAX(CASE WHEN species ='Yc' THEN site_index END) as yc_si_pem_tem
  FROM t5
 GROUP BY teis_id
 

----------------------------



























