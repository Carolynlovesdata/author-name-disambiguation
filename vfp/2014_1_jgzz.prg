&&取出14年表中的文件序号、作者排名、作者名称、机构名称字段，并将作者名称字段和机构名称字段中的字符串分隔开
&&使得一条记录中一个作者对应一个机构
CLOSE ALL
SELECT * FROM c870_2014_1 WHERE 1>2 INTO TABLE c870_2014_2
SELECT c870_2014_1
SCAN
	sno_str=ALLTRIM(c870_2014_1.sno)
	zzpm_int=1 &&作者排名
	zzmcs_str=ALLTRIM(c870_2014_1.zzmc) &&作者名称
	jgmcs_str=ALLTRIM(c870_2014_1.jgmc) &&机构名称
	
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
