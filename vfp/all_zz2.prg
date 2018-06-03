&&操纵表zz_jgs1，把表zz_jgs1中模糊匹配后有多个机构的作者提取出来
CLOSE ALL
SELECT zz_jgs1.zzmc FROM zz_jgs1 WHERE 1>2 INTO table zz_jgs2
SELECT zz_jgs1
base_zz=ALLTRIM("LEYDESDORFF,LOET")
i=1
count_jg=1 &&记录作者对应机构的数量
SCAN
	if(i<2)
		i=i+1
		loop
	ENDIF
	comp_zz=ALLTRIM(zz_jgs1.zzmc)
	if(base_zz==comp_zz)
		count_jg = count_jg + 1 
	ELSE &&作者名称改变
		if(count_jg>1)
			INSERT INTO zz_jgs2 (zzmc) VALUES (base_zz)
		ENDIF
		base_zz=comp_zz
		count_jg=1 
	ENDIF 
ENDSCAN
