drop table if exists :bptbl;
create table :bptbl as

with t1 as (
select 
id1 as ogc_fid,
split_part(id2,'|', 1)::integer as slope,
split_part(id2,'|', 2)::integer as aspect,
split_part(id2,'|', 3) as zone,
elevation as elev,
map as mmap,
round(mwmt, 1) as mwmt,
round(mcmt,1) as mcmt,
round(td,1) as td,
round(ahm,1) as ahm,
round(shm,1) as shm,
round(emt,1) as emt,
msp,
ddlt0,
ddgt5,
ddgt18,
nffd,
pas,
eref,
cmd
from :wnaTable
where split_part(id2,'|', 3) not in ( 'BAFA', 'CMA','BG','IMA','MH','BAFA','SWB')

)



select
ogc_fid,
zone,
slope,
aspect,
elev,
mmap,
mwmt,
mcmt,
td,
ahm,
shm,
emt,
msp,
ddlt0,
ddgt5,
ddgt18,
nffd,
pas,
eref,
cmd,
case 	when zone = 'BWBS' 
			then case when (ahm < 14.0 or ahm > 25.1 or nffd < 107 or nffd > 157 or eref < 363 or eref > 537 or slope < 0 or slope > 47) 
						then -999
					else round(-0.7707 - 0.3195 * ahm + 0.09471 * nffd + 0.02333 * eref - 0.05748 * slope + 1.1514 * aspect, 1)
			end
		when zone = 'ICH' 
			then case when (ahm < 11.4 or ahm > 31.8 or nffd < 131 or nffd > 182 or eref < 492 or eref > 737 or slope < 0 or slope > 68)
						then -999
					else round(-0.7707 - 0.3195 * ahm + 0.09471 * nffd + 0.02333 * eref - 0.05748 * slope + 1.1514 * aspect, 1)
			end
		when zone = 'IDF' 
			then case when (ahm < 19.4 or ahm > 35.9 or nffd < 116 or nffd > 175 or eref < 524 or eref > 649 or slope < 0 or slope > 70)
						then -999
					else round(-0.7707 - 0.3195 * ahm + 0.09471 * nffd + 0.02333 * eref - 0.05748 * slope + 1.1514 * aspect, 1)
			end
		when zone = 'MS'
			then case when (ahm < 16.5 or ahm > 21.1 or nffd < 158 or nffd > 161 or eref < 623 or eref > 653 or slope < 0 or slope > 89)
						then -999
					else round(-0.7707 - 0.3195 * ahm + 0.09471 * nffd + 0.02333 * eref - 0.05748 * slope + 1.1514 * aspect, 1)
			end
		 when zone = 'SBS' 
		 	then case when (ahm < 9.5 or ahm > 27.5 or nffd < 93  or nffd > 180 or eref < 451 or eref > 612 or slope < 0 or slope > 79)
					then -999
				else round(-0.7707 - 0.3195 * ahm + 0.09471 * nffd + 0.02333 * eref - 0.05748 * slope + 1.1514 * aspect, 1)
			end
end as at_si_bp,
	
