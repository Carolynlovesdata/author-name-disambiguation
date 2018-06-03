k='jgno_39'
SELECT &k..zzmc,&k..jgmc as jg1,jgno_40.jgmc as jg2 FROM jgno_40 left JOIN &k. ON ALLTRIM(&k..zzmc)==ALLTRIM(jgno_40.zzmc) INTO cursor jg_sim1
SELECT jg_sim
APPEND FROM DBF('jg_sim1')
