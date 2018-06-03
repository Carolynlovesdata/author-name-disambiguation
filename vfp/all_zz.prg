&&识别出研究对象：有多个单位的同名作者。先粗略的识别，即机构名称不完全相同的全都识别
&&出来，如武汉大学，武汉大学信息管理学院也都认为是不同的单位
CLOSE ALL
SELECT all_zzjg_1.zzmc,all_zzjg_1.jgmc FROM all_zzjg_1 WHERE 1>2 INTO TABLE zz_jgs
SELECT all_zzjg_1
base_zz=ALLTRIM("（韩）晋永美")
base_jg=ALLTRIM("北京大学")
i=1
count_jg=1 &&识别出同名作者插入两个机构与插入两个以上机构的不同方法
SCAN
	if(i<5) &&从第二条记录开始和第一条记录比较
		i = i + 1 
		loop
	ENDIF
	comp_zz=ALLTRIM(all_zzjg_1.zzmc) &&保持comp_zz是base_zz的下一条记录
	comp_jg=ALLTRIM(all_zzjg_1.jgmc) &&保持comp_jg是base_jg的下一条记录
	if(base_zz==comp_zz)
		if(base_jg==comp_jg)
			base_zz=comp_zz
			base_jg=comp_jg
		ELSE &&作者名称同，机构不同
			if(count_jg<2)
				INSERT INTO zz_jgs (zzmc,jgmc) VALUES (base_zz,base_jg)
				INSERT INTO zz_jgs (zzmc,jgmc) VALUES (comp_zz,comp_jg)
				base_zz=comp_zz
				base_jg=comp_jg
				count_jg = count_jg + 1 
			ELSE &&有两个以上的机构
				INSERT INTO zz_jgs (zzmc,jgmc) VALUES (comp_zz,comp_jg)
				base_zz=comp_zz
				base_jg=comp_jg
			ENDIF
		ENDIF 
	ELSE
		count_jg=1
		base_zz=comp_zz
		base_jg=comp_jg
	endif
ENDSCAN 
