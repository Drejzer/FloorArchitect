import numpy as np
import pandas as pd
import matplotlib.pyplot as pp


#data=pd.concat([pd.read_csv("10RandomWalker_1W-1l_0cb_0awc_t.csv",sep=';'),pd.read_csv("25RandomWalker_1W-1l_0cb_0awc_t.csv",sep=';'),pd.read_csv("50RandomWalker_1W-1l_0cb_0awc_t.csv",sep=';'),pd.read_csv("100RandomWalker_1W-1l_0cb_0awc_t.csv",sep=';')])
#data=pd.concat([pd.read_csv("10RandomWalker_1W-1l_4cb_0awc_t.csv",sep=';'),pd.read_csv("25RandomWalker_1W-1l_4cb_0awc_t.csv",sep=';'),pd.read_csv("50RandomWalker_1W-1l_4cb_0awc_t.csv",sep=';'),pd.read_csv("100RandomWalker_1W-1l_4cb_0awc_t.csv",sep=';')])
#data=pd.concat([pd.read_csv("10RandomWalker_4W-1l_4cb_0awc_t.csv",sep=';'),pd.read_csv("25RandomWalker_4W-1l_4cb_0awc_t.csv",sep=';'),pd.read_csv("50RandomWalker_4W-1l_4cb_0awc_t.csv",sep=';'),pd.read_csv("100RandomWalker_4W-1l_4cb_0awc_t.csv",sep=';')])
#data=pd.concat([pd.read_csv("10RandomWalker_4W-1l_0cb_0awc_t.csv",sep=';'),pd.read_csv("25RandomWalker_4W-1l_0cb_0awc_t.csv",sep=';'),pd.read_csv("50RandomWalker_4W-1l_0cb_0awc_t.csv",sep=';'),pd.read_csv("100RandomWalker_4W-1l_0cb_0awc_t.csv",sep=';')])
#data=pd.concat([pd.read_csv("10RandomWalker_4Wx02l_4cb_0awc_t.csv",sep=';'),pd.read_csv("25RandomWalker_4Wx02l_4cb_0awc_t.csv",sep=';'),pd.read_csv("50RandomWalker_4Wx02l_4cb_0awc_t.csv",sep=';'),pd.read_csv("100RandomWalker_4Wx02l_4cb_0awc_t.csv",sep=';')])
#data=pd.concat([pd.read_csv("10RandomWalker_1Wx02l_4cb_0awc_t.csv",sep=';'),pd.read_csv("25RandomWalker_1Wx02l_4cb_0awc_t.csv",sep=';'),pd.read_csv("50RandomWalker_1Wx02l_4cb_0awc_t.csv",sep=';'),pd.read_csv("100RandomWalker_1Wx02l_4cb_0awc_t.csv",sep=';')])
#data=pd.concat([pd.read_csv("10RandomWalker_1Wx02l_0cb_02awc01l_t.csv",sep=';'),pd.read_csv("25RandomWalker_1Wx02l_0cb_02awc01l_t.csv",sep=';'),pd.read_csv("50RandomWalker_1Wx02l_0cb_02awc01l_t.csv",sep=';'),pd.read_csv("100RandomWalker_1Wx02l_0cb_02awc01l_t.csv",sep=';')])

