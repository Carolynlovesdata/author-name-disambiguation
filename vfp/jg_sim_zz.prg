&&依据机构中作者的重合程度计算两个机构的相似度，结果写入表jg_sim中
CLOSE ALL
USE jg_sim IN a
USE all_zzjg_1 IN b
SELECT a
SCAN
	jg1_str=ALLTRIM(jg_sim.jg1)
	jg2_Str=ALLTRIM(jg_sim.jg2)
	SELECT b
	&&从all_zzjg_1中取出和jg1与jg2机构相同的作者，每个作者只取一个
	SELECT distinct all_zzjg_1.zzmc FROM all_zzjg_1 WHERE ALLTRIM(all_zzjg_1.jgmc)==jg1_str INTO CURSOR jg_1_zz
	SELECT distinct all_zzjg_1.zzmc FROM all_zzjg_1 WHERE ALLTRIM(all_zzjg_1.jgmc)==jg2_str INTO CURSOR jg_2_zz
	SELECT jg_1_zz.zzmc as jg1_zz,jg_2_zz.zzmc as jg2_zz FROM jg_1_zz FULL JOIN jg_2_zz ON ALLTRIM(jg_1_zz.zzmc)==ALLTRIM(jg_2_zz.zzmc) INTO CURSOR zz
	&&计算zz中有多少条记录，将这个值存到n中
	select COUNT(*) as count_num from zz into cursor temp
	SCAN
		n=temp.count_num 
	ENDSCAN 
	SELECT zz
	DIMENSION jg1(n),jg2(n)
	i=1 &&数组下标
	&&表中作者为null值，在数组中记0，否则记1，用于后面计算余弦值
	SCAN 
		jg1_zz_str=ALLTRIM(zz.jg1_zz)
		jg2_zz_str=ALLTRIM(zz.jg2_zz)
		if(ISNULL(jg1_zz_str))
			jg1(i)=0
		ELSE 
			jg1(i)=1
		ENDIF 
		if(ISNULL(jg2_zz_str))
			jg2(i)=0
		ELSE 
			jg2(i)=1
		ENDIF 
		i = i + 1 	
	ENDSCAN 
	numerator=0 
	denominator1=0 
	denominator2=0
	&&计算余弦值
	FOR j=1 TO n
		numerator = numerator + jg1(j)*jg2(j) 
		denominator1 = denominator1 + jg1(j)*jg1(j) 
		denominator2 = denominator2 + jg2(j)*jg2(j) 
	ENDFOR 
	denominator=SQRT(denominator1)*SQRT(denominator2) 
	similar=numerator/denominator
	&&替换jg_sim表中sim值 
	SELECT a
	replace jg_sim.sim WITH similar
ENDSCAN 