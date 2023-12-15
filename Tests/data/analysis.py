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

#data2=pd.concat([pd.read_csv("10RandomWalker_1W-1l_0cb_0awc_l.csv",sep=';'),pd.read_csv("25RandomWalker_1W-1l_0cb_0awc_l.csv",sep=';'),pd.read_csv("50RandomWalker_1W-1l_0cb_0awc_l.csv",sep=';'),pd.read_csv("100RandomWalker_1W-1l_0cb_0awc_l.csv",sep=';')])
#data2=pd.concat([pd.read_csv("10RandomWalker_1W-1l_4cb_0awc_l.csv",sep=';'),pd.read_csv("25RandomWalker_1W-1l_4cb_0awc_l.csv",sep=';'),pd.read_csv("50RandomWalker_1W-1l_4cb_0awc_l.csv",sep=';'),pd.read_csv("100RandomWalker_1W-1l_4cb_0awc_l.csv",sep=';')])
#data2=pd.concat([pd.read_csv("10RandomWalker_4W-1l_4cb_0awc_l.csv",sep=';'),pd.read_csv("25RandomWalker_4W-1l_4cb_0awc_l.csv",sep=';'),pd.read_csv("50RandomWalker_4W-1l_4cb_0awc_l.csv",sep=';'),pd.read_csv("100RandomWalker_4W-1l_4cb_0awc_l.csv",sep=';')])
#data2=pd.concat([pd.read_csv("10RandomWalker_4W-1l_0cb_0awc_l.csv",sep=';'),pd.read_csv("25RandomWalker_4W-1l_0cb_0awc_l.csv",sep=';'),pd.read_csv("50RandomWalker_4W-1l_0cb_0awc_l.csv",sep=';'),pd.read_csv("100RandomWalker_4W-1l_0cb_0awc_l.csv",sep=';')])
#data2=pd.concat([pd.read_csv("10RandomWalker_4Wx02l_4cb_0awc_l.csv",sep=';'),pd.read_csv("25RandomWalker_4Wx02l_4cb_0awc_l.csv",sep=';'),pd.read_csv("50RandomWalker_4Wx02l_4cb_0awc_l.csv",sep=';'),pd.read_csv("100RandomWalker_4Wx02l_4cb_0awc_l.csv",sep=';')])
#data2=pd.concat([pd.read_csv("10RandomWalker_1Wx02l_4cb_0awc_l.csv",sep=';'),pd.read_csv("25RandomWalker_1Wx02l_4cb_0awc_l.csv",sep=';'),pd.read_csv("50RandomWalker_1Wx02l_4cb_0awc_l.csv",sep=';'),pd.read_csv("100RandomWalker_1Wx02l_4cb_0awc_l.csv",sep=';')])
#data2=pd.concat([pd.read_csv("10RandomWalker_1Wx02l_0cb_02awc01l_l.csv",sep=';'),pd.read_csv("25RandomWalker_1Wx02l_0cb_02awc01l_l.csv",sep=';'),pd.read_csv("50RandomWalker_1Wx02l_0cb_02awc01l_l.csv",sep=';'),pd.read_csv("100RandomWalker_1Wx02l_0cb_02awc01l_l.csv",sep=';')])

#data=pd.concat([pd.read_csv("10LoopErasingWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("25LoopErasingWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("50LoopErasingWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("100LoopErasingWalker_07mpl03src_0cb.csv",sep=';')])
#data=pd.concat([pd.read_csv("10LoopErasingWalker_07mpl03src_4cb.csv",sep=';'),pd.read_csv("25LoopErasingWalker_07mpl03src_4cb.csv",sep=';'),pd.read_csv("50LoopErasingWalker_07mpl03src_4cb.csv",sep=';'),pd.read_csv("100LoopErasingWalker_07mpl03src_4cb.csv",sep=';')])
#data=pd.concat([pd.read_csv("10LoopErasingWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("25LoopErasingWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("50LoopErasingWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("100LoopErasingWalker_07mpl03src_0cb.csv",sep=';')])
#data=pd.concat([pd.read_csv("10LoopErasingWalker_05mpl05src_4cb.csv",sep=';'),pd.read_csv("25LoopErasingWalker_05mpl05src_4cb.csv",sep=';'),pd.read_csv("50LoopErasingWalker_05mpl05src_4cb.csv",sep=';'),pd.read_csv("100LoopErasingWalker_05mpl05src_4cb.csv",sep=';')])

