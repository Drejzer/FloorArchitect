import numpy as np
import pandas as pd
import matplotlib.pyplot as pp

data10= pd.read_csv("RGFA_10_p3-3.csv",sep=';')
data25=pd.read_csv("RGFA_25_p3-3.csv",sep=';')
data50=pd.read_csv("RGFA_50_p3-3.csv",sep=';')
data100=pd.read_csv("RGFA_100_p3-3.csv",sep=';')
total=pd.concat([data10,data25,data50,data100])

xtab=pd.crosstab(total["Algorithm"],total["RoomCount"],total["GenTime"],aggfunc='mean')

print(xtab)