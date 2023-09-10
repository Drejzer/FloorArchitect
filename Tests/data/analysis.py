import numpy as np
import pandas as pd
import matplotlib.pyplot as pp

#dataw10=pd.concat([pd.read_csv("RGFA_10_p5-5.csv",sep=';'),pd.read_csv("LEWFA_5-5.csv",sep=';'),pd.read_csv("SAWFA_5-5.csv",sep=';')])
datarg=pd.concat([pd.read_csv("RGFA_10_p5-5.csv",sep=';'),pd.read_csv("RGFA_25_p5-5.csv",sep=';'),pd.read_csv("RGFA_50_p5-5.csv",sep=';'),pd.read_csv('RGFA_100_p5-5.csv',sep=';')])
datapac=pd.concat([pd.read_csv("PACFA_10_2.csv",sep=';'),pd.read_csv("PACFA_25_5.csv",sep=';'),pd.read_csv("PACFA_50_10.csv",sep=';'),pd.read_csv('PACFA_100_20.csv',sep=';')])
#datasew=pd.concat([pd.read_csv("SEWFA_25_p3-3.csv",sep=';'),pd.read_csv("LEWFA_13-12.csv",sep=';'),pd.read_csv("SAWFA_13-12.csv",sep=';')])


ptrm=pd.pivot_table(datapac,values=["LeafCount","ConnectorCount",'3CrossCount','4CrossCount'],index=['RoomCount'],aggfunc='mean')

print(ptrm)

axes=ptrm.T.plot(kind="pie",subplots=True,layout=(2,2), figsize=(7,7),autopct="%.2f%%",startangle=90.0,counterclock=False,labeldistance=None)

for ax in axes.flat:
    if ax==axes[0,0]:
        ax.legend(loc='upper center',bbox_to_anchor=(1.05,1.05),ncol=4)
    else:
        ax.get_legend().remove()
    yl=ax.get_label()
    ax.set(title=yl)

pp.show()

ptt=pd.pivot_table(datarg,values=["GenTime"],index=['RoomCount'],aggfunc='mean')
print(ptt)