#data2=pd.concat([pd.read_csv("10SelfAvoidingWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("25SelfAvoidingWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("50SelfAvoidingWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("100SelfAvoidingWalker_07mpl03src_0cb.csv",sep=';')])
#data2=pd.concat([pd.read_csv("10SelfAvoidingWalker_07mpl03src_4cb.csv",sep=';'),pd.read_csv("25LSelfAvoidingalker_07mpl03src_4cb.csv",sep=';'),pd.read_csv("50SelfAvoidingWalker_07mpl03src_4cb.csv",sep=';'),pd.read_csv("100SelfAvoidingWalker_07mpl03src_4cb.csv",sep=';')])
#data2=pd.concat([pd.read_csv("10SelfAvoidingWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("25LSelfAvoidngWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("50SelfAvoidingWalker_07mpl03src_0cb.csv",sep=';'),pd.read_csv("100SelfAvoidingWalker_07mpl03src_0cb.csv",sep=';')])
#data2=pd.concat([pd.read_csv("10SelfAvoidingWalker_05mpl05src_4cb.csv",sep=';'),pd.read_csv("25SelfAvoidinglker_05mpl05src_4cb.csv",sep=';'),pd.read_csv("50SelfAvoiding05mpl05src_4cb.csv",sep=';'),pd.read_csv("10SelfAvoiding5mpl05src_4cb.csv",sep=';')])

data=pd.concat([pd.read_csv("10PlaceAndConnect_0ap.csv",sep=';'),pd.read_csv("25PlaceAndConnect_0ap.csv",sep=';'),pd.read_csv("50PlaceAndConnect_0ap.csv",sep=';'),pd.read_csv("100PlaceAndConnect_0ap.csv",sep=';')])
data2=pd.concat([pd.read_csv("10PlaceAndConnect_02ap.csv",sep=';'),pd.read_csv("25PlaceAndConnect_02ap.csv",sep=';'),pd.read_csv("50PlaceAndConnect_02ap.csv",sep=';'),pd.read_csv("100PlaceAndConnect_02ap.csv",sep=';')])


# data=pd.concat([pd.read_csv("10RandomGrower_7non3nor.csv",sep=';'),pd.read_csv("25RandomGrower_7non3nor.csv",sep=';'),pd.read_csv("50RandomGrower_7non3nor.csv",sep=';'),pd.read_csv("100RandomGrower_7non3nor.csv",sep=';')])

# data2=pd.concat([pd.read_csv("10RandomGrower_5non5nor.csv",sep=';'),pd.read_csv("25RandomGrower_5non5nor.csv",sep=';'),pd.read_csv("50RandomGrower_5non5nor.csv",sep=';'),pd.read_csv("100RandomGrower_5non5nor.csv",sep=';')])

#data=pd.concat([pd.read_csv("10SidewinderSampler_05erp_0braid_roofsqrt_random_center.csv",sep=';'),pd.read_csv("25SidewinderSampler_05erp_0braid_roofsqrt_random_center.csv",sep=';'),pd.read_csv("50SidewinderSampler_05erp_0braid_roofsqrt_random_center.csv",sep=';'),pd.read_csv("100SidewinderSampler_05erp_0braid_roofsqrt_random_center.csv",sep=';')])
#data2=pd.concat([pd.read_csv("10SidewinderSampler_05erp_1braid_roofsqrt_random_center.csv",sep=';'),pd.read_csv("25SidewinderSampler_05erp_1braid_roofsqrt_random_center.csv",sep=';'),pd.read_csv("50SidewinderSampler_05erp_1braid_roofsqrt_random_center.csv",sep=';'),pd.read_csv("100SidewinderSampler_05erp_1braid_roofsqrt_random_center.csv",sep=';')])

