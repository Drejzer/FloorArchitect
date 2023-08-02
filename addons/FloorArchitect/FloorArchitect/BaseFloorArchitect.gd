## Base Node for generating Dungeon floor layouts. Holds declarations of common variables and methods
##
## This class acts as an abstract class, it doesn't provide any method definitions, for particular algorithm implementations look at classes derived from it.
class_name BaseFloorArchitect extends Node

var rand:=RandomNumberGenerator.new()

signal floor_planned
@export var passage_weigths:={"NONE":3,
			"NORMAL":5,
			"HIDDEN":0,
			"LOCKED":0,
			"CONNECTION":0,
			}
			

## Dictionary of cells (using [CellData]) keyed by position (using [Vector2i])
@export var cells: Dictionary={}
## Dictionary of cells that can be added to the map
var potential_cells:Dictionary={}

## Function that generates the floor layout, should be overloaded for each implementation.[br]
## Base implementation should be called at the end.
func _plan_floor()->void:
	clean_invalid_passages()
	floor_planned.emit()


## Adds a new [class CellData] in the specified position with the specified passages.
##
## Creates and adds a new [class CellData] to the [member cells], will overwrite PassageType.NONE and PassageType.UNDEFINED of existing cells.
func add_new_cell(pos:Vector2i, psgs:Dictionary,add_potential:bool=true):
	var nc:=Utils.create_template_cell(pos)
	nc.passages=psgs
	if !cells.has(nc.map_pos+Utils.NORTH):
		if (add_potential
				and psgs[Utils.NORTH] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]):
			var pc:CellData=(potential_cells[nc.map_pos+Utils.NORTH] if potential_cells.has(nc.map_pos+Utils.NORTH) 
					else Utils.create_template_cell(nc.map_pos+Utils.NORTH))
			pc.passages[Utils.SOUTH]=nc.passages[Utils.NORTH]
			potential_cells[pc.map_pos]=pc
	else:
		if cells[nc.map_pos+Utils.NORTH].passages[Utils.SOUTH] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]:
			nc.passages[Utils.NORTH]=cells[nc.map_pos+Utils.NORTH].passages[Utils.SOUTH]
		else:
			cells[nc.map_pos+Utils.NORTH].passages[Utils.SOUTH]=nc.passages[Utils.NORTH]
		
	if !cells.has(nc.map_pos+Utils.WEST):
		if (add_potential 
				and psgs[Utils.WEST] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]):
			var pc:CellData=(potential_cells[nc.map_pos+Utils.WEST] if potential_cells.has(nc.map_pos+Utils.WEST)
					else Utils.create_template_cell(nc.map_pos+Utils.WEST))
			pc.passages[Utils.EAST]=nc.passages[Utils.WEST]
			potential_cells[pc.map_pos]=pc
	else:
		if cells[nc.map_pos+Utils.WEST].passages[Utils.EAST] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]:
			nc.passages[Utils.WEST]=cells[nc.map_pos+Utils.WEST].passages[Utils.EAST]
		else:
			cells[nc.map_pos+Utils.WEST].passages[Utils.EAST]=nc.passages[Utils.WEST]
		
	if !cells.has(nc.map_pos+Utils.SOUTH):
		if (add_potential
				and psgs[Utils.SOUTH] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]):
			var pc:CellData=(potential_cells[nc.map_pos+Utils.SOUTH] if potential_cells.has(nc.map_pos+Utils.SOUTH) 
					else Utils.create_template_cell(nc.map_pos+Utils.SOUTH))
			pc.passages[Utils.NORTH]=nc.passages[Utils.SOUTH]
			potential_cells[pc.map_pos]=pc
	else:
		if cells[nc.map_pos+Utils.SOUTH].passages[Utils.NORTH] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]:
			nc.passages[Utils.SOUTH]=cells[nc.map_pos+Utils.SOUTH].passages[Utils.NORTH]
		else:
			cells[nc.map_pos+Utils.SOUTH].passages[Utils.NORTH]=nc.passages[Utils.SOUTH]
		
	if !cells.has(nc.map_pos+Utils.EAST):
		if (add_potential 
				and psgs[Utils.EAST] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]):
			var pc:CellData=(
					potential_cells[nc.map_pos+Utils.EAST] if potential_cells.has(nc.map_pos+Utils.EAST) 
					else Utils.CreateTemplateCell(nc.map_pos+Utils.EAST)
					)
			pc.passages[Utils.WEST]=nc.passages[Utils.EAST]
			potential_cells[pc.map_pos]=pc
	else:
		if cells[nc.map_pos+Utils.EAST].passages[Utils.WEST] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]:
			nc.passages[Utils.EAST]=cells[nc.map_pos+Utils.EAST].passages[Utils.WEST]
		else:
			cells[nc.map_pos+Utils.EAST].passages[Utils.WEST]=nc.passages[Utils.EAST]
	cells[nc.map_pos]=nc


## Eliminates "open" passages to nonexisting cells
func clean_invalid_passages():
	for c in cells.values():
		for p in c.passages.keys():
			if c.passages[p] not in [Utils.PassageType.NONE]:
				if !cells.has(c.map_pos+p):
					c.passages[p]=Utils.PassageType.NONE
			if c.passages[p] == Utils.PassageType.UNDEFINED:
				c.passages[p]=Utils.PassageType.NONE

func _ready() -> void:
	rand=RandomNumberGenerator.new()
	pass
	
## Sets up the class. Allows for setting the seed of [member rand]
func setup(rseed:int=1337)->void:
	rand.seed=rseed
	potential_cells.clear()
	cells.clear()
	pass


## Generates passages for a cell by replacing the UNDEFINED values by value randomly selected based on [member Weigths]
func define_passages(weigths:Dictionary,cps:Dictionary={})->Dictionary:
	var pt=[]
	for k in weigths.keys():
		for i in range(weigths[k]):
			pt.push_back(Utils.PassageType.get(k))
	var psg
	if !cps.is_empty():
		psg=cps
	else:
		psg={Utils.NORTH:Utils.PassageType.UNDEFINED,
				Utils.WEST:Utils.PassageType.UNDEFINED,
				Utils.SOUTH:Utils.PassageType.UNDEFINED,
				Utils.EAST:Utils.PassageType.UNDEFINED,
				}
	for k in psg.keys():
		if psg[k] == Utils.PassageType.UNDEFINED:
			psg[k]=pt[rand.randi_range(0,pt.size()-1)]
	return psg
