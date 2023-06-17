## Data about a single cell of the floor
##
## Contains data such as the types of connections between cells, the position of the cell
## as well as the type of the room the cell belongs to
class_name CellData extends RefCounted

## Determines which sides of the cell have which type of wall (or no wall at all).[br]
## Holds pairs DIRECTION:[enum Utils.PassageType]
var Passages={}
## PLACEHOLDER Type of predefined room (those can consist of multiple cells) 
var RoomType:int=0

## Map coordinates of the cell
var MapPos:Vector2i=Vector2i(0,0)