#data=pd.concat([pd.read_csv("10RecursiveBacktrackerSampler_roofsqrt_random_center.csv",sep=';'),pd.read_csv("25RecursiveBacktrackerSampler_roofsqrt_random_center.csv",sep=';'),pd.read_csv("50RecursiveBacktrackerSampler_roofsqrt_random_center.csv",sep=';'),pd.read_csv("100RecursiveBacktrackerSampler_roofsqrt_random_center.csv",sep=';')],ignore_index=True)
#data2=pd.concat([pd.read_csv("10RecursiveBacktrackerSampler_braid_roofsqrt_random_center.csv",sep=';'),pd.read_csv("25RecursiveBacktrackerSampler_braid_roofsqrt_random_center.csv",sep=';'),pd.read_csv("50RecursiveBacktrackerSampler_braid_roofsqrt_random_center.csv",sep=';'),pd.read_csv("100RecursiveBacktrackerSampler_braid_roofsqrt_random_center.csv",sep=';')],ignore_index=True)

# data=pd.concat([pd.read_csv("10RandomKruskalSampler_roofsqrt_random_center.csv",sep=';'),pd.read_csv("25RandomKruskalSampler_roofsqrt_random_center.csv",sep=';'),pd.read_csv("50RandomKruskalSampler_roofsqrt_random_center.csv",sep=';'),pd.read_csv("100RandomKruskalSampler_roofsqrt_random_center.csv",sep=';')])
# data2=pd.concat([pd.read_csv("10RandomKruskalSampler_braid_roofsqrt_random_center.csv",sep=';'),pd.read_csv("25RandomKruskalSampler_braid_roofsqrt_random_center.csv",sep=';'),pd.read_csv("50RandomKruskalSampler_braid_roofsqrt_random_center.csv",sep=';'),pd.read_csv("100RandomKruskalSampler_braid_roofsqrt_random_center.csv",sep=';')])

# data=pd.concat([pd.read_csv("10RecursiveDividerSampler_1ppd_0apc_roofsqrt_random_center.csv",sep=';'),pd.read_csv("25RecursiveDividerSampler_1ppd_0apc_roofsqrt_random_center.csv",sep=';'),pd.read_csv("50RecursiveDividerSampler_1ppd_0apc_roofsqrt_random_center.csv",sep=';'),pd.read_csv("100RecursiveDividerSampler_1ppd_0apc_roofsqrt_random_center.csv",sep=';')])
# data2=pd.concat([pd.read_csv("10RecursiveDividerSampler_1ppd_0apc_b_roofsqrt_random_center.csv",sep=';'),pd.read_csv("25RecursiveDividerSampler_1ppd_0apc_b_roofsqrt_random_center.csv",sep=';'),pd.read_csv("50RecursiveDividerSampler_1ppd_0apc_b_roofsqrt_random_center.csv",sep=';'),pd.read_csv("100RecursiveDividerSampler_1ppd_0apc_b_roofsqrt_random_center.csv",sep=';')])



print(data['Seed'].nunique())

data["Algorithm"] ="Tree"#"7Non3Nor"#"Perfect" #"Without Loops"
data2["Algorithm"] ="Loops" #"5Non5Nor"#"Braided" #"Loops Allowed"

data["St 1"] = data["LeafCount"]
data["St 2"] = data["ConnectorCount"]
data["St 3"] = data["3CrossCount"]
data["St 4"] = data["4CrossCount"]
# data["St 2"] = 0

data2["St 1"] = data2["LeafCount"]
data2["St 2"] = data2["ConnectorCount"]
data2["St 3"] = data2["3CrossCount"]
data2["St 4"] = data2["4CrossCount"]

#wtf = data.loc[(data["MaxDistToMPth"]>1) & (data["RoomCount"]==25)]
#wtf = pd.DataFrame(wtf,columns=['Seed','RoomCount','MaxDistToMPth','Diameter','MPthLen','GenTime'])
#print(wtf)

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

cnt=0
axes=data2.groupby('RoomCount').boxplot(column=["St 1","St 2","St 3","St 4"],sharey=False)
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

