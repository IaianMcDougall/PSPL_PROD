set search_path = :schema;

drop table if exists :sibeclookup;
create table :sibeclookup as
select bgcunit,
siteseries,
region,
source,
siteassociation,
treespp,
plotcountspp,
meanplotsiteindex,
standarderrorofmean,
bgcunit || '~' || siteseries || '~' || region || '~' || source as lookup,
bgcunit || '~' || siteseries || '~' || region || '~' || source || '~' || treespp  as lookup_species
from :latestSibec; 

drop table if exists :sibeclookupunique;
create table :sibeclookupunique as

SELECT
bgcunit,
siteseries,
region,
source,
lookup,
 ARRAY_AGG (
        treespp
        ORDER BY
            treespp
    ) species,
 ARRAY_AGG (
        meanplotsiteindex
        ORDER BY
            treespp
    ) si
	
FROM
    :sibeclookup
GROUP BY
    lookup,bgcunit,
siteseries,
region,
source
ORDER BY
    lookup;
	
--check if all sibec lookup is unique
drop table if exists pspl.not_unique_sibec;
Create table pspl.not_unique_sibec as
select lookup, count(*) as count_
from :sibeclookupunique x
group by lookup
having count(*)  > 1

--Create table of crosswalk rows where source does not match
drop table if exists pspl.xwalk_source_mismatch;
Create table pspl.xwalk_source_mismatch as
select 
distinct x.*, lk.source

from pspl.updxwalk x join
pspl.sibeclookupunique lk
on x.BGC_UNIT_X = lk.bgcunit and x.SITE_S_X = lk.siteseries and x.REGION_X = lk.region and x.source_x != lk.source

select * from pspl.xwalk_source_mismatch

--filter cross walk table by only keeping rows with SIBEC values
drop table if exists pspl.xwalk_filtered;
Create table pspl.xwalk_filtered as
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

from pspl.updxwalk x left outer join
pspl.sibeclookupunique lk
on x.BGC_UNIT_X = lk.bgcunit and x.SITE_S_X = lk.siteseries and x.REGION_X = lk.region and x.source_x = lk.source;

drop index if exists filtered_xwalk_ogc_inx;
create index filtered_xwalk_ogc_inx on pspl.xwalk_filtered(xwalkkey);

-----HARDCODE EXCEPTIONS INTO LONG TABLE
drop table if exists pspl.pem_long_tbl_upd;
Create table pspl.pem_long_tbl_upd as
select a.*,
case when (BAPID in (182, 185, 4039, 4052, 4053, 4296)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'dk'
			and BGC_VRT = 1
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S1 = '08'
			and SITEMC_S1 = 'SC'
			and SITE_M1A = 'a'
			and SITE_M1B = 'a')

			OR
			
			(BAPID in (4296)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'dk'
			and BGC_VRT = 2
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S1 = '06'
			and (SITEMC_S1 = '' or SITEMC_S1 is NULL)  
			and SITE_M1A = 'a'
			and SITE_M1B = 'a')
			
			OR
			
			(BAPID in (4296)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'mw'
			and BGC_VRT = 2
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S1 = '05'
			and SITEMC_S1 = 'SH'
			and SITE_M1A = 'a'
			and SITE_M1B = 'a')
			
			OR
			
			(BAPID in (1056)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'mc'
			and BGC_VRT is NULL
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S1 = '00'
			and SITEMC_S1 = 'SC'
			and SITE_M1A = 'a'
			and SITE_M1B = 'a')
			
     then 111
	 else SITE_S1
end as SITE_S1_UPD,
case when (BAPID in (182, 185, 4039, 4052, 4053, 4296)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'dk'
			and BGC_VRT = 1
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S2 = '08'
			and SITEMC_S2 = 'SC'
			and SITE_M2A = 'a'
			and SITE_M2B = 'a')

			OR
			
			(BAPID in (4296)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'dk'
			and BGC_VRT = 2
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S2 = '06'
			and (SITEMC_S2 = '' or SITEMC_S1 is NULL)  
			and SITE_M2A = 'a'
			and SITE_M2B = 'a')
			
			OR
			
			(BAPID in (4296)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'mw'
			and BGC_VRT = 2
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S2 = '05'
			and SITEMC_S2 = 'SH'
			and SITE_M2A = 'a'
			and SITE_M2B = 'a')
			
			OR
			
			(BAPID in (1056)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'mc'
			and BGC_VRT is NULL
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S2 = '00'
			and SITEMC_S2 = 'SC'
			and SITE_M2A = 'a'
			and SITE_M2B = 'a')
			
     then 111
	 else SITE_S2
end as SITE_S2_UPD,
case when (BAPID in (182, 185, 4039, 4052, 4053, 4296)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'dk'
			and BGC_VRT = 1
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S3 = '08'
			and SITEMC_S3 = 'SC'
			and SITE_M3A = 'a'
			and SITE_M3B = 'a')

			OR
			
			(BAPID in (4296)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'dk'
			and BGC_VRT = 2
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S3 = '06'
			and (SITEMC_S3 = '' or SITEMC_S1 is NULL)  
			and SITE_M3A = 'a'
			and SITE_M3B = 'a')
			
			OR
			
			(BAPID in (4296)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'mw'
			and BGC_VRT = 2
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S3 = '05'
			and SITEMC_S3 = 'SH'
			and SITE_M3A = 'a'
			and SITE_M3B = 'a')
			
			OR
			
			(BAPID in (1056)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'mc'
			and BGC_VRT is NULL
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S3 = '00'
			and SITEMC_S3 = 'SC'
			and SITE_M3A = 'a'
			and SITE_M3B = 'a')
			
     then 111
	 else SITE_S3
