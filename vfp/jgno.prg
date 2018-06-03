&&记录某个机构是某个同名学者的第几个机构
CLOSE ALL
USE zz_jgs
base_zz=ALLTRIM('阿旺华丹')
i=1 &&判断某个机构是同名作者的第几个机构
j=1 &&使表的扫描从第二条记录开始
SCAN 
	if(j==1)
		j = j + 1 &&使表的扫描从第二条记录开始
		loop
	ENDIF 
	comp_zz=ALLTRIM(zz_jgs.zzmc)
	if(comp_zz==base_zz)
		i = i + 1 
	ELSE
		i=1
	ENDIF 
	base_zz=comp_zz
	replace jgno WITH i
ENDSCAN 