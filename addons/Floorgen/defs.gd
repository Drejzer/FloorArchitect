enum PassFlag {None=0,HiddenNorth=1,NormalNorth=2,FullNorth=3, \
				HiddenEast=4,NormalEast=8,FullEast=12, \
				HiddenSouth=16,NormalSouth=32,FullSouth=48,\
				HiddenWest=64,NormalWest=128,FullWest=192}
class CellData:
	var pos_x:int
	var pos_y:int
	var ReqPassFlag:int
	var PassFlag:int
	
