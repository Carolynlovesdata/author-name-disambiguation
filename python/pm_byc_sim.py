# -*- coding: utf-8 -*-
"""
Created on Wed Aug 29 16:34:50 2018

@author: keroulin
"""

import pymysql
import pandas.io.sql as sql
import pandas as pd
import numpy as np
import pynlpir


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
    if(denominator==0):
        cos=-1 #jg_sim表中jgmc字段有数据错误，会导致在all_zzjg_2中找不到某个实体的相关记录
    else:
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
    cursor.execute("select * from all_zzjg_2 where trim(zzmc)=%s and trim(jgmc)=%s",(zzmc,jgmc))
    rows=cursor.fetchall()
    df=pd.DataFrame(list(rows),columns=list(zip(*cursor.description))[0])
#    df=pd.DataFrame(rows)
    cursor.close()
    conn.close()
    return df

def pm_process(pm_after,pm_before,stopwords_dir): #pm_after是篇名处理好的列表，pm_before是要分词的标题字符串，stopwords_dir是停词表的路径
    pm=pynlpir.segment(pm_before,pos_tagging=False) #生成一个分词列表
    with open(stopwords_dir,'r',encoding='utf-8') as f:
        stopwords=[line.strip() for line in f.readlines()]
    for word in pm:
        if word not in stopwords and word not in pm_after:
            pm_after.append(word)
    return pm_after

def byc_process(byc_after,byc_before):#byc_after是标引词处理好（拆分和去重）的标引词列表，byc_before是要拆分的标引词字符串
    byc=[word.strip() for word in byc_before.split('/')] #生成一个标引词列表
    for word in byc:
        if word not in byc_after:
            byc_after.append(word)
    return byc_after

if __name__ == '__main__':
    df=read_table()

    #将机构分词并存在一个dataframe中，索引为词，column名为value，value均为1
    pynlpir.open()
    stopwords_dir='哈工大停用词表.txt'
    for i in range(0,df.iloc[:,0].size):
        if(i%1000==0):
            print('进行到第%s条记录了',i)
        zzmc=df.loc[i,'ZZMC'].strip()
        jg1=df.loc[i,'JG1'].strip()
        jg2=df.loc[i,'JG2'].strip()
        
        if(i!=0 and zzmc==df.loc[i-1,'ZZMC'].strip() and jg1==df.loc[i-1,'JG1'].strip()):
            pass
        else:
            #第一个实体的标题DataFrame的生成
            pm_topic1=[] #pm_topic中存放分词且停词后不重复的代表标题的词
            df_1=sql_query(zzmc,jg1) 
            
            for j in range(0,df_1.iloc[:,0].size):
                pm=df_1.loc[j,'LYPM'].strip()
                pm_topic1=pm_process(pm_topic1,pm,stopwords_dir)
            value1=[1.0 for k in range(0,len(pm_topic1))]
            df_pm1=pd.DataFrame(value1,index=pm_topic1,columns=['value1'])
            #第一个实体的标引词DataFrame的生成
            byc_topic1=[]
            for j in range(0,df_1.iloc[:,0].size):
                byc=df_1.loc[j,'BYC'].strip()
                byc_topic1=byc_process(byc_topic1,byc)
            while '' in byc_topic1: #避免截出来的词中有空字符串
                byc_topic1.remove('')
            value1=[1.0 for k in range(0,len(byc_topic1))]
            df_byc1=pd.DataFrame(value1,index=byc_topic1,columns=['value1'])
            
        if(i!=0 and zzmc==df.loc[i-1,'ZZMC'].strip() and jg2==df.loc[i-1,'JG2'].strip()):
            pass
        else:        
            #第二个实体的标题DataFrame的生成
            pm_topic2=[] #pm_topic中存放分词且停词后不重复的代表标题的词
            df_2=sql_query(zzmc,jg2)        
            for j in range(0,df_2.iloc[:,0].size):
                pm=df_2.loc[j,'LYPM'].strip()
                pm_topic2=pm_process(pm_topic2,pm,stopwords_dir)
            value2=[1.0 for k in range(0,len(pm_topic2))]
            df_pm2=pd.DataFrame(value2,index=pm_topic2,columns=['value2'])
            #第二个实体的标引词DataFrame生成
            byc_topic2=[]
            for j in range(0,df_2.iloc[:,0].size):
                byc=df_2.loc[j,'BYC'].strip()
                byc_topic2=byc_process(byc_topic2,byc)
            while '' in byc_topic2:
                byc_topic2.remove('')
            value2=[1.0 for k in range(0,len(byc_topic2))]
            df_byc2=pd.DataFrame(value2,index=byc_topic2,columns=['value2'])
        
        #计算两个实体标题相似度
        df.loc[i,'SIM4']=sim(df_pm1,df_pm2)        
        #计算两个实体标引词相似度
        df.loc[i,'SIM5']=sim(df_byc1,df_byc2)
        


    pynlpir.close()

    #将dataframe中的内容写入数据库，覆盖掉原来的jg_sim表 
    from sqlalchemy import create_engine
    conn=create_engine('mysql+pymysql://author_diff:linkerou123@localhost:3306/author_diff?charset=utf8')
    sql.to_sql(df,'jg_sim',conn,schema='author_diff',if_exists='replace',index=False)
    
    
    
    
    
    
    
