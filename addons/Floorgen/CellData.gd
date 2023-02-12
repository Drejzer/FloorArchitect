extends RefCounted
## Data about a single cell of the floor
##
## Contains data such as th etypes of connections between cells, the position of the cell
## as well as the typ of the room th ecell belongs to

class_name CellData

## Determines which sides of the cell have which type of wall (or no wall at all) used as a collection of flags
var Passages={Defs.UP:Defs.PassageType.UNDEFINED,
			Defs.RIGHT:Defs.PassageType.UNDEFINED,
			Defs.DOWN:Defs.PassageType.UNDEFINED,
			Defs.LEFT:Defs.PassageType.UNDEFINED,}
## Type of predefined room (those can consist of multiple cells) 
var RoomType:int=0

## Map coordinates of the cell
var MapPos:Vector2i=Vector2i(0,0)

