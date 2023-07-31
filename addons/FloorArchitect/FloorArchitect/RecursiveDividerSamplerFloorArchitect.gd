## Floor architect that first generates a maze using Sidewinder Algorithm and then samples a subset of rooms from it multiple times
##

class_name RecursiveDividerSamplerFloorArchitect extends BaseSamplerFloorArchitect

## How many passages between divided parts are the upper limit
@export var MinPassagesPerDivide:int=1
@export_range(0.0,1.0) var AdditionalPassageChance:float=0.0

## Geerates the maze that will be used to sample floor layouts.
func GenerateMaze()->void:
	for y in range(MazeHeight):
		for x in range(MazeWidth):
			var nc:=Utils.CreateTemplateCell(Vector2i(x,y),true)
			if x>0:
				nc.Passages[Utils.LEFT]=Utils.PassageType.NORMAL
			if x<MazeWidth-1:
				nc.Passages[Utils.RIGHT]=Utils.PassageType.NORMAL
			if y>0:
				nc.Passages[Utils.UP]=Utils.PassageType.NORMAL
			if y<MazeHeight-1:
				nc.Passages[Utils.DOWN]=Utils.PassageType.NORMAL
			PotentialCells[nc.MapPos]=nc
	_Divide(0,MazeWidth-1,0,MazeHeight-1,1)

func _Divide(xb:int,xe:int,yb:int,ye:int, minimum_width:int=1):
	var dv=ye-yb
	var dh=xe-xb
	if dv>minimum_width||dh>minimum_width:
		var ops=MinPassagesPerDivide+floori(AdditionalPassageChance)
		if AdditionalPassageChance+float(MinPassagesPerDivide)-float(ops)>=rand.randi():
			ops+=1
		if dh>dv:
			_DivideVertically(xb,xe,yb,ye,ops,minimum_width)
		else:
			_DivideHorizontally(xb,xe,yb,ye,ops,minimum_width)

func _DivideHorizontally(xb:int,xe:int,yb:int,ye:int,openings:int=1, minimum_width:int=1):
	var ops=[]
	for i in range(openings):
		ops.push_back(rand.randi_range(xb,xe))
	var level = rand.randi_range(yb,ye-1)
	for i in range(xb,xe+1):
		PotentialCells[Vector2i(i,level)].Passages[Utils.DOWN]=(Utils.PassageType.NORMAL if (i in ops) else Utils.PassageType.NONE)
		PotentialCells[Vector2i(i,level+1)].Passages[Utils.UP]=PotentialCells[Vector2i(i,level)].Passages[Utils.DOWN]
	_Divide(xb,xe,yb,level,minimum_width)
	_Divide(xb,xe,level+1,ye,minimum_width)

func _DivideVertically(xb:int,xe:int,yb:int,ye:int,openings:int=1, minimum_width:int=1):
	var ops=[]
	for i in range(openings):
		ops.push_back(rand.randi_range(yb,ye))
	var level = rand.randi_range(xb,xe-1)
	for i in range(yb,ye+1):
		PotentialCells[Vector2i(level,i)].Passages[Utils.RIGHT]=(Utils.PassageType.NORMAL if (i in ops) else Utils.PassageType.NONE)
		PotentialCells[Vector2i(level+1,i)].Passages[Utils.LEFT]=PotentialCells[Vector2i(level,i)].Passages[Utils.RIGHT]
	_Divide(xb,level,yb,ye,minimum_width)
	_Divide(level+1,xe,yb,ye,minimum_width)
