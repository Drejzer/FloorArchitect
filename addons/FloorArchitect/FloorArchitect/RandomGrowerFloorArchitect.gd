## Node for generating Dungeon floor layouts
##
## This node generates the general layout of rooms. The algorithm is based on the one used in Binding of Isaac.

class_name RandomGrowerFloorArchitect extends BaseFloorArchitect

@export var minimum_room_count:int=9
@export var maximum_room_count:int=17

## Function that generates the floor layout
func _plan_floor()->void:
	cells.clear()
	potential_cells.clear()
	var init = Utils.create_template_cell()
	potential_cells[init.map_pos]=init
	while cells.size() < maximum_room_count and !potential_cells.is_empty():
		if !potential_cells.is_empty():
			var nextc=get_next_cell()
			realise_cell(nextc)
		while potential_cells.is_empty() and cells.size()<minimum_room_count:
			enforce_minimum()
	super()

## Picks next cell to be added from [member potential_cells]
func get_next_cell()->CellData:
	var k=potential_cells.keys()
	var i=rand.randi_range(0,k.size()-1)
	return potential_cells[k[i]]

## Moves a cell from [member potential_cells] to [member cells]
##
## Removes the selected cell from [member potential_cells], randomises it's passages while respecting existing cells, and adds it to [member cells]. 
## Additionally adds to [member potential_cells] according to the now defined passages
func realise_cell(nc:CellData):
	var psgs=define_passages(passage_weigths,nc.passages)
	nc.passages=psgs
	if !cells.has(nc.map_pos+Utils.NORTH):
		if (nc.passages[Utils.NORTH] not in [Utils.PassageType.NONE]
				and cells.size()+potential_cells.size()<=maximum_room_count):
			var pc:CellData=(potential_cells[nc.map_pos+Utils.NORTH] if potential_cells.has(nc.map_pos+Utils.NORTH) 
					else Utils.create_template_cell(nc.map_pos+Utils.NORTH))
			pc.passages[Utils.SOUTH]=nc.passages[Utils.NORTH]
			potential_cells[pc.map_pos]=pc
	else:
		nc.passages[Utils.NORTH]=cells[nc.map_pos+Utils.NORTH].passages[Utils.SOUTH]
		
	if !cells.has(nc.map_pos+Utils.WEST):
		if (nc.passages[Utils.WEST] not in [Utils.PassageType.NONE]
				and cells.size()+potential_cells.size()<=maximum_room_count):
			var pc:CellData=(potential_cells[nc.map_pos+Utils.WEST] if potential_cells.has(nc.map_pos+Utils.WEST) 
					else Utils.create_template_cell(nc.map_pos+Utils.WEST))
			pc.passages[Utils.EAST]=nc.passages[Utils.WEST]
			potential_cells[pc.map_pos]=pc
	else:
		nc.passages[Utils.WEST]=cells[nc.map_pos+Utils.WEST].passages[Utils.EAST]
		
	if !cells.has(nc.map_pos+Utils.SOUTH):
		if (nc.passages[Utils.SOUTH] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]
				and cells.size()+potential_cells.size()<=maximum_room_count):
			var pc:CellData=(potential_cells[nc.map_pos+Utils.SOUTH] if potential_cells.has(nc.map_pos+Utils.SOUTH) 
					else Utils.create_template_cell(nc.map_pos+Utils.SOUTH))
			pc.passages[Utils.NORTH]=nc.passages[Utils.SOUTH]
			potential_cells[pc.map_pos]=pc
	else:
		nc.passages[Utils.SOUTH]=cells[nc.map_pos+Utils.SOUTH].passages[Utils.NORTH]
		
	if !cells.has(nc.map_pos+Utils.EAST):
		if (nc.passages[Utils.EAST] not in [Utils.PassageType.NONE]
				and cells.size()+potential_cells.size()<=maximum_room_count):
			var pc:CellData=(potential_cells[nc.map_pos+Utils.EAST] if potential_cells.has(nc.map_pos+Utils.EAST) 
					else Utils.create_template_cell(nc.map_pos+Utils.EAST))
			pc.passages[Utils.WEST]=nc.passages[Utils.EAST]
			potential_cells[pc.map_pos]=pc
	else:
		nc.passages[Utils.EAST]=cells[nc.map_pos+Utils.EAST].passages[Utils.WEST]
			
	cells[nc.map_pos]=nc
	potential_cells.erase(nc.map_pos)

## Forcefully adds additional room, if the minimum has not been reached
func enforce_minimum()->void:
	var tmp2:=cells.keys()
	var tmp:=[]
	while tmp2.size():
		tmp.push_back(tmp2.pop_at(rand.randi()%tmp2.size()))
	var psg=define_passages(passage_weigths)
	for i in tmp:
		if cells[i].passages[Utils.NORTH] == Utils.PassageType.NONE and !cells.has(i+Utils.NORTH):
			psg[Utils.SOUTH]=Utils.PassageType.NORMAL
			add_new_cell(i+Utils.NORTH,psg)
			return
		elif cells[i].passages[Utils.WEST] == Utils.PassageType.NONE and !cells.has(i+Utils.WEST):
			psg[Utils.EAST]=Utils.PassageType.NORMAL
			add_new_cell(i+Utils.WEST,psg)
			return
		elif cells[i].passages[Utils.SOUTH] == Utils.PassageType.NONE and !cells.has(i+Utils.SOUTH):
			psg[Utils.NORTH]=Utils.PassageType.NORMAL
			add_new_cell(i+Utils.SOUTH,psg)
			return 
		elif cells[i].passages[Utils.EAST] == Utils.PassageType.NONE and !cells.has(i+Utils.EAST):
			psg[Utils.WEST]=Utils.PassageType.NORMAL
			add_new_cell(i+Utils.EAST,psg)
			return
	

## Sets up the class. Allows for setting the seed of [member rand]
func setup(rseed:int=1337)->void:
	super(rseed)
	pass

