4&&依据机构中作者的重合程度计算两个机构的相似度，结果写入表jg_sim中
CLOSE ALL
USE jg_sim IN a
USE all_zzjg_1 IN b &&改成总表
SELECT a
SCAN
	jg1_str=ALLTRIM(jg_sim.jg1)
	jg2_Str=ALLTRIM(jg_sim.jg2)
	SELECT b
	&&从all_zzjg_1中取出和jg1与jg2机构相同的作者，每个作者只取一个
	SELECT distinct all_zzjg_1.sno FROM all_zzjg_1 WHERE ALLTRIM(all_zzjg_1.jgmc)==jg1_str INTO CURSOR jg_1_pm
	SELECT distinct all_zzjg_1.sno FROM all_zzjg_1 WHERE ALLTRIM(all_zzjg_1.jgmc)==jg2_str INTO CURSOR jg_2_pm
	SELECT jg_1_pm
	SCAN 
		SELECT distinct all_zzjg_1.jgmc FROM all_zzjg_1 WHERE ALLTRIM(all_zzjg_1.sno)=jg_1_pm.sno INTO CURSOR jg_1_hzjg
	ENDSCAN
	SELECT jg_2_pm 
	SCAN 
		SELECT distinct all_zzjg_1.jgmc FROM all_zzjg_1 WHERE ALLTRIM(all_zzjg_1.sno)=jg_2_pm.sno INTO CURSOR jg_2_hzjg	
	ENDSCAN 
	SELECT jg_1_hzjg.jgmc as jg1_hzjg,jg_2_hzjg.jgmc as jg2_hzjg FROM jg_1_hzjg FULL JOIN jg_2_hzjg ON ALLTRIM(jg_1_hzjg.jgmc)==ALLTRIM(jg_2_hzjg.jgmc) INTO CURSOR hzjg
	&&计算zz中有多少条记录，将这个值存到n中
	select COUNT(*) as count_num from hzjg into cursor temp
	SCAN
		n=temp.count_num 
	ENDSCAN 
	SELECT hzjg
	DIMENSION jg1(n),jg2(n)
	i=1 &&数组下标
	&&表中作者为null值，在数组中记0，否则记1，用于后面计算余弦值
	SCAN 
		jg1_hzjg_str=ALLTRIM(hzjg.jg1_hzjg)
		jg2_hzjg_str=ALLTRIM(hzjg.jg2_hzjg)
		if(ISNULL(jg1_hzjg_str))
			jg1(i)=0
		ELSE 
			jg1(i)=1
		ENDIF 
		if(ISNULL(jg2_hzjg_str))
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