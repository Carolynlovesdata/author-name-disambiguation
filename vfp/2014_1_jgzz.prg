&&ȡ��14����е��ļ���š������������������ơ����������ֶΣ��������������ֶκͻ��������ֶ��е��ַ����ָ���
&&ʹ��һ����¼��һ�����߶�Ӧһ������
CLOSE ALL
SELECT * FROM c870_2014_1 WHERE 1>2 INTO TABLE c870_2014_2
SELECT c870_2014_1
SCAN
	sno_str=ALLTRIM(c870_2014_1.sno)
	zzpm_int=1 &&��������
	zzmcs_str=ALLTRIM(c870_2014_1.zzmc) &&��������
	jgmcs_str=ALLTRIM(c870_2014_1.jgmc) &&��������
	
	pos_zz=ATCC("/",zzmcs_str)
	pos_jg=RATC("/",jgmcs_str)
	pos_jgzz=RATC("]",jgmcs_str)
	DO WHILE pos_zz>0
		zzmc_str=ALLTRIM(SUBSTRC(zzmcs_str,1,pos_zz-1))
		jgmc_str=ALLTRIM(SUBSTRC(jgmcs_str,pos_jgzz+1))
		INSERT INTO c870_2014_2 (sno,zzpm,zzmc,jgmc) VALUES (sno_str,zzpm_int,zzmc_str,jgmc_str)
		
		zzpm_int = zzpm_int + 1
		zzmcs_str=ALLTRIM(SUBSTRC(zzmcs_str,pos_zz+1))
		pos_zz=ATCC("/",zzmcs_str)
		jgmcs_str=ALLTRIM(SUBSTRC(jgmcs_str,1,pos_jg-1))
		pos_jg=RATC("/",jgmcs_str)
		pos_jgzz=RATC("]",jgmcs_str)
	ENDDO
	IF LENC(zzmcs_str)>0
		jgmcs_str=ALLTRIM(SUBSTRC(jgmcs_str,pos_jgzz+1))
		INSERT INTO c870_2014_2 (sno,zzpm,zzmc,jgmc) VALUES (sno_str,zzpm_int,zzmcs_str,jgmcs_str)
	ENDIF
ENDSCAN
