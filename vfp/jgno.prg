&&��¼ĳ��������ĳ��ͬ��ѧ�ߵĵڼ�������
CLOSE ALL
USE zz_jgs
base_zz=ALLTRIM('��������')
i=1 &&�ж�ĳ��������ͬ�����ߵĵڼ�������
j=1 &&ʹ���ɨ��ӵڶ�����¼��ʼ
SCAN 
	if(j==1)
		j = j + 1 &&ʹ���ɨ��ӵڶ�����¼��ʼ
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