case 	 when zone = 'BWBS'
				then case when (ahm < 16.0 or ahm > 24.5 or ddgt5 < 783 or ddgt5 > 1117 or ddgt18 < 0 or ddgt18 > 10 or
					  eref < 389 or eref > 488 or cmd < 63 or cmd > 241 or elev < 630 or elev > 1070 or slope < 0 or slope > 47) 
						then -999
					 else round(10.0465 - 0.08794 * ahm + 0.006876 * ddgt5 - 0.03321 * ddgt18 + 0.01298 * eref - 0.00767 * cmd - 0.00176 *
								elev - 0.01470 * slope + 0.2629 * aspect, 1)
				end
		when zone = 'ESSF' 
				 then case when (ahm < 4.0 or ahm > 25.8  or ddgt5 < 441 or ddgt5 > 1212 or ddgt18 < 0 or ddgt18 > 10 or
												eref < 330 or eref > 580 or cmd < 0 or cmd > 287 or elev < 766 or 
												elev > 2059 or slope < 0 or slope > 79) 
								then -999
						else round(10.2552 - 0.08794 * ahm + 0.006876 * ddgt5 - 0.03321 * ddgt18 + 0.01298 * eref - 0.00767 * cmd - 0.00176 * 
									elev - 0.01470 * slope + 0.2629 * aspect, 1)
				 end
	 	when zone = 'ICH' 
				then case when (ahm < 4.0 or ahm > 29.1 or ddgt5 < 668 or ddgt5 > 1727 or ddgt18 < 0 or ddgt18 > 96 or 
										eref < 439 or eref > 708 or cmd < 0 or cmd > 391 or elev < 52 or 
										elev > 1600 or slope < 0 or slope > 74) 
							then -999
					else round(11.7969 - 0.08794 * ahm + 0.006876 * ddgt5 - 0.03321 * ddgt18 + 0.01298 * eref - 0.00767 * cmd - 0.00176  * 
								elev - 0.01470 * slope + 0.2629 * aspect, 1)
				end
	 	when zone = 'IDF' 
				then case when (ahm < 13.8 or ahm > 42.2 or ddgt5 < 763 or ddgt5 > 1933 or ddgt18 < 0 or 
										ddgt18 > 129 or eref < 504 or eref > 766 or cmd < 170 or 
										cmd > 439 or elev < 201 or elev > 1614 or slope < 0 or slope > 95) 
						then -999
					else round(10.709 - 0.08794 * ahm + 0.006876 * ddgt5 - 0.03321 * ddgt18 + 0.01298 * eref - 0.00767 *  cmd - 0.00176   * 
								elev - 0.01470 * slope + 0.2629 * aspect, 1)
				end
	 	when zone = 'MS' 
				then case when (ahm < 6.7 or ahm > 34.0 or ddgt5 < 453 or   ddgt5 > 1397 or ddgt18 < 0 or ddgt18 > 18 or
										eref < 416 or eref > 643 or cmd < 11 or cmd > 383 or elev < 968 or
										elev > 1791 or slope < 0 or slope > 75) 
						then -999
					 else round(11.1451 - 0.08794 * ahm + 0.006876 * ddgt5 - 0.03321 * ddgt18 + 0.01298 * eref - 0.00767 * cmd - 0.00176 *
							elev - 0.01470 * slope + 0.2629 * aspect, 1)
				end
	 	when zone = 'SBPS' 
				then case when (ahm < 18.8 or ahm > 37.8 or ddgt5 < 611 or ddgt5 > 1316 or ddgt18 < 0 or ddgt18 > 10 or 
												eref < 504 or eref > 587 or cmd < 117 or cmd > 400 or elev < 736 or 
												elev > 1506 or slope < 0 or slope > 76) 
						then -999
					 else round(10.1015 - 0.08794 * ahm + 0.006876 * ddgt5 - 0.03321 * ddgt18 + 0.01298 * eref - 0.00767 * cmd - 0.00176 * 
							elev - 0.01470 * slope + 0.2629 * aspect, 1)
				end
	 	when zone = 'SBS' 
				then case when (ahm < 9.4 or ahm > 32.2 or ddgt5 < 648 or ddgt5 > 1352 or ddgt18 < 0 or ddgt18 > 12 or 
										eref < 363 or eref > 629 or cmd < 0 or cmd > 364 or elev < 383 or 
										elev > 1417 or slope < 0 or slope > 74) 
						then -999
					else round(11.2656 - 0.08794 * ahm + 0.006876 * ddgt5 - 0.03321 * ddgt18 + 0.01298 * eref - 0.00767 * cmd - 0.00176 *
							elev - 0.01470 * slope + 0.2629 * aspect, 1)
				end
end as pl_si_bp,
	
case 	when zone = 'BWBS' 
				then case when (elev < 298 or elev > 1233) 
						then -999
					else round(13.2663 - 0.00410 * elev, 1)
				end
     	when zone = 'SBS' 
				then case when (elev < 716 or elev > 1035) 
						then -999
					else round(14.7391 - 0.00410 * elev, 1)
				end
end as sb_si_bp,	

case    when zone = 'BWBS'
				then case when (msp < 242 or msp > 388 or slope < 0 or slope > 47 or ddgt5 < 778 or ddgt5 > 1307) 
						then -999
					else round(42.3204 - 0.04084 * msp - 0.09897 * slope - 0.00849 * ddgt5, 1)
				end
end as sw_si_bp,	

case    when zone = 'CDF'
				then case when (msp < 163 or msp > 297 or slope < 0 or slope > 57 or elev < 0 or elev > 314) 
						then -999
					else round(33.5417 + 0.005880 * msp - 0.02097 * slope - 0.00775 * elev, 1)
				end
	  	when zone = 'CWH'
				then case when (msp < 126 or msp > 915 or slope < 0 or slope > 147 or elev < 0 or elev > 1277) 
						then -999
					else round(33.5417 + 0.005880 * msp - 0.02097 * slope - 0.00775 * elev, 1)
				end
	 	when zone = 'ESSF'
				then case when (ahm < 8.9 or ahm > 22.0 or emt < -45.2 or emt > -37.3 or slope < 0 or slope > 65 or 
                              elev < 956 or elev > 1929) 
						then -999
					else round(40.9130 - 0.2277 * ahm + 0.2832 * emt - 0.02563 * slope + 0.4755 * aspect - 0.00489 * elev,1)
				end
	 	when zone = 'ICH'
				then case when (ahm < 6.6 or ahm > 36.8 or emt < -43.8 or emt > -32.1 or slope < 0 or slope > 99 or 
                              elev < 418 or elev > 1583) 
						then -999
					else round(44.1200 - 0.2277 * ahm + 0.2832 * emt - 0.02563 * slope + 0.4755 * aspect - 0.00489 * elev, 1)
				end
	 	when zone = 'IDF'
				then case when (ahm < 8.0 or ahm > 47.0 or emt < -47.7 or emt > -31.2 or slope < 0 or slope > 95 or 
                              elev < 261 or elev > 1563) 
						then -999
					else round(41.0985 - 0.2277 * ahm + 0.2832 * emt - 0.02563 * slope + 0.4755 * aspect - 0.00489 * elev, 1)
				end
	 	when zone = 'MS'
				then case when (ahm < 9.8 or ahm > 31.1 or emt < -44.1 or emt > -35.5 or slope < 0 or slope > 79 or 
                              elev < 1036 or elev > 1666) 
						then -999
					else round(41.8979 - 0.2277 * ahm + 0.2832 * emt - 0.02563 * slope + 0.4755 * aspect - 0.00489 * elev, 1)
				end
	 	when zone = 'SBS'
				then case when (ahm < 8.5 or ahm > 33.1 or emt < -43.7 or emt > -38.5 or slope < 0 or slope > 87 or 
                               elev < 598 or elev > 1407) 
						then -999
					else round(41.5649 - 0.2277 * ahm + 0.2832 * emt - 0.02563 * slope + 0.4755 * aspect - 0.00489 * elev, 1)
				end
end as fd_si_bp,
case    when zone = 'CWH'
				then case when(ahm < 2.0 or ahm > 14.7 or mwmt < 11.1 or mwmt > 17.9 or elev < 0 or elev > 1302) 
							then -999
					else round(23.0004 - 0.3121 * ahm + 0.5885 * mwmt + 0.5723 * aspect - 0.00847 * elev, 1)
				end
