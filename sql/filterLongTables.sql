set search_path = :schema;


-----Add Keys to long TABLESPACE
drop table if exists :longTableSkinny;
Create table :longTableSkinny as
select
teis_id,
a.BAPID,
UPPER(COALESCE(replace(BGC_ZONE,' ',''),'')) as BGC_ZONE,
lower(COALESCE(replace(BGC_SUBZON,' ',''),'')) as BGC_SUBZON,
COALESCE(replace(BGC_ZONE,' ',''),'')  || COALESCE(replace(BGC_SUBZON,' ',''),'') || COALESCE(BGC_VRT::text,'') || COALESCE(replace(BGC_PHASE,' ',''),'')  as BGC_UNIT,
COALESCE(replace(SITE_S1_UPD,' ',''),'')  as SITE_S1,
COALESCE(replace(SITEMC_S1,' ',''),'')  as SITEMC_S1,
COALESCE(replace(SERAL_1,' ',''),'')  as SERAL_1,
COALESCE(replace(SITE_S2_UPD,' ',''),'')  as SITE_S2,
COALESCE(replace(SITEMC_S2,' ',''),'')  as SITEMC_S2,
COALESCE(replace(SERAL_2,' ',''),'')  as SERAL_2,
COALESCE(replace(SITE_S3_UPD,' ',''),'')  as SITE_S3,
COALESCE(replace(SITEMC_S3,' ',''),'')  as SITEMC_S3,
COALESCE(replace(SERAL_3,' ',''),'')  as SERAL_3,
a.BAPID || '~' ||COALESCE(replace(BGC_ZONE,' ',''),'')  || COALESCE(replace(BGC_SUBZON,' ',''),'') || COALESCE(BGC_VRT::text,'') || COALESCE(replace(BGC_PHASE,' ',''),'')  || '~' ||  COALESCE(replace(SITE_S1_UPD,' ',''),'')|| '~' || COALESCE(replace(SITEMC_S1,' ',''),'')|| '~' || COALESCE(replace(SERAL_1,' ',''),'') as key1,
a.BAPID || '~' ||COALESCE(replace(BGC_ZONE,' ',''),'')  || COALESCE(replace(BGC_SUBZON,' ',''),'') || COALESCE(BGC_VRT::text,'') || COALESCE(replace(BGC_PHASE,' ',''),'')  || '~' ||   COALESCE(replace(SITE_S2_UPD,' ',''),'')|| '~' || COALESCE(replace(SITEMC_S2,' ',''),'')|| '~' || COALESCE(replace(SERAL_2,' ',''),'') as key2,
a.BAPID || '~' ||COALESCE(replace(BGC_ZONE,' ',''),'')  || COALESCE(replace(BGC_SUBZON,' ',''),'') || COALESCE(BGC_VRT::text,'') || COALESCE(replace(BGC_PHASE,' ',''),'')  || '~' ||   COALESCE(replace(SITE_S3_UPD,' ',''),'')|| '~' || COALESCE(replace(SITEMC_S3,' ',''),'')|| '~' || COALESCE(replace(SERAL_3,' ',''),'') as key3,
SDEC_1,
SDEC_2,
SDEC_3,
shape_area
from :longTableUpd a
;
drop index if exists key1_ogc_inx;
create index key1_ogc_inx on :longTableSkinny(key1);
drop index if exists key2_ogc_inx;
create index key2_ogc_inx on :longTableSkinny(key2);
drop index if exists key3_ogc_inx;
create index key3_ogc_inx on :longTableSkinny(key3);

---Filter Long Tables
---Filter Long Tables
drop table if exists :longTableSkinny_filter;
Create table :longTableSkinny_filter as
with t2 as(
select a.*,
s1.bapid as bapid1_xwalk,
s2.bapid as bapid2_xwalk,
s3.bapid as bapid3_xwalk,
s1.bgc_unit as bgc_unit1_xwalk,
s2.bgc_unit as bgc_unit2_xwalk,
s3.bgc_unit as bgc_unit3_xwalk,
s1.site_s as site_s1_xwalk,
s2.site_s as site_s2_xwalk,
s3.site_s as site_s3_xwalk,
s1.species as species1_xwalk ,
s2.species as species2_xwalk ,
s3.species as species3_xwalk ,
s1.si as si1,
s2.si as si2,	
s3.si as si3,
s1.region as region1 ,
s2.region as region2 ,
s3.region as region3 ,
s1.source as source1 ,
s2.source as source2 ,
s3.source as source3 ,
s1.xwalkkey as xwalkkey1 ,
s2.xwalkkey as xwalkkey2 ,
s3.xwalkkey as xwalkkey3 ,
s1.HAB_SUBTYPE AS HAB_SUBTYPE1,
s2.HAB_SUBTYPE AS HAB_SUBTYPE2,
s3.HAB_SUBTYPE AS HAB_SUBTYPE3,
s1.HAB2_SUBTYPE AS HAB2_SUBTYPE1,
s2.HAB2_SUBTYPE AS HAB2_SUBTYPE2,
s3.HAB2_SUBTYPE AS HAB2_SUBTYPE3,
s1.Blank_Column AS Blank_Column1,
s2.Blank_Column AS Blank_Column2,
s3.Blank_Column AS Blank_Column3,
case 
	when s1.si is not Null
		then 'IN SIBEC'
	when (UPPER(s1.HAB_SUBTYPE) in 
			('CONIFER FOREST - DRY', 
			 'CONIFER FOREST - MESIC (AVERAGE)', 
			 'CONIFER FOREST - MOIST/WET',
             'DECIDUOUS/BROADLEAF FOREST', 
			 'MIXED FOREST (DECIDUOUS/CONIFEROUS MIX)',
             'RIPARIAN FOREST', 
			 'SHORELINE FOREST', 
			 'TREED BOG', 
			 'TREED FEN', 
			 'TREED SWAMP')
			or
			UPPER(s1.Blank_Column) in 
			('CONIFER FOREST - DRY', 
			 'CONIFER FOREST - MESIC (AVERAGE)', 
			 'CONIFER FOREST - MOIST/WET',
             'DECIDUOUS/BROADLEAF FOREST', 
			 'MIXED FOREST (DECIDUOUS/CONIFEROUS MIX)',
             'RIPARIAN FOREST', 
			 'SHORELINE FOREST', 
			 'TREED BOG', 
			 'TREED FEN', 
			 'TREED SWAMP')
			or 
			(UPPER(s1.hab_subtype) like '%FORESTED%' 
			 and not UPPER(s1.hab_subtype) like '%NON-FORESTED%' 
			 and not UPPER(s1.hab_subtype) like '%NON - FORESTED BOG%')
			or
			(UPPER(s1.Blank_Column) like '%FORESTED%' 
			 and not UPPER(s1.Blank_Column) like '%NON-FORESTED%' 
			 and not UPPER(s1.Blank_Column) like '%NON - FORESTED BOG%')
		   )
	        and
			UPPER(s1.HAB2_SUBTYPE) not like '%PARKLAND%'
			AND NOT
			(a.BGC_ZONE IN ('ESSF','MH') and substring(a.BGC_SUBZON,3) in ('p','u','w'))
	        AND
	        a.BGC_ZONE NOT IN ('AT', 'BAFA', 'CMA', 'IMA')
		then 'NCBF'
	when UPPER(s1.HAB_SUBTYPE) in ('UNKNOWN', 'UNDEFINED') and
		   a.BGC_ZONE NOT IN ('AT', 'BAFA', 'CMA', 'IMA') and
	       substring(a.BGC_SUBZON,3) not in ('p','u','w') and
			a.SITE_S1 != '00'
		then 'UNK'
	when  a.BGC_ZONE IN ('AT', 'BAFA', 'CMA', 'IMA') or
	       substring(a.BGC_SUBZON,3) in ('p','u','w') or a.SITE_S1 = '00'
		  then 'NP'
	when s1.bapid is Null 
		then 'NM'
	 else 'NM'
end as class_1,
case 
	when s2.si is not Null
		then 'IN SIBEC'
	when (UPPER(s2.HAB_SUBTYPE) in 
			('CONIFER FOREST - DRY', 
			 'CONIFER FOREST - MESIC (AVERAGE)', 
			 'CONIFER FOREST - MOIST/WET',
             'DECIDUOUS/BROADLEAF FOREST', 
			 'MIXED FOREST (DECIDUOUS/CONIFEROUS MIX)',
             'RIPARIAN FOREST', 
			 'SHORELINE FOREST', 
			 'TREED BOG', 
			 'TREED FEN', 
			 'TREED SWAMP')
			or
			UPPER(s2.Blank_Column) in 
			('CONIFER FOREST - DRY', 
			 'CONIFER FOREST - MESIC (AVERAGE)', 
			 'CONIFER FOREST - MOIST/WET',
             'DECIDUOUS/BROADLEAF FOREST', 
			 'MIXED FOREST (DECIDUOUS/CONIFEROUS MIX)',
             'RIPARIAN FOREST', 
			 'SHORELINE FOREST', 
			 'TREED BOG', 
			 'TREED FEN', 
			 'TREED SWAMP')
			or 
			(UPPER(s2.hab_subtype) like '%FORESTED%' 
			 and not UPPER(s2.hab_subtype) like '%NON-FORESTED%' 
			 and not UPPER(s2.hab_subtype) like '%NON - FORESTED BOG%')
			or
			(UPPER(s2.Blank_Column) like '%FORESTED%' 
			 and not UPPER(s2.Blank_Column) like '%NON-FORESTED%' 
			 and not UPPER(s2.Blank_Column) like '%NON - FORESTED BOG%')
		   )
	        and
			UPPER(s2.HAB2_SUBTYPE) not like '%PARKLAND%'
			AND NOT
			(a.BGC_ZONE IN ('ESSF','MH') and substring(a.BGC_SUBZON,3) in ('p','u','w'))
	        AND
	        a.BGC_ZONE NOT IN ('AT', 'BAFA', 'CMA', 'IMA')
		then 'NCBF'
	when UPPER(s2.HAB_SUBTYPE) in ('UNKNOWN', 'UNDEFINED') and
		   a.BGC_ZONE NOT IN ('AT', 'BAFA', 'CMA', 'IMA') and
	       substring(a.BGC_SUBZON,3) not in ('p','u','w') and
			a.SITE_S2 != '00'
		then 'UNK'
	when  a.BGC_ZONE IN ('AT', 'BAFA', 'CMA', 'IMA') or
	       substring(a.BGC_SUBZON,3) in ('p','u','w') or a.SITE_S2 = '00'
		  then 'NP'
	when s2.bapid is Null 
		then 'NM'
	 else 'NM'
end as class_2,
case 
	when s3.si is not Null
		then 'IN SIBEC'
	when (UPPER(s3.HAB_SUBTYPE) in 
			('CONIFER FOREST - DRY', 
			 'CONIFER FOREST - MESIC (AVERAGE)', 
			 'CONIFER FOREST - MOIST/WET',
             'DECIDUOUS/BROADLEAF FOREST', 
			 'MIXED FOREST (DECIDUOUS/CONIFEROUS MIX)',
             'RIPARIAN FOREST', 
			 'SHORELINE FOREST', 
			 'TREED BOG', 
			 'TREED FEN', 
			 'TREED SWAMP')
			or
			UPPER(s3.Blank_Column) in 
			('CONIFER FOREST - DRY', 
			 'CONIFER FOREST - MESIC (AVERAGE)', 
			 'CONIFER FOREST - MOIST/WET',
             'DECIDUOUS/BROADLEAF FOREST', 
			 'MIXED FOREST (DECIDUOUS/CONIFEROUS MIX)',
             'RIPARIAN FOREST', 
			 'SHORELINE FOREST', 
			 'TREED BOG', 
			 'TREED FEN', 
			 'TREED SWAMP')
			or 
			(UPPER(s3.hab_subtype) like '%FORESTED%' 
			 and not UPPER(s3.hab_subtype) like '%NON-FORESTED%' 
			 and not UPPER(s3.hab_subtype) like '%NON - FORESTED BOG%')
			or
			(UPPER(s3.Blank_Column) like '%FORESTED%' 
			 and not UPPER(s3.Blank_Column) like '%NON-FORESTED%' 
			 and not UPPER(s3.Blank_Column) like '%NON - FORESTED BOG%')
		   )
	        and
			UPPER(s3.HAB2_SUBTYPE) not like '%PARKLAND%'
			AND NOT
			(a.BGC_ZONE IN ('ESSF','MH') and substring(a.BGC_SUBZON,3) in ('p','u','w'))
	        AND
	        a.BGC_ZONE NOT IN ('AT', 'BAFA', 'CMA', 'IMA')
		then 'NCBF'
	when UPPER(s3.HAB_SUBTYPE) in ('UNKNOWN', 'UNDEFINED') and
		   a.BGC_ZONE NOT IN ('AT', 'BAFA', 'CMA', 'IMA') and
	       substring(a.BGC_SUBZON,3) not in ('p','u','w') and
			a.SITE_S3 != '00'
		then 'UNK'
	when  a.BGC_ZONE IN ('AT', 'BAFA', 'CMA', 'IMA') or
	       substring(a.BGC_SUBZON,3) in ('p','u','w') or a.SITE_S3 = '00'
		  then 'NP'
	when s3.bapid is Null 
		then 'NM'
	 else 'NM'
end as class_3
	 
from :longTableSkinny a 
left outer join   :xwalk_filtered s1 on (a.key1 = s1.xwalkkey  )
left outer join   :xwalk_filtered s2 on (a.key2 = s2.xwalkkey ) 
left outer join   :xwalk_filtered s3 on (a.key3 = s3.xwalkkey ))

select *,
case when (class_1 = 'IN SIBEC' or class_2 = 'IN SIBEC' or class_3 = 'IN SIBEC')  AND
(class_1 = 'IN SIBEC' or class_1 = 'NP' or class_1 = 'NM' ) and
(class_2 = 'IN SIBEC' or class_2 = 'NP' or class_2 = 'NM' ) and
(class_3 = 'IN SIBEC' or class_3 = 'NP' or class_3 = 'NM' )
then 1
else 0
end as USE
from t2;

--Drop skiny lng tables
drop table if exists :longTableSkinny;