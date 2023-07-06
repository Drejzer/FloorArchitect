## Floor architect that first generates a maze using Sidewinder Algorithm and then samples a subset of rooms from it multiple times
##

class_name SidewinderFloorArchitect extends BaseSamplerFloorArchitect

## Geerates the maze that will be used to sample floor layouts.
func GenerateMaze()->void:
	var run:=[]
	for y in range(MazeHeight):
		for x in range(MazeWidth):
			var nc:=Utils.CreateTemplateCell()
			nc.MapPos=Vector2i(x,y)
			if run.is_empty():
				nc.Passages[Utils.LEFT]=Utils.PassageType.NONE
			else:
				nc.Passages[Utils.LEFT]=Utils.PassageType.NORMAL
			if PotentialCells.has(nc.MapPos+Utils.UP):
				nc.Passages[Utils.UP]=PotentialCells[nc.MapPos+Utils.UP].Passages[Utils.DOWN]
			else:
				nc.Passages[Utils.UP]=Utils.PassageType.NONE
			var toend:=rand.randf()<EndRunProbablility
			run.push_back(nc.MapPos)
			if toend && y!=MazeHeight-1:
				nc.Passages[Utils.RIGHT]=Utils.PassageType.NONE
				PotentialCells[nc.MapPos]=nc
				var r=rand.randi_range(0,run.size()-1)
				for i in run:
					PotentialCells[i].Passages[Utils.DOWN]=Utils.PassageType.NORMAL if i==run[r] else Utils.PassageType.NONE 
				run.clear()
			else:
				nc.Passages[Utils.RIGHT]=Utils.PassageType.NORMAL
				PotentialCells[nc.MapPos]=nc
		
		if !run.is_empty():
			var r=rand.randi_range(0,run.size()-1)
			for i in run:
				PotentialCells[i].Passages[Utils.DOWN]=Utils.PassageType.NORMAL if i==run[r] else Utils.PassageType.NONE 
			run.clear()
