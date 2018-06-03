&&将13年表中的作者名称和机构名称中的多个字符串分开分开，使得一条记录中一个作者对应一个机构
CLOSE ALL
USE c870_2013
SELECT * FROM c870_2013 WHERE 1>2 INTO TABLE c870_2013_1
SELECT c870_2013
SCAN
	sno_str=ALLTRIM(c870_2013.sno)
	zzpm_int=1 &&作者排名
	zzmcs_str=ALLTRIM(c870_2013.zzmc) &&作者名称
	jgmcs_str=ALLTRIM(c870_2013.jgmc) &&机构名称
	lypm_str=ALLTRIM(c870_2013.lypm)
	byc_str=ALLTRIM(c870_2013.byc)
	xkfl_str=ALLTRIM(c870_2013.学科分类)
	qk_str=ALLTRIM(c870_2013.期刊)
	ztlh_str=ALLTRIM(c870_2013.中图类号)
	year_str=ALLTRIM(c870_2013.年)
	
	pos_zz=ATCC("/",zzmcs_str)
	pos_jg=ATCC("/",jgmcs_str)
	DO WHILE pos_zz>0
		zzmc_str=ALLTRIM(SUBSTRC(zzmcs_str,1,pos_zz-1))
		jgmc_str=ALLTRIM(SUBSTRC(jgmcs_str,1,pos_jg-1))
		INSERT INTO c870_2013_1 (sno,zzpm,zzmc,jgmc,lypm,byc,学科分类,期刊,中图类号,年) VALUES (sno_str,zzpm_int,zzmc_str,jgmc_str,lypm_str,byc_str,xkfl_str,qk_str,ztlh_str,year_str)
		zzpm_int = zzpm_int + 1 
		zzmcs_str=ALLTRIM(SUBSTRC(zzmcs_str,pos_zz+1))
		pos_zz=ATCC("/",zzmcs_str)
		jgmcs_str=ALLTRIM(SUBSTRC(jgmcs_str,pos_jg+1))
		pos_jg=ATCC("/",jgmcs_str)
	ENDDO
	IF LENC(zzmcs_str)>0
		INSERT INTO c870_2013_1 (sno,zzpm,zzmc,jgmc,lypm,byc,学科分类,期刊,中图类号,年) VALUES (sno_str,zzpm_int,zzmcs_str,jgmcs_str,lypm_str,byc_str,xkfl_str,qk_str,ztlh_str,year_str)
	ENDIF
ENDSCAN 
	