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
drop table if exists :not_unique_sibec;
Create table :not_unique_sibec as
select lookup, count(*) as count_
from :sibeclookupunique x
group by lookup
having count(*)  > 1