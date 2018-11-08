# -*- coding: utf-8 -*-
"""
Created on Fri Sep  7 11:08:17 2018

@author: keroulin
"""

import pymysql
#import pandas.io.sql as sql
import pandas as pd
import numpy as np


#计算分词后机构名的相似度(df1和df2是以机构名为索引，只含有一列的DataFrame，
#这一列值全为1）
def sim(df1,df2):
    df3=df1.join(df2,how='outer')
    df3=df3.fillna(0) #用0填充nan值
    numerator=0
    denominator1=0
    denominator2=0
    for i in range(0,df3.iloc[:,0].size):
        numerator+=df3.iloc[i,0]*df3.iloc[i,1] #余弦相似度的分子
        denominator1+=np.square(df3.iloc[i,0])
        denominator2+=np.square(df3.iloc[i,1])
    denominator=np.sqrt(denominator1)*np.sqrt(denominator2) #余弦相似度的分母
    cos=numerator/denominator
    return cos

def read_table():
    #将mysql数据库author_diff中的表jg_sim导入python的dataframe结构
    conn=pymysql.connect(host='127.0.0.1',port=3306,user='author_diff',passwd='linkerou123',db='author_diff',charset='utf8')
    cursor=conn.cursor()
    cursor.execute("select * from jg_sim")
    rows=cursor.fetchall()
    df=pd.DataFrame(list(rows),columns=list(zip(*cursor.description))[0])
#有误    df=pd.DataFrame(rows)
#    conn.commit() #提交，使数据库中的表和缓存中的表的一致
    cursor.close()
    conn.close()
    return df
    
def sql_query(zzmc,jgmc):
    conn=pymysql.connect(host='127.0.0.1',port=3306,user='author_diff',passwd='linkerou123',db='author_diff',charset='utf8')
    cursor=conn.cursor()
    cursor.execute("select distinct zzmc from all_zzjg_2 where sno in (select sno from all_zzjg_2 where trim(zzmc)=%s and trim(jgmc)=%s) and trim(zzmc)<>%s",(zzmc,jgmc,zzmc))
    rows=cursor.fetchall()
    df=pd.DataFrame(list(rows),columns=list(zip(*cursor.description))[0])
#    df=pd.DataFrame(rows)
    cursor.close()
    conn.close()
    return df

if __name__ == '__main__':
    df=read_table()
#    for i in range(0,df.iloc[:,0].size):
    value1=[]
    value2=[]
    for i in range(0,100):
        if(i%10==0):
            print('进行到第%s条记录了',str(i))
        
        zzmc=df.loc[i,'ZZMC'].strip()
        jg1=df.loc[i,'JG1'].strip()
        jg2=df.loc[i,'JG2'].strip()
        
        if(i!=0 and zzmc==df.loc[i-1,'ZZMC'].strip() and jg1==df.loc[i-1,'JG1'].strip()):
            if(value1==[]):
                flag=0
        else:
            df_hzz1=sql_query(zzmc,jg1)
            value1=[1.0 for k in range(0,df_hzz1.iloc[:,0].size)]
            df_hzz1['value1']=value1
            if value1==[]:
                flag=0
            else:
               # df_hzz1=df_hzz1.set_index(['zzmc'])
               df_hzz1.set_index(['zzmc'],inplace=True)
        
        if(i!=0 and zzmc==df.loc[i-1,'ZZMC'].strip() and jg2==df.loc[i-1,'JG2'].strip()):
            if(value2==[]):
                flag=0
        else: 
            df_hzz2=sql_query(zzmc,jg2)
            value2=[1.0 for k in range(0,df_hzz2.iloc[:,0].size)]
            df_hzz2['value2']=value2
            if value2==[]:
                flag=0
            else:
              #  df_hzz2=df_hzz2.set_index(['zzmc'])
                df_hzz2.set_index(['zzmc'],inplace=True)
        
        if(flag==1):
            df.loc[i,'SIM3']=sim(df_hzz1,df_hzz2)
        else:
            df.loc[i,'SIM3']=-1
        
    #将dataframe中的内容写入数据库，覆盖掉原来的jg_sim表 
#    from sqlalchemy import create_engine
#    conn=create_engine('mysql+pymysql://author_diff:linkerou123@localhost:3306/author_diff?charset=utf8')
#    sql.to_sql(df,'jg_sim',conn,schema='author_diff',if_exists='replace',index=False)




















