&&���ݱ�zz_jgs1���ѱ�zz_jgs1��ģ��ƥ����ж��������������ȡ����
CLOSE ALL
SELECT zz_jgs1.zzmc FROM zz_jgs1 WHERE 1>2 INTO table zz_jgs2
SELECT zz_jgs1
base_zz=ALLTRIM("LEYDESDORFF,LOET")
i=1
count_jg=1 &&��¼���߶�Ӧ����������
SCAN
	if(i<2)
		i=i+1
		loop
	ENDIF
	comp_zz=ALLTRIM(zz_jgs1.zzmc)
	if(base_zz==comp_zz)
		count_jg = count_jg + 1 
	ELSE &&�������Ƹı�
		if(count_jg>1)
			INSERT INTO zz_jgs2 (zzmc) VALUES (base_zz)
		ENDIF
		base_zz=comp_zz
		count_jg=1 
	ENDIF 
ENDSCAN