end as SITE_S3_UPD
from pspl.pem_long_tbl a;

drop table if exists pspl.pem_long_tbl_upd;

-----Add Keys to long TABLESPACE
drop table if exists pspl.pem_long_tbl_skinny;
Create table pspl.pem_long_tbl_skinny as
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
a.BAPID || '~' ||COALESCE(replace(BGC_ZONE,' ',''),'')  || COALESCE(replace(BGC_SUBZON,' ',''),'') || COALESCE(BGC_VRT::text,'') || COALESCE(replace(BGC_PHASE,' ',''),'')  || '~' ||  COALESCE(replace(SITE_S1,' ',''),'')|| '~' || COALESCE(replace(SITEMC_S1,' ',''),'')|| '~' || COALESCE(replace(SERAL_1,' ',''),'') as key1,
a.BAPID || '~' ||COALESCE(replace(BGC_ZONE,' ',''),'')  || COALESCE(replace(BGC_SUBZON,' ',''),'') || COALESCE(BGC_VRT::text,'') || COALESCE(replace(BGC_PHASE,' ',''),'')  || '~' ||   COALESCE(replace(SITE_S2,' ',''),'')|| '~' || COALESCE(replace(SITEMC_S2,' ',''),'')|| '~' || COALESCE(replace(SERAL_2,' ',''),'') as key2,
a.BAPID || '~' ||COALESCE(replace(BGC_ZONE,' ',''),'')  || COALESCE(replace(BGC_SUBZON,' ',''),'') || COALESCE(BGC_VRT::text,'') || COALESCE(replace(BGC_PHASE,' ',''),'')  || '~' ||   COALESCE(replace(SITE_S3,' ',''),'')|| '~' || COALESCE(replace(SITEMC_S3,' ',''),'')|| '~' || COALESCE(replace(SERAL_3,' ',''),'') as key3,
SDEC_1,
SDEC_2,
SDEC_3,
shape_area
from pspl.pem_long_tbl a
;
drop index if exists key1_ogc_inx;
create index key1_ogc_inx on pspl.pem_long_tbl_skinny(key1);
drop index if exists key2_ogc_inx;
create index key2_ogc_inx on pspl.pem_long_tbl_skinny(key2);
drop index if exists key3_ogc_inx;
create index key3_ogc_inx on pspl.pem_long_tbl_skinny(key3);

---Filter Long Tables
---Filter Long Tables
drop table if exists pspl.pem_long_tbl_skinny_filter;
Create table pspl.pem_long_tbl_skinny_filter as
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
	 
from pspl.pem_long_tbl_skinny a 
left outer join   pspl.xwalk_filtered s1 on (a.key1 = s1.xwalkkey  )
left outer join   pspl.xwalk_filtered s2 on (a.key2 = s2.xwalkkey ) 
left outer join   pspl.xwalk_filtered s3 on (a.key3 = s3.xwalkkey ))

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
drop table if exists pspl.pem_long_tbl_skinny;






    forested_habitat_types = ["CONIFER FOREST - DRY", "CONIFER FOREST - MESIC (AVERAGE)", "CONIFER FOREST - MOIST/WET",
                              "DECIDUOUS/BROADLEAF FOREST", "MIXED FOREST (DECIDUOUS/CONIFEROUS MIX)",
                              "RIPARIAN FOREST", "SHORELINE FOREST", "TREED BOG", "TREED FEN", "TREED SWAMP"]

    cursor_fields = [
	"TEIS_ID", 0
	"BAPID", 1
	"BGC_ZONE", 2
	"BGC_SUBZON", 3
	"BGC_VRT", 4
	"BGC_PHASE", 5
	"SDEC_1", 6
	"SITE_S1",7
    "SITEMC_S1", 8
	"SDEC_2", 9
	"SITE_S2", 10
	"SITEMC_S2", 11
	"SDEC_3", 12
	"SITE_S3", 13
	"SITEMC_S3",14 
	"BGC_LBL",15
     "SIBEC_BGC1",16 
	 "SIBEC_SS1", 17
	 "SIBEC_BGC2",18
	 "SIBEC_SS2", 19
	 "SIBEC_BGC3", 20
	 "SIBEC_SS3", 21
	 "USE", 22
	 "SERAL_1",23
     "SERAL_2", 24
	 "SERAL_3", 25
	 "SIBEC_REG1", 26
	 "SIBEC_REG2", 27
	 "SIBEC_REG3",28
	 "SIBEC_SRC1", 29
	 "SIBEC_SRC2",30
     "SIBEC_SRC3"]31

      key = data["BAPID"] + "~" + data["BGC_UNIT"] + "~" + data["SITE_S"] + "~" + data["SITEMC_S"] + "~" \
              + data["Seral"]

        xwalk_dict[key] = 
		[data["IN_SIBEC_" + time.strftime("%Y")],0
		data["HAB_SUBTYPE"],1
		data["BGC_UNIT_X"],2
         data["SITE_S_X"], 3
		 data["Blank_Column"],4
		 data["HAB2_SUBTYPE"],5
		 data["REGION_X"],6
         data["SOURCE_X"]]7
        if data_counter % 1000 == 0:
		
		
    sibec_lookup = xwalk_dict[key1][2] + "~" + xwalk_dict[key1][3] + "~" + xwalk_dict[key1][6] + "~" + \
                    xwalk_dict[key1][7]
					