&&操纵表zz_jgs，对作者机构做进一步的处理，认为南京大学、南京大学信息管理学院、南京大学信息管理系
&&属于同个单位，即同个名字下的多条记录中的多个机构名称若是前面的字符同最短的那个机构
&&名称能够匹配，就认为它们属于一个机构。处理后的数据存入表zz_jgs1中

CLOSE ALL
SELECT zzmc,jgmc FROM zz_jgs WHERE 1>2 INTO TABLE zz_jgs1
SELECT zz_jgs
base_zz=ALLTRIM("LEYDESDORFF,LOET")
base_jg=ALLTRIM("UNIVERSITY OF AMSTERDAM")
INSERT INTO zz_jgs1 (zzmc,jgmc) VALUES (base_Zz,base_jg)
i=1
SCAN
	if(i<4) &&控制记录比较的开始
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


