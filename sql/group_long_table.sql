set search_path = :schema;

drop table if exists :grpTbl;
create table :grpTbl as

with 

prevXwalkIDs as (select distinct bapid
from :xwalkprev),


t1 as ( select
a.BAPID,
COALESCE(replace(BGC_ZONE,' ',''),'')  || COALESCE(replace(BGC_SUBZON,' ',''),'') || COALESCE(BGC_VRT::text,'') || COALESCE(replace(BGC_PHASE,' ',''),'')  as BGC_UNIT,
COALESCE(replace(SITE_S1,' ',''),'')  as SITE_S1,
COALESCE(replace(SITEMC_S1,' ',''),'')  as SITEMC_S1,
COALESCE(replace(SERAL_1,' ',''),'')  as SERAL_1,
COALESCE(replace(SITE_S2,' ',''),'')  as SITE_S2,
COALESCE(replace(SITEMC_S2,' ',''),'')  as SITEMC_S2,
COALESCE(replace(SERAL_2,' ',''),'')  as SERAL_2,
COALESCE(replace(SITE_S3,' ',''),'')  as SITE_S3,
COALESCE(replace(SITEMC_S3,' ',''),'')  as SITEMC_S3,
COALESCE(replace(SERAL_3,' ',''),'')  as SERAL_3,
SDEC_1,
SDEC_2,
SDEC_3,
shape_area
from :lngTbl a
left outer join :bapids b on a.bapid = b.bapid
left outer join prevXwalkIDs c on a.bapid = c.bapid
where (b.bapid > 0 and (b.approved is Null or b.approved in('N','Y') ) ) or c.bapid > 0 ),

t2 as ((select 
	BAPID,
BGC_UNIT,
	SITE_S1 as site, 
	SITEMC_S1 as sitemc ,
	SERAL_1 as seral,
	sum((SDEC_1 * (shape_area/10000))/10 ) as area,
	count(*) as freq1,
	0 as freq2,
	0 as freq3
from t1
where SDEC_1 between 1 and 10  and BGC_UNIT <> '' and (SITE_S1 <> '' or SITEMC_S1 <> '')
group by 
	BAPID,
BGC_UNIT,
	SITE_S1, 
	SITEMC_S1,
	SERAL_1)
union all
	(select 
	BAPID,
BGC_UNIT,
	SITE_S2 as site, 
	SITEMC_S2  as sitemc,
	SERAL_2 as seral,
	sum((SDEC_2 * (shape_area/10000))/10 ) as area,
		0 as freq1,
	count(*) as freq2,
	0 as freq3
from t1
where SDEC_2 between 1 and 10  and BGC_UNIT <> '' and (SITE_S2 <> '' or SITEMC_S2 <> '')
group by 
	BAPID,
BGC_UNIT,
	SITE_S2, 
	SITEMC_S2,
	SERAL_2) 
union all
	(select 
	BAPID,
BGC_UNIT,
	SITE_S3  as site, 
	SITEMC_S3 as sitemc,
	SERAL_3 as seral,
	sum((SDEC_3 * (shape_area/10000))/10 ) as area,
		0 as freq1,
			0 as freq2,
	count(*) as freq3


from t1
where SDEC_3 between 1 and 10  and BGC_UNIT <> '' and (SITE_S3 <> '' or SITEMC_S3 <> '')
group by 
	BAPID,
BGC_UNIT,
	SITE_S3, 
	SITEMC_S3,
	SERAL_3))
	
select 
	BAPID,
BGC_UNIT,
	site as site_s, 
	sitemc as sitemc_s,
	seral,
    round(sum(area)::numeric,1) as area_ha,
	sum(freq1) as freq_1,
	sum(freq2) as freq_2,
	sum(freq3) as freq_3
from t2
group by
	BAPID,
BGC_UNIT,
	site, 
	sitemc,
	seral;
