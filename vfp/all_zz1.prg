&&���ݱ�zz_jgs�������߻�������һ���Ĵ�����Ϊ�Ͼ���ѧ���Ͼ���ѧ��Ϣ����ѧԺ���Ͼ���ѧ��Ϣ����ϵ
&&����ͬ����λ����ͬ�������µĶ�����¼�еĶ��������������ǰ����ַ�ͬ��̵��Ǹ�����
&&�����ܹ�ƥ�䣬����Ϊ��������һ�����������������ݴ����zz_jgs1��

CLOSE ALL
SELECT zzmc,jgmc FROM zz_jgs WHERE 1>2 INTO TABLE zz_jgs1
SELECT zz_jgs
base_zz=ALLTRIM("LEYDESDORFF,LOET")
base_jg=ALLTRIM("UNIVERSITY OF AMSTERDAM")
INSERT INTO zz_jgs1 (zzmc,jgmc) VALUES (base_Zz,base_jg)
i=1
SCAN
	if(i<4) &&���Ƽ�¼�ȽϵĿ�ʼ
		i = i + 1 
		LOOP
	ENDIF 
	comp_zz=ALLTRIM(zz_jgs.zzmc)
	comp_jg=ALLTRIM(zz_jgs.jgmc)
	if(base_zz==comp_zz)
		if(comp_jg=base_jg)
			LOOP
		ELSE
			base_zz=comp_zz
			base_jg=comp_jg
			INSERT INTO zz_jgs1 (zzmc,jgmc) VALUES (base_zz,base_jg)
		ENDIF
	ELSE
		base_zz=comp_zz
		base_jg=comp_jg
		INSERT INTO zz_jgs1 (zzmc,jgmc) VALUES (base_zz,base_jg)
	ENDIF 
ENDSCAN


