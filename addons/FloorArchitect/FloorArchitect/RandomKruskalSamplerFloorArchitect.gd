## Floor architect that first generates a maze using Prim's Algorithm and then samples a subset of rooms from it multiple times
class_name RandomKruskalSamplerFloorArchitect extends BaseSamplerFloorArchitect

## Geerates the maze that will be used to sample floor layouts.
func GenerateMaze()->void:
	var cells_by_set:={}
	var set_by_cell:={}
	var pairs:=[]
	var merge:=func(a,b):
		var sb=set_by_cell[b]
		var sa=set_by_cell[a]
		if set_by_cell[a]<set_by_cell[b]:
			for i in cells_by_set[sb]:
				set_by_cell[i]=sa
			cells_by_set[sa]+=cells_by_set[sb]
			cells_by_set.erase(sb)
			PotentialCells[b].Passages[a-b]=Utils.PassageType.NORMAL
			PotentialCells[a].Passages[b-a]=Utils.PassageType.NORMAL
		elif set_by_cell[a]>set_by_cell[b]:
			for i in cells_by_set[sb]:
				set_by_cell[i]=sa
			cells_by_set[sa]+=cells_by_set[sb]
			cells_by_set.erase(sb)
			PotentialCells[b].Passages[a-b]=Utils.PassageType.NORMAL
			PotentialCells[a].Passages[b-a]=Utils.PassageType.NORMAL
	for y in range(MazeHeight):
		for x in range(MazeWidth):
			var nc:=Utils.CreateTemplateCell(Vector2i(x,y),true)
			PotentialCells[nc.MapPos]=nc
			cells_by_set[y*MazeWidth+x]=[nc.MapPos]
			set_by_cell[nc.MapPos]=y*MazeWidth+x
			if x+1<MazeWidth:
				pairs.append([nc.MapPos,Vector2i(x+1,y)])
			if y+1<MazeHeight:
				pairs.append([nc.MapPos,Vector2i(x,y+1)])
	while cells_by_set.size()>1:
		var p:=pairs.pop_at(rand.randi_range(0,pairs.size()-1))
		merge.call(p[0],p[1])

func setup(rseed:int=1337)->void:
	super(rseed)
	GenerateMaze()
	BraidMaze()
	pass
