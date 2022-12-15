COPY (SELECT a.:id as ID1,
round((:slp)::numeric,0)
|| '|' ||
(case when :slp = 0
		then 360
	 when :slp > 0 and :asp = 360
		then 0
	else round((:asp)::numeric,0)
		end) 
|| '|' ||
:zone as ID2,
:lat as lat,
:long as long,
:ele as el
FROM :resTable a 
left outer join :latlongtbl b on a.ogc_fid = b.ogc_fid 
left outer join whse.bec_biogeoclimatic_poly c on a.objectid_bec = c.objectid  
where b.row_id >= :low and b.row_id < :high
and :becLbl is not Null and :zone is not Null and :ele >= 0 and :slp >= 0 and :asp >= 0) TO :filename (format CSV, HEADER)