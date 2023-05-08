set search_path = :schema;
-----HARDCODE EXCEPTIONS INTO LONG TABLE
drop table if exists :longTableUpd;
Create table :longTableUpd as
select a.*,
case when (BAPID in (182, 185, 4039, 4052, 4053, 4296)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'dk'
			and BGC_VRT = 1
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S1 = '08'
			and SITEMC_S1 = 'SC'
			and (SITE_M1A = 'a'
			or SITE_M1B = 'a'))

			OR
			
			(BAPID in (4296)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'dk'
			and BGC_VRT = 2
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S1 = '06'
			and (SITEMC_S1 = '' or SITEMC_S1 is NULL)  
			and (SITE_M1A = 'a'
			or SITE_M1B = 'a'))
			
			OR
			
			(BAPID in (4296)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'mw'
			and BGC_VRT = 2
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S1 = '05'
			and SITEMC_S1 = 'SH'
			and (SITE_M1A = 'a'
			or SITE_M1B = 'a'))
			
			OR
			
			(BAPID in (1056)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'mc'
			and BGC_VRT is NULL
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S1 = '00'
			and SITEMC_S1 = 'SC'
			and (SITE_M1A = 'a'
			or SITE_M1B = 'a'))
			
     then '111'
	 else SITE_S1
end as SITE_S1_UPD,
case when (BAPID in (182, 185, 4039, 4052, 4053, 4296)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'dk'
			and BGC_VRT = 1
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S2 = '08'
			and SITEMC_S2 = 'SC'
			and (SITE_M2A = 'a'
			or SITE_M2B = 'a'))

			OR
			
			(BAPID in (4296)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'dk'
			and BGC_VRT = 2
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S2 = '06'
			and (SITEMC_S2 = '' or SITEMC_S1 is NULL)  
			and (SITE_M2A = 'a'
			or SITE_M2B = 'a'))
			
			OR
			
			(BAPID in (4296)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'mw'
			and BGC_VRT = 2
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S2 = '05'
			and SITEMC_S2 = 'SH'
			and (SITE_M2A = 'a'
			or SITE_M2B = 'a'))
			
			OR
			
			(BAPID in (1056)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'mc'
			and BGC_VRT is NULL
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S2 = '00'
			and SITEMC_S2 = 'SC'
			and (SITE_M2A = 'a'
			or SITE_M2B = 'a'))
			
     then '111'
	 else SITE_S2
end as SITE_S2_UPD,
case when (BAPID in (182, 185, 4039, 4052, 4053, 4296)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'dk'
			and BGC_VRT = 1
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S3 = '08'
			and SITEMC_S3 = 'SC'
			and (SITE_M3A = 'a'
			or SITE_M3B = 'a'))

			OR
			
			(BAPID in (4296)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'dk'
			and BGC_VRT = 2
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S3 = '06'
			and (SITEMC_S3 = '' or SITEMC_S1 is NULL)  
			and (SITE_M3A = 'a'
			or SITE_M3B = 'a'))
			
			OR
			
			(BAPID in (4296)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'mw'
			and BGC_VRT = 2
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S3 = '05'
			and SITEMC_S3 = 'SH'
			and (SITE_M3A = 'a'
			or SITE_M3B = 'a'))
			
			OR
			
			(BAPID in (1056)
			and BGC_ZONE = 'BWBS'
			and BGC_SUBZON = 'mc'
			and BGC_VRT is NULL
			and (BGC_PHASE = '' or BGC_PHASE is NULL) 
			and  SITE_S3 = '00'
			and SITEMC_S3 = 'SC'
			and (SITE_M3A = 'a'
			or SITE_M3B = 'a'))
			
     then '111'
	 else SITE_S3
end as SITE_S3_UPD
from :longTable a;

--drop table if exists :longTable;