data=pd.concat([data,data2],ignore_index=True)
ptrm=pd.pivot_table(data,values=["St 1","St 2","St 3","St 4"],index=['RoomCount','Algorithm'],aggfunc='mean')

wtf = data.loc[(data["MaxDistToMPth"]>=100) ]
wtf = pd.DataFrame(wtf,columns=['Seed','RoomCount','MaxDistToMPth','Diameter','MPthLen','GenTime'])
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
	ax.set(title = "10 - Braided" if ax==axes[0,0] else "10 - Perfect" if ax==axes[0,1] else "25 - Braided" if ax==axes[1,0] else "25 - Perfect" if ax==axes[1,1] else "50 - Braided" if ax==axes[2,0] else "50 - Perfect" if ax==axes[2,1] else "100 - Braided" if ax==axes[3,0] else "100 - Perfect")
	#ax.set_title("10 - Tree" if ax==axes[0,0] else "10 - Loops" if ax==axes[0,1] else "25 - Tree" if ax==axes[1,0] else "25 - Loops" if ax==axes[1,1] else "50 - Tree" if ax==axes[2,0] else "50 - Loops" if ax==axes[2,1] else "100 - Tree" if ax==axes[3,0] else "100 - Loops",pad=0)
	#ax.set_title("10 - 7Non3Nor" if ax==axes[0,0] else "10 - 5Non5Nor" if ax==axes[0,1] else "25 - 7Non3Nor" if ax==axes[1,0] else "25 - 5Non5Nor" if ax==axes[1,1] else "50 - 7Non3Nor" if ax==axes[2,0] else "50 - 5Non5Nor" if ax==axes[2,1] else "100 - 7Non3Nor" if ax==axes[3,0] else "100 - 5Non5Nor",pad=0)
	#ax.set(title = "10 - LEW" if ax==axes[0,0] else "10 - SAW" if ax==axes[0,1] else "25 - LEW" if ax==axes[1,0] else "25 - SAW" if ax==axes[1,1] else "50 - LEW" if ax==axes[2,0] else "50 - SAW" if ax==axes[2,1] else "100 - LEW" if ax==axes[3,0] else "100 - SAW")
#pp.tight_layout()
pp.xticks(color='white')
pp.show()
pp.close()

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
	if cnt==0:
		ax.set_ylim([0,8])#pac
		# ax.set_ylim([0,8])#rg
		# ax.set_ylim([0,8])#rks
		# ax.set_ylim([0,8])#rbs
		# ax.set_ylim([0,8])#sws
		cnt+=1
	elif cnt==1:
#		ax.set_ylim([0,15])#rbs
		# ax.set_ylim([0,15])#rds
		cnt+=1
	elif cnt==2:
#		ax.set_ylim([0,50])
		cnt+=1
	else:
#		ax.set_ylim([0,100])
		cnt+=1
	ax.yaxis.get_major_locator().set_params(integer=True)
pp.suptitle(None)
pp.tight_layout()
pp.show()
cnt=0
axes=data.groupby("RoomCount").boxplot(by='Algorithm',column='AvgDistToMPth',sharey=False)
for ax in axes:
	ax.set_ylabel("")
	ax.set_xlabel("")
	if cnt==0:
		ax.set_ylim([0,5])#pac
		# ax.set_ylim([0,5])#rg
		# ax.set_ylim([0,5])#rks
		# ax.set_ylim([0,6])#sws
		# ax.set_ylim([0,5])#rbs
		# ax.set_ylim([0,6])#rds
		cnt+=1
	elif cnt==1:
		#ax.set_ylim([0,10])#rbs
		# ax.set_ylim([0,8])#rds
		cnt+=1
	elif cnt==2:
#		ax.set_ylim([0,50])
		cnt+=1
	else:
#		ax.set_ylim([0,100])
		cnt+=1
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

axes=data.groupby("RoomCount").boxplot(by='Algorithm',column=['MazeTime'],sharey=False)
for ax in axes:
	ax.set_ylabel("")
	ax.yaxis.get_major_locator().set_params(integer=True)
	ax.set_xlabel("")
	ax.set_ylim([0,None])
pp.suptitle(None)
pp.tight_layout()
pp.show()