#data=pd.concat([data,pd.read_csv("10RandomWalker_1W-1l_0cb_0awc_l.csv",sep=';'),pd.read_csv("25RandomWalker_1W-1l_0cb_0awc_l.csv",sep=';'),pd.read_csv("50RandomWalker_1W-1l_0cb_0awc_l.csv",sep=';'),pd.read_csv("100RandomWalker_1W-1l_0cb_0awc_l.csv",sep=';')])
#data=pd.concat([data,pd.read_csv("10RandomWalker_1W-1l_4cb_0awc_l.csv",sep=';'),pd.read_csv("25RandomWalker_1W-1l_4cb_0awc_l.csv",sep=';'),pd.read_csv("50RandomWalker_1W-1l_4cb_0awc_l.csv",sep=';'),pd.read_csv("100RandomWalker_1W-1l_4cb_0awc_l.csv",sep=';')])
#data=pd.concat([data,pd.read_csv("10RandomWalker_4W-1l_4cb_0awc_l.csv",sep=';'),pd.read_csv("25RandomWalker_4W-1l_4cb_0awc_l.csv",sep=';'),pd.read_csv("50RandomWalker_4W-1l_4cb_0awc_l.csv",sep=';'),pd.read_csv("100RandomWalker_4W-1l_4cb_0awc_l.csv",sep=';')])
#data=pd.concat([data,pd.read_csv("10RandomWalker_4W-1l_0cb_0awc_l.csv",sep=';'),pd.read_csv("25RandomWalker_4W-1l_0cb_0awc_l.csv",sep=';'),pd.read_csv("50RandomWalker_4W-1l_0cb_0awc_l.csv",sep=';'),pd.read_csv("100RandomWalker_4W-1l_0cb_0awc_l.csv",sep=';')])
#data=pd.concat([data,pd.read_csv("10RandomWalker_4Wx02l_4cb_0awc_l.csv",sep=';'),pd.read_csv("25RandomWalker_4Wx02l_4cb_0awc_l.csv",sep=';'),pd.read_csv("50RandomWalker_4Wx02l_4cb_0awc_l.csv",sep=';'),pd.read_csv("100RandomWalker_4Wx02l_4cb_0awc_l.csv",sep=';')])
#data=pd.concat([data,pd.read_csv("10RandomWalker_1Wx02l_4cb_0awc_l.csv",sep=';'),pd.read_csv("25RandomWalker_1Wx02l_4cb_0awc_l.csv",sep=';'),pd.read_csv("50RandomWalker_1Wx02l_4cb_0awc_l.csv",sep=';'),pd.read_csv("100RandomWalker_1Wx02l_4cb_0awc_l.csv",sep=';')])
#data=pd.concat([data,pd.read_csv("10RandomWalker_1Wx02l_0cb_02awc01l_l.csv",sep=';'),pd.read_csv("25RandomWalker_1Wx02l_0cb_02awc01l_l.csv",sep=';'),pd.read_csv("50RandomWalker_1Wx02l_0cb_02awc01l_l.csv",sep=';'),pd.read_csv("100RandomWalker_1Wx02l_0cb_02awc01l_l.csv",sep=';')])

