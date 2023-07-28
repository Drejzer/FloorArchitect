## Floor architect that first generates a maze using Sidewinder Algorithm and then samples a subset of rooms from it multiple times
##

class_name RecursiveDividerSamplerFloorArchitect extends BaseSamplerFloorArchitect

## How many passages between divided parts are the upper limit
@export var MaxPassagesPerDivide:int=1
@export_range(0.0,1.0) var AdditionalPassageChance:float=0.5

## Geerates the maze that will be used to sample floor layouts.
func GenerateMaze()->void:
	var run:=[]
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
	

func _DivideHorizontally(first:int,last:int,openings:int=1, minimum_width:int=1):
	if last-first<=minimum_width:
		pass
	else:
		var ops=[]
		for i in range(openings):
			ops.push_back(rand.randi_range(first,last))

func _DivideVertically(first:int,last:int,openings:int=1):
	pass
