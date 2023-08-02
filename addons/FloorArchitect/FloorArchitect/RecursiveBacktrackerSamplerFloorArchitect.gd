## Floor architect that first generates a maze using Prim's Algorithm and then samples a subset of rooms from it multiple times
class_name RecursiveBacktrackerSamplerFloorArchitect extends BaseSamplerFloorArchitect

## Geerates the maze that will be used to sample floor layouts.
func _generate_maze()->void:
	var _stack:=[]
	const DIRS:=[Utils.NORTH,Utils.EAST,Utils.SOUTH,Utils.WEST]
	_stack.push_front([Vector2i.ZERO,DIRS.duplicate(true)])
	potential_cells[Vector2i.ZERO]=Utils.create_template_cell(Vector2i.ZERO,true)
	while !_stack.is_empty():
		if _stack.front()[1].is_empty():
			_stack.pop_front()
		else:
			var current=_stack.front()[0]+_stack.front()[1].pop_at(rand.randi_range(0,_stack.front()[1].size()-1))
			if !(potential_cells.has(current) 
					or current.x<0 
					or current.x>=maze_width 
					or current.y<0 
					or current.y>=maze_height):
				potential_cells[_stack.front()[0]].passages[current-_stack.front()[0]]=Utils.PassageType.NORMAL
				var nc:=Utils.create_template_cell(current,true)
				nc.passages[_stack.front()[0]-current]=Utils.PassageType.NORMAL
				potential_cells[current]=nc
				_stack.push_front([current,DIRS.duplicate(true)])

