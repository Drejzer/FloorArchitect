extends Reference

class_name CellData

## Determines which sides of the cell have which type of wall (or no wall at all) used as a collection of flags
var PassFlags:int
## Determines which sides of the cell have which type of passage used during creaton to ensure the type of passage between a potential cell and existing cells surrounding it is the same
var RequiredPassFlags:int
## Simmilar to ReqPassFlags, ensures the type of passage doesn't change (since the passage is, by default, encoded with two bits), as well as that passages don't open up where there should be a wall betwween cells
var AllowedPassFlags:int=((1<<10)-1)
## Type of predefined room (those can consist of multiple cells) 
var RoomType:int=0
## X coordinate of the cell
var MapPos_x:int=0
## Y coordinate of the cell
var MapPos_y:int=0


