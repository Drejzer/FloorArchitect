## Floor architect that first generates a maze using Sidewinder Algorithm and then samples a subset of rooms from it multiple times
##
class_name SidewinderSamplerFloorArchitect extends BaseSamplerFloorArchitect

## The probability of ending the "run" of cells in the algorithm
@export_range(0.0,1.0) var end_run_probablility:float=0.5

## Geerates the maze that will be used to sample floor layouts.
func _generate_maze()->void:
	var _run:=[]
	for y in range(maze_height):
		for x in range(maze_width):
			var nc:=Utils.create_template_cell()
			nc.map_pos=Vector2i(x,y)
			if _run.is_empty():
				nc.passages[Utils.WEST]=Utils.PassageType.NONE
			else:
				nc.passages[Utils.WEST]=Utils.PassageType.NORMAL
			if potential_cells.has(nc.map_pos+Utils.NORTH):
				nc.passages[Utils.NORTH]=potential_cells[nc.map_pos+Utils.NORTH].passages[Utils.SOUTH]
			else:
				nc.passages[Utils.NORTH]=Utils.PassageType.NONE
			var toend:=rand.randf()<end_run_probablility
			_run.push_back(nc.map_pos)
			if (toend || x==maze_width-1) && y!=maze_height-1:
				nc.passages[Utils.EAST]=Utils.PassageType.NONE
				potential_cells[nc.map_pos]=nc
				var r=rand.randi_range(0,_run.size()-1)
				for i in _run:
					potential_cells[i].passages[Utils.SOUTH]=(Utils.PassageType.NORMAL if (i==_run[r] && y!=maze_height-1) 
							else Utils.PassageType.NONE)
				_run.clear()
			else:
				nc.passages[Utils.EAST]=Utils.PassageType.NORMAL if x!=maze_width-1 else Utils.PassageType.NONE
				potential_cells[nc.map_pos]=nc
		
		if !_run.is_empty():
			var r=rand.randi_range(0,_run.size()-1)
			for i in _run:
				potential_cells[i].passages[Utils.SOUTH]=(Utils.PassageType.NORMAL if (i==_run[r] && y!=maze_height-1) 
						else Utils.PassageType.NONE)
			_run.clear()
