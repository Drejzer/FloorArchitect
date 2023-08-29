import numpy as np
import pandas as pd
import matplotlib.pyplot as pp

data10=pd.concat([pd.read_csv("RGFA_10_p3-3.csv",sep=';'),pd.read_csv("LEWFA_5-5.csv",sep=';'),pd.read_csv("SAWFA_5-5.csv",sep=';')])
data25=pd.concat([pd.read_csv("RGFA_25_p3-3.csv",sep=';'),pd.read_csv("LEWFA_13-12.csv",sep=';'),pd.read_csv("SAWFA_13-12.csv",sep=';')])
data50=pd.concat([pd.read_csv("RGFA_50_p3-3.csv",sep=';'),pd.read_csv("LEWFA_25-25.csv",sep=';'),pd.read_csv("SAWFA_25-25.csv",sep=';')])
data100=pd.concat([pd.read_csv("RGFA_100_p3-3.csv",sep=';'),pd.read_csv("LEWFA_50-50.csv",sep=';'),pd.read_csv("SAWFA_50-50.csv",sep=';')])
total=pd.concat([data10,data25,data50,data100])

total["connectors"]=total["RoomCount"]-(total["LeafCount"]+total["3CrossCount"]+total["4CrossCount"])

total["s1perc"]=(100.0*total["LeafCount"])/(1.0*total["RoomCount"])
total["s2perc"]=(100.0*total["connectors"])/(1.0*total["RoomCount"])
total["s3perc"]=(100.0*total["3CrossCount"])/(1.0*total["RoomCount"])
total["s4perc"]=(100.0*total["4CrossCount"])/(1.0*total["RoomCount"])

pt=pd.pivot_table(total,values=["LeafCount","connectors",'3CrossCount','4CrossCount'],index=['Algorithm','RoomCount'],aggfunc='mean')

print(pt)


xtab=pd.crosstab(total["Algorithm"],total["RoomCount"],total["GenTime"],aggfunc='mean')

xtab.plot(kind="bar",stacked=False)
pp.show()

