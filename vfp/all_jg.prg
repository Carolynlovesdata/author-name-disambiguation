&&多个表汇总后发现13年数据和14年数据没有处理好，13年数据机构名称字段中有机构代号，14年数据机构名称字段中末尾有点或
&&字符串中间有点，而老师整理的13年前的数据没有这些东西，这个程序将这些方面统一起来
CLOSE ALL
use c870_2014_2
SCAN
	jgmc_Str=ALLTRIM(c870_2014_2.jgmc)
	pos_epo=RATC(".",jgmc_str)
	if(pos_epo==LENC(jgmc_str)) &&说明该点在末尾,要删掉
		jgmc_str=ALLTRIM(SUBSTRC(jgmc_str,1,LENC(jgmc_str)-1))
		pos_epo=atcc(".",jgmc_str)
	ENDIF 
	if(pos_epo>0) &&中间有点
		jgmc_str=(ALLTRIM(SUBSTRC(jgmc_Str,1,pos_epo-1))+ALLTRIM(SUBSTRC(jgmc_str,pos_epo+1)))
	ENDIF
	replace jgmc WITH jgmc_str
	if(c870_2014_2.years<>2013)
		LOOP
	ENDIF 
	pos_com=RATC(",",jgmc_str)  &&解决13年机构名称中含机构代号的问题
	if(pos_com>0) 
		jgmc_str=ALLTRIM(SUBSTRC(jgmc_str,1,pos_com-1))
		replace jgmc WITH jgmc_str
	ENDIF
	if(c870_2014_2.years<>2013 and c870_2014_2.years<>2014)
		exit
	ENDIF 	
ENDSCAN 