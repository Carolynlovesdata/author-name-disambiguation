&&���ݻ��������ߵ��غϳ̶ȼ����������������ƶȣ����д���jg_sim��
CLOSE ALL
USE jg_sim IN a
USE all_zzjg_1 IN b
SELECT a
SCAN
	jg1_str=ALLTRIM(jg_sim.jg1)
	jg2_Str=ALLTRIM(jg_sim.jg2)
	SELECT b
	&&��all_zzjg_1��ȡ����jg1��jg2������ͬ�����ߣ�ÿ������ֻȡһ��
	SELECT distinct all_zzjg_1.zzmc FROM all_zzjg_1 WHERE ALLTRIM(all_zzjg_1.jgmc)==jg1_str INTO CURSOR jg_1_zz
	SELECT distinct all_zzjg_1.zzmc FROM all_zzjg_1 WHERE ALLTRIM(all_zzjg_1.jgmc)==jg2_str INTO CURSOR jg_2_zz
	SELECT jg_1_zz.zzmc as jg1_zz,jg_2_zz.zzmc as jg2_zz FROM jg_1_zz FULL JOIN jg_2_zz ON ALLTRIM(jg_1_zz.zzmc)==ALLTRIM(jg_2_zz.zzmc) INTO CURSOR zz
	&&����zz���ж�������¼�������ֵ�浽n��
	select COUNT(*) as count_num from zz into cursor temp
	SCAN
		n=temp.count_num 
	ENDSCAN 
	SELECT zz
	DIMENSION jg1(n),jg2(n)
	i=1 &&�����±�
	&&��������Ϊnullֵ���������м�0�������1�����ں����������ֵ
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
	&&��������ֵ
	FOR j=1 TO n
		numerator = numerator + jg1(j)*jg2(j) 
		denominator1 = denominator1 + jg1(j)*jg1(j) 
		denominator2 = denominator2 + jg2(j)*jg2(j) 
	ENDFOR 
	denominator=SQRT(denominator1)*SQRT(denominator2) 
	similar=numerator/denominator
	&&�滻jg_sim����simֵ 
	SELECT a
	replace jg_sim.sim WITH similar
ENDSCAN 