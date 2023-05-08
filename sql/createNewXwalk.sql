set search_path = :schema;

--Typo from 2021 x walk
update :xwalkprev 
set seral = '' where seral = 'Treed swamp' and bapid = 6543;

drop table if exists :missXwalk;
create table :missXwalk as
with t1 as (Select * from :pemgrp
union all
select * from :teisgrp)
select b.*
from 
t1 b 
left outer join  :xwalkprev c
on b.bapid = c.bapid and  b.bgc_unit = c.bgc_unit and b.site_s = c.site_s and b.sitemc_s = c.sitemc_s and b.seral = c.seral
where c.bgc_unit is Null;


drop table if exists :missLngTbls;
create table :missLngTbls as
with t1 as (Select * from :pemgrp
union all
select * from :teisgrp)
select c.*
from 
t1 b
right outer join  :xwalkprev c
on b.bapid = c.bapid and  b.bgc_unit = c.bgc_unit and b.site_s = c.site_s and b.sitemc_s = c.sitemc_s and b.seral = c.seral
where b.bapid is Null and c.area_ha > 0; 


--create table update table
drop table if exists :updxwalk;
create table :updxwalk as
with t1 as (Select * from :pemgrp
union all
select * from :teisgrp),

t2 as (
select t1.*, (select max(year) as max_year from :xwalkprev)
from t1)

select 
a.bapid,
a.proj_name,
a.region as sibec_region,
b.bgc_unit ,
c.new_bgc_unit,
b.site_s,
c.new_site_s,
b.sitemc_s,
c.new_sitemc_s,
b.seral,
b.freq_1,
b.freq_2,
b.freq_3,
b.area_ha,
case when c.year is Null
 then b.max_year + 1
 else c.year end as year,
:sibecFields
c.hab_subtype,
c.hab2_subtype,
c.blank_column,
c.comments,
c.bgc_unit_x,
c.site_s_x,
c.region_x,
c.source_x,
c.coast_comments,
c.jk_comment,
c.vwxy_found_in_sibec_,
case when g.bapid is not Null
then 'Y' 
else 'N' end as needs_crosswalking_

from 
:bapids a
join t2 b on a.bapid = b.bapid 
left outer join  :xwalkprev c
on b.bapid = c.bapid and  b.bgc_unit = c.bgc_unit and b.site_s = c.site_s and b.sitemc_s = c.sitemc_s and b.seral = c.seral
:sibecjoin
left outer join :missXwalk g
on b.bapid = g.bapid and  b.bgc_unit = g.bgc_unit and b.site_s = g.site_s and b.sitemc_s = g.sitemc_s and b.seral = g.seral

 order by needs_crosswalking_ desc,a.bapid,b.site_s;
 
 
 --create table of rows from last years crosswalk table thats are not in the long tables
drop table if exists :missrowsprev;
create table :missrowsprev as
with t1 as (Select * from :pemgrp
union all
select * from :teisgrp)

select 
c.*
from 
:bapids a
join t1 b on a.bapid = b.bapid 
right outer join  :xwalkprev c
on b.bapid = c.bapid and  b.bgc_unit = c.bgc_unit and b.site_s = c.site_s and b.sitemc_s = c.sitemc_s and b.seral = c.seral
where a.bapid is Null
order by c.bapid,c.site_s;
 