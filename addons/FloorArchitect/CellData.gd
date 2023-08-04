## Data about a single cell of the floor
##
## Contains data such as the types of connections between cells, the position of the cell
## as well as the type of the room the cell belongs to
class_name CellData extends RefCounted

## Determines which sides of the cell have which type of wall (or no wall at all).[br]
## Holds pairs DIRECTION:[enum Utils.PassageType] (alternatively can be used as outgoing edge weigths
var passages={}
## Type of cell (currently a placeholder)
var cell_type:int=0

## Map coordinates of the cell
var map_pos:Vector2i=Vector2i(0,0)

func duplicate(deep:bool=true)->CellData:
	var nc:=CellData.new()
	nc.map_pos=map_pos
	nc.passages=passages.duplicate(deep)
	nc.cell_type=cell_type
	return nc