data=pd.concat([pd.read_csv("10LoopErasingWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("25LoopErasingWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("50LoopErasingWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("100LoopErasingWalker_07mpl03src_0cb.csv",sep=';')])
#data=pd.concat([pd.read_csv("10LoopErasingWalker_07mpl03src_4cb.csv",sep=';'),pd.read_csv("25LoopErasingWalker_07mpl03src_4cb.csv",sep=';'),pd.read_csv("50LoopErasingWalker_07mpl03src_4cb.csv",sep=';'),pd.read_csv("100LoopErasingWalker_07mpl03src_4cb.csv",sep=';')])
#data=pd.concat([pd.read_csv("10LoopErasingWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("25LoopErasingWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("50LoopErasingWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("100LoopErasingWalker_07mpl03src_0cb.csv",sep=';')])
#data=pd.concat([pd.read_csv("10LoopErasingWalker_05mpl05src_4cb.csv",sep=';'),pd.read_csv("25LoopErasingWalker_05mpl05src_4cb.csv",sep=';'),pd.read_csv("50LoopErasingWalker_05mpl05src_4cb.csv",sep=';'),pd.read_csv("100LoopErasingWalker_05mpl05src_4cb.csv",sep=';')])

data2=pd.concat([pd.read_csv("10SelfAvoidingWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("25SelfAvoidingWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("50SelfAvoidingWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("100SelfAvoidingWalker_07mpl03src_0cb.csv",sep=';')])
#data2=pd.concat([pd.read_csv("10SelfAvoidingWalker_07mpl03src_4cb.csv",sep=';'),pd.read_csv("25LSelfAvoidingalker_07mpl03src_4cb.csv",sep=';'),pd.read_csv("50SelfAvoidingWalker_07mpl03src_4cb.csv",sep=';'),pd.read_csv("100SelfAvoidingWalker_07mpl03src_4cb.csv",sep=';')])
#data2=pd.concat([pd.read_csv("10SelfAvoidingWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("25LSelfAvoidngWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("50SelfAvoidingWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("100SelfAvoidingWalker_07mpl03src_0cb.csv",sep=';')])
#data2=pd.concat([pd.read_csv("10SelfAvoidingWalker_05mpl05src_4cb.csv",sep=';'),pd.read_csv("25SelfAvoidinglker_05mpl05src_4cb.csv",sep=';'),pd.read_csv("50SelfAvoiding05mpl05src_4cb.csv",sep=';'),pd.read_csv("10SelfAvoiding5mpl05src_4cb.csv",sep=';')])

print(data['Seed'].nunique())

data2["Algorithm"] = "Self Avoiding"
data["Algorithm"] = "Loop Erasing"

data=pd.concat([data,data2])

data["St 1"] = data["LeafCount"]
data["St 2"] = data["ConnectorCount"]
data["St 3"] = data["3CrossCount"]
data["St 4"] = data["4CrossCount"]
ptrm=pd.pivot_table(data,values=["St 1","St 2","St 3","St 4"],index=['RoomCount','Algorithm'],aggfunc='mean')

wtf = data.loc[(data["BridgeCount"]<99) & (data['RoomCount']==100)]
wtf = pd.DataFrame(wtf,columns=['Seed','BridgeCount'])
print(wtf)

axes=ptrm.T.plot(kind="pie",subplots=True,layout=(4,2), figsize=(7,13),autopct="%.2f%%",counterclock=False,labeldistance=None,title="")

for ax in axes.flat:
	if ax==axes[3,0]:
		ax.legend(loc='lower center',bbox_to_anchor=(1.515,-0.25),ncol=4)
		#ax.get_legend().remove()
	else:
		ax.get_legend().remove()
	ax.set_ylabel("")
	ax.tick_params(left=False,bottom=False)
	ax.set_title("10 - SAW" if ax==axes[0,0] else "10 - LEW" if ax==axes[0,1] else "25 - SAW" if ax==axes[1,0] else "25 - LEW" if ax==	[1,1] else "50 - SAW" if ax==axes[2,0] else "50 - LEW" if ax==axes[2,1] else "100 - SAW" if ax==axes[3,0] else "100 - LEW",pad=0)
	#ax.set(title = "10 - LEW" if ax==axes[0,0] else "10 - SAW" if ax==axes[0,1] else "25 - LEW" if ax==axes[1,0] else "25 - SAW" if ax==	[1,1] else "50 - LEW" if ax==axes[2,0] else "50 - SAW" if ax==axes[2,1] else "100 - LEW" if ax==axes[3,0] else "100 - SAW")
#pp.tight_layout()
pp.xticks(color='white')
pp.show()
pp.close()
cnt=0
axes=data.groupby('RoomCount').boxplot(column=["St 1","St 2","St 3","St 4"],sharey=False)
for ax in axes:
	if cnt==0:
		ax.set_ylim([0,10])
		cnt+=1
	elif cnt==1:
		ax.set_ylim([0,25])
		cnt+=1
	elif cnt==2:
		ax.set_ylim([0,50])
		cnt+=1
	else:
		ax.set_ylim([0,100])
		cnt+=1
pp.suptitle(None)
pp.tight_layout()
pp.show()


ptt=pd.pivot_table(data,values=["GenTime"],index=['RoomCount','Algorithm'],aggfunc='mean')

cnt=0
axes=data.groupby("RoomCount").boxplot(by='Algorithm',column=['MPthLen'],sharey=False)
for ax in axes:
	ax.yaxis.get_major_locator().set_params(integer=True)
	ax.set_ylabel("")
	ax.set_xlabel("")
	#ax.set_xticklabels(["Self Avoiding","Loop Erasing"])
	if cnt==0:
		ax.set_ylim([0,10])
		cnt+=1
	elif cnt==1:
		ax.set_ylim([0,25])
		cnt+=1
	elif cnt==2:
		ax.set_ylim([0,50])
		cnt+=1
	else:
		ax.set_ylim([0,100])
		cnt+=1
pp.suptitle(None)
pp.tight_layout()
pp.show()

axes=data.groupby("RoomCount").boxplot(by='Algorithm',column="Diameter",sharey=False)
cnt=0
for ax in axes:
	ax.yaxis.get_major_locator().set_params(integer=True)
	ax.set_ylabel("")
	ax.set_xlabel("")
	#ax.set_xticklabels(["Self Avoiding","Loop Erasing"])
	if cnt==0:
		ax.set_ylim([0,10])
		cnt+=1
	elif cnt==1:
		ax.set_ylim([0,25])
		cnt+=1
	elif cnt==2:
		ax.set_ylim([0,50])
		cnt+=1
	else:
		ax.set_ylim([0,100])
		cnt+=1
pp.suptitle(None)
pp.tight_layout()
pp.show()
cnt=0
axes=data.groupby("RoomCount").boxplot(by='Algorithm',column='MaxDistToMPth',sharey=False)
for ax in axes:
	ax.set_ylabel("")
	ax.set_xlabel("")
	ax.set_xticklabels(["Self Avoiding","Loop Erasing"])
	ax.set_ylim([0,None])
	ax.yaxis.get_major_locator().set_params(integer=True)
pp.suptitle(None)
pp.tight_layout()
pp.show()
cnt=0
axes=data.groupby("RoomCount").boxplot(by='Algorithm',column='AvgDistToMPth',sharey=False)
for ax in axes:
	ax.set_ylabel("")
	ax.set_xlabel("")
	ax.set_xticklabels(["Self Avoiding","Loop Erasing"])
	ax.set_ylim([0,None])
pp.suptitle(None)
pp.tight_layout()
pp.show()

axes=data.groupby("RoomCount").boxplot(by='Algorithm',column=['GenTime'],sharey=False)
for ax in axes:
	ax.set_ylabel("")
	ax.set_xlabel("")
	#ax.set_xticklabels(["Self Avoiding","Loop Erasing"])
	ax.set_ylim([0,None])
	ax.yaxis.get_major_locator().set_params(integer=True)
pp.suptitle(None)
pp.tight_layout()
pp.show()

axes=data.groupby("RoomCount").boxplot(by='Algorithm',column=['DistTime'],sharey=False)
for ax in axes:
	ax.set_ylabel("")
	ax.set_xlabel("")
	ax.set_xticklabels(["Self Avoiding","Loop Erasing"])
	ax.set_ylim([0,None])
pp.suptitle(None)
pp.tight_layout()
pp.show()
cnt=0
axes=data.groupby("RoomCount").boxplot(by='Algorithm',column=['APCount'],sharey=False)
for ax in axes:
	ax.set_ylabel("")
	ax.yaxis.get_major_locator().set_params(integer=True)
	ax.set_xlabel("")
	ax.set_xticklabels(["Self Avoiding","Loop Erasing"])
	if cnt==0:
		ax.set_ylim([0,10])
		cnt+=1
	elif cnt==1:
		ax.set_ylim([0,25])
		cnt+=1
	elif cnt==2:
		ax.set_ylim([0,50])
		cnt+=1
	else:
		ax.set_ylim([0,100])
		cnt+=1
pp.suptitle(None)
pp.tight_layout()
pp.show()
cnt=0
axes=data.groupby("RoomCount").boxplot(by='Algorithm',column=['BridgeCount'],sharey=False)
for ax in axes:
	ax.set_ylabel("")
	ax.yaxis.get_major_locator().set_params(integer=True)
	ax.set_xlabel("")
	ax.set_xticklabels(["Self Avoiding","Loop Erasing"])
	if cnt==0:
		ax.set_ylim([0,10])
		cnt+=1
	elif cnt==1:
		ax.set_ylim([0,25])
		cnt+=1
	elif cnt==2:
		ax.set_ylim([0,50])
		cnt+=1
	else:
		ax.set_ylim([0,100])
		cnt+=1
pp.suptitle(None)
pp.tight_layout()
pp.show()
