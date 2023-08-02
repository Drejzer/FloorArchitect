## Floor architect that first generates a maze using Sidewinder Algorithm and then samples a subset of rooms from it multiple times
##

class_name RecursiveDividerSamplerFloorArchitect extends BaseSamplerFloorArchitect

## How many passages between divided parts are the upper limit
@export var min_passages_per_divide:int=1
@export_range(0.0,1.0) var additional_passage_chance:float=0.0

## Geerates the maze that will be used to sample floor layouts.
func _generate_maze()->void:
	for y in range(maze_height):
		for x in range(maze_width):
			var nc:=Utils.create_template_cell(Vector2i(x,y),true)
			if x>0:
				nc.passages[Utils.WEST]=Utils.PassageType.NORMAL
			if x<maze_width-1:
				nc.passages[Utils.EAST]=Utils.PassageType.NORMAL
			if y>0:
				nc.passages[Utils.NORTH]=Utils.PassageType.NORMAL
			if y<maze_height-1:
				nc.passages[Utils.SOUTH]=Utils.PassageType.NORMAL
			potential_cells[nc.map_pos]=nc
	_divide(0,maze_width-1,0,maze_height-1,1)

func _divide(xb:int,xe:int,yb:int,ye:int, minimum_width:int=1):
	var dv=ye-yb
	var dh=xe-xb
	if dv>minimum_width or dh>minimum_width:
		var ops=min_passages_per_divide+floori(additional_passage_chance)
		if additional_passage_chance+float(min_passages_per_divide)-float(ops)>=rand.randi():
			ops+=1
		if dh>dv:
			_divide_vertically(xb,xe,yb,ye,ops,minimum_width)
		else:
			_divide_horizontally(xb,xe,yb,ye,ops,minimum_width)

func _divide_horizontally(xb:int,xe:int,yb:int,ye:int,openings:int=1, minimum_width:int=1):
	var ops=[]
	for i in range(openings):
		ops.push_back(rand.randi_range(xb,xe))
	var level = rand.randi_range(yb,ye-1)
	for i in range(xb,xe+1):
		potential_cells[Vector2i(i,level)].passages[Utils.SOUTH]=(Utils.PassageType.NORMAL if (i in ops) 
				else Utils.PassageType.NONE)
		potential_cells[Vector2i(i,level+1)].passages[Utils.NORTH]=potential_cells[Vector2i(i,level)].passages[Utils.SOUTH]
	_divide(xb,xe,yb,level,minimum_width)
	_divide(xb,xe,level+1,ye,minimum_width)

func _divide_vertically(xb:int,xe:int,yb:int,ye:int,openings:int=1, minimum_width:int=1):
	var ops=[]
	for i in range(openings):
		ops.push_back(rand.randi_range(yb,ye))
	var level = rand.randi_range(xb,xe-1)
	for i in range(yb,ye+1):
		potential_cells[Vector2i(level,i)].passages[Utils.EAST]=(Utils.PassageType.NORMAL if (i in ops) 
				else Utils.PassageType.NONE)
		potential_cells[Vector2i(level+1,i)].passages[Utils.WEST]=potential_cells[Vector2i(level,i)].passages[Utils.EAST]
	_divide(xb,level,yb,ye,minimum_width)
	_divide(level+1,xe,yb,ye,minimum_width)