end as ba_si_bp,				
case     when zone = 'CWH' 
				then case when (mwmt < 12.9 or mwmt > 18.2 or mmap < 883 or mmap > 5701 or ddgt5 < 952 or 
                                    ddgt5 > 1955 or ddgt18 < 0 or ddgt18 > 123 or eref < 397 or 
                                    eref > 696 or slope < 0 or slope > 137 or elev < 0 or elev > 992) 
							then -999
					else round(-0.8308 + 2.9435 * mwmt + 0.001395 * mmap - 0.02598 * ddgt5 + 0.1518 *
                        ddgt18 - 0.000775 * ddgt18 * ddgt18 + 0.01885 * eref + 0.02498 * slope - 0.00599 * elev, 1)
				end
		when zone = 'ICH'
				then case when (td < 19.5 or td > 26.4 or mmap < 314 or mmap > 1450) 
							then -999
					else round(33.3545 - 0.8152 * td + 0.003354 * mmap, 1)
				end
		when zone = 'IDF'
				then case when (td < 22.5 or td > 24.3 or mmap < 496 or mmap > 691) 
						then -999
					else round(33.3545 - 0.8152 * td + 0.003354 * mmap, 1)
				end
end as cw_si_bp,	
case    when zone = 'CWH'
				then case when (mcmt < -8.2 or mcmt > 5.3 or td < 9.1 or td > 22.6 or ahm < 2.3 or ahm > 17.6 or
                                    slope < 0 or slope > 189 or elev < 0 or elev > 1280) 
						then -999
		    		else round(8.1749 + 1.4812 * mcmt + 1.3640 * td - 0.3497 * ahm + 0.01871 * slope - 0.00326 * elev, 1)
				end
		when zone = 'ICH'
				then case when (shm < 13.3 or shm > 79.0 or eref < 434 or eref > 676 or elev < 115 or elev > 1760) 
						then -999
		    		else round(20.8763 - 0.1300 * shm + 0.01464 * eref - 0.00499 * elev, 1)
				end
end as hw_si_bp,	
case 	when zone = 'CWH'
				then case when (mmap < 621 or mmap > 5783 or elev < 0 or elev > 878) 
						then -999
		    		else round(24.4576 + 0.001906 * mmap - 0.00931 * elev, 1)
				end
end as ss_si_bp,	

case 	when zone = 'ESSF'
				then case when (shm < 17.0 or shm > 63.4 or ddgt18 < 0 or ddgt18 > 10 or eref < 329 or eref > 594 or 
                                            elev < 767 or elev > 2043) 
						then -999
		    		else round(8.8158 - 0.09060 * shm - 0.1237 * ddgt18 + 0.03183 * eref - 0.00322 * elev, 1)
				end
	 	when zone = 'ICH'
				then case when (shm < 13.6 or shm > 72.6 or ddgt18 < 0 or ddgt18 > 67 or eref < 431 or eref > 689 or 
                                    elev < 140 or elev > 1573) 
						then -999
		    		else round(9.6597 - 0.09060 * shm - 0.1237 * ddgt18 + 0.03183 * eref - 0.00322 * elev, 1)
				end
	 	when zone = 'MS' 
				then case when (shm < 27.8 or shm > 81.2 or ddgt18 < 0 or ddgt18 > 23 or eref < 422 or eref > 647 or 
                                    elev < 975 or elev > 1746) 
						then -999
		    		else round(10.3213 - 0.09060 * shm - 0.1237 * ddgt18 + 0.03183 * eref - 0.00322 * elev, 1)
				end
		 when zone = 'SBS'
		 		then case when (shm < 29.8 or shm > 71.6 or ddgt18 < 0 or ddgt18 > 10 or eref < 420 or eref > 598 or 
                                    elev < 611 or elev > 1352) 
						then -999
		    		else round(9.2568 - 0.09060 * shm - 0.1237 * ddgt18 + 0.03183 * eref - 0.00322 * elev, 1)
				end
end as bl_si_bp,	

case 	when zone = 'ESSF'
				then case when (eref < 324 or eref > 626 or msp < 188 or msp > 653 or ahm < 4.0 or ahm > 25.8 or 
                                    mwmt < 9.8 or mwmt > 16.5 or elev < 741 or elev > 2044) 
						then -999
		    		else round(-4.5938 + 0.06185 * eref + 0.02575 * msp + 0.3155 * ahm - 1.3636 *
                                    mwmt - 0.00322 * elev, 1)
				end
