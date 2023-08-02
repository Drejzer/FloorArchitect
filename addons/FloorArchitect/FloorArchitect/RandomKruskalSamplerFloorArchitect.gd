## Floor architect that first generates a maze using Prim's Algorithm and then samples a subset of rooms from it multiple times
class_name RandomKruskalSamplerFloorArchitect extends BaseSamplerFloorArchitect

## Geerates the maze that will be used to sample floor layouts.
func _generate_maze()->void:
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
			potential_cells[b].passages[a-b]=Utils.PassageType.NORMAL
			potential_cells[a].passages[b-a]=Utils.PassageType.NORMAL
		elif set_by_cell[a]>set_by_cell[b]:
			for i in cells_by_set[sb]:
				set_by_cell[i]=sa
			cells_by_set[sa]+=cells_by_set[sb]
			cells_by_set.erase(sb)
			potential_cells[b].passages[a-b]=Utils.PassageType.NORMAL
			potential_cells[a].passages[b-a]=Utils.PassageType.NORMAL
	for y in range(maze_height):
		for x in range(maze_width):
			var nc:=Utils.create_template_cell(Vector2i(x,y),true)
			potential_cells[nc.map_pos]=nc
			cells_by_set[y*maze_width+x]=[nc.map_pos]
			set_by_cell[nc.map_pos]=y*maze_width+x
			if x+1<maze_width:
				pairs.append([nc.map_pos,Vector2i(x+1,y)])
			if y+1<maze_height:
				pairs.append([nc.map_pos,Vector2i(x,y+1)])
	while cells_by_set.size()>1:
		var p:=pairs.pop_at(rand.randi_range(0,pairs.size()-1))
		merge.call(p[0],p[1])


func setup(rseed:int=1337)->void:
	super(rseed)
	_generate_maze()
	braid_maze()
	pass