end as se_si_bp,		

case 	when zone = 'ICH'
				then case when (slope < 0 or slope > 81 or nffd < 135 or nffd > 205) 
						then -999
		    		else round(9.7865 - 0.06743 * slope + 0.06342 * nffd, 1)
				end
		when zone = 'IDF'
				then case when (slope < 0 or slope > 73 or nffd < 153 or nffd > 191) 
						then -999
		   			else round(9.7865 - 0.06743 * slope + 0.06342 * nffd, 1)
				end
		when zone = 'SBS' 
				then case when (slope < 0 or slope > 82 or nffd < 136 or nffd > 174) 
						then -999
		    		else round(9.7865 - 0.06743 * slope + 0.06342 * nffd, 1)
				end
end as ep_si_bp,	

case 	when zone = 'ICH'
				then case when (ahm < 12.0 or ahm > 28.8 or ddlt0 < 549 or ddlt0 > 1049) 
						then -999
		    		else round(35.347 - 0.2298 * ahm - 0.00872 * ddlt0, 1)
				end
	 	 when zone = 'IDF'
	 			then case when (ahm < 17.4 or ahm > 37.7 or ddlt0 < 506 or ddlt0 > 1007) 
						then -999
		    		else round(34.1027 - 0.2298 * ahm - 0.00872 * ddlt0, 1)
				end
	 	when zone = 'MS'
	 			then case when (ahm < 8.5 or ahm > 33.6 or ddlt0 < 675 or ddlt0 > 1277) 
						then -999
		    		else round(33.1514 - 0.2298 * ahm - 0.00872 * ddlt0, 1)
				end
end as lw_si_bp,

case 	when zone = 'ICH'
				then case when (msp < 162 or msp > 606 or ddgt5 < 598 or ddgt5 > 1610 or elev < 70 or elev > 1609) 
						then -999
		    		else round(12.5755 + 0.01299 * msp + 0.006287 * ddgt5 - 0.00172 * elev, 1)
				end
		when zone = 'IDF' 
				then case when (msp < 148 or msp > 348 or ddgt5 < 581 or ddgt5 > 1676 or elev < 691 or elev > 1488) 
						then -999
		    		else round(10.0995 + 0.01299 * msp + 0.006287 * ddgt5 - 0.00172 * elev, 1)
				end
		when zone = 'MS' 
				then case when (msp < 158 or msp > 601 or ddgt5 < 468 or ddgt5 > 1419 or elev < 1012 or elev > 1778) 
						then -99
		    		else round(11.5865 + 0.01299 * msp + 0.006287 * ddgt5 - 0.00172 * elev, 1)
				end
		when zone = 'SBPS'
				then case when (msp < 81 or msp > 620 or ddgt5 < 573 or ddgt5 > 1115 or elev < 795 or elev > 1382) 
						then -999
		    		else round(9.8511 + 0.01299 * msp + 0.006287 * ddgt5 - 0.00172 * elev, 1)
				end
		when zone = 'SBS'
				then case when(msp < 159 or msp > 724 or ddgt5 < 640 or ddgt5 > 1513 or elev < 417 or elev > 1489) 
						then -999
		    		else round(10.7449 + 0.01299 * msp + 0.006287 * ddgt5 - 0.00172 * elev, 1)
				end
end as sx_si_bp,	

case 	when zone = 'IDF'
				then case when (emt < -40.4 or emt > -30.7 or pas < 52 or pas > 320 or slope < 0 or slope > 83) 
						then -999
		    		else round(35.5385 + 0.6367 * emt + 0.02842 * pas - 0.07508 * slope, 1)
				end
		when zone = 'PP' 
				then case when (emt < -37.9 or emt > -33.1 or pas < 72 or pas > 209 or slope < 0 or slope > 63) 
						then -999
		    		else round(35.5385 + 0.6367 * emt + 0.02842 * pas - 0.07508 * slope, 1)
				end
end as py_si_bp
	
from t1;
		
drop if exists :wnaTable;