extends Node

class_name BaseFloorArchitect

var rand:=RandomNumberGenerator.new()

const UP := Vector2i(0,-1)
const RIGHT := Vector2i(1,0)
const DOWN := Vector2i(0,1)
const LEFT := Vector2i(-1,0)

signal FloorPlanned

@export var minimum_room_count:int=6
@export var maximum_room_count:int=7
#export var multicell_rooms_allowed:bool=false

## Dictionary of cells (using @ref CellData class) keyed by position (as 2-element array of ints)
@export var Cells: Dictionary={}

## Dictionary of cells, from which one of the cells can be added to the map
var PotentialCells:={}

## Function that generates the floor layout
func plan_floor()->void:
	var fc:=rand.randi_range(0,4)
	match(fc):
		0:
			AddNewCell(0,0,(2|8|32|128))
		1:
			AddNewCell(0,0,(3|8|32|128))
		2:
			AddNewCell(0,0,(2|12|32|128))
		3:
			AddNewCell(0,0,(2|8|48|128))
		4:
			AddNewCell(0,0,(2|8|32|192))
		_:
			pass
		
	while Cells.size() < minimum_room_count && !PotentialCells.is_empty():
		var pckeylist= PotentialCells.keys()
		var i = rand.randi_range(0,pckeylist.size()-1)
		var nextc:=(PotentialCells[pckeylist[i]] as CellData)
		var rpf:=0
		if rand.randi_range(1,5)==1:
			rpf|=2
		if rand.randi_range(1,5)==1:
			rpf|=8
		if rand.randi_range(1,5)==1:
			rpf|=32
		if rand.randi_range(1,5)==1:
			rpf|=128
			AddCell(nextc,rpf)
		if PotentialCells.is_empty() && Cells.size()<minimum_room_count:
			enforce_minimum()
	cleanup()
	FloorPlanned.emit()
	pass

## Eliminates "open" passages to nonexisting cells
func cleanup():
	for c in Cells.values():
		if c.PassFlags&3 && !Cells.has(c.MapPos+UP):
			c.PassFlags&=0b11111100
		if c.PassFlags&12 && !Cells.has(c.MapPos+RIGHT):
			c.PassFlags&=0b11110011
		if c.PassFlags&48 && !Cells.has(c.MapPos+DOWN):
			c.PassFlags&=0b11001111
		if c.PassFlags&192 && !Cells.has(c.MapPos+LEFT):
			c.PassFlags&=0b00111111

## Forcefully adds additional room, if the minimum has not been reached
func enforce_minimum()->void:
	var tmp :=Cells.keys()
	tmp.shuffle()
	var rpf:=0
	if rand.randi_range(1,2)==1:
		rpf|=2
	if rand.randi_range(1,2)==1:
		rpf|=8
	if rand.randi_range(1,2)==1:
		rpf|=32
	if rand.randi_range(1,2)==1:
		rpf|=128
	for i in tmp:
		if Cells[i].PassFlags&3==0:
			Cells[i].PassFlags|=2
			AddNewCell(i[0],i[1]-1,rpf|32)
			return
		elif Cells[i].PassFlags&12==0:
			Cells[i].PassFlags|=8
			AddNewCell(i[0]+1,i[1],rpf|128)
			return
		elif Cells[i].PassFlags&48==0:
			Cells[i].PassFlags|=32
			AddNewCell(i[0],i[1]+1,rpf|2)
			return
		elif Cells[i].PassFlags&192==0:
			Cells[i].PassFlags|=128
			AddNewCell(i[0]-1,i[1],rpf|8)
			return
	

## Adds a new cell in the specified position with the specified flags. Adds potential cells based checked the flags of the added cell
func AddNewCell(posx:int, posy:int, pflags:int):
	var nc:=CellData.new()
	nc.MapPos=Vector2i(posx,posy)
	nc.PassFlags=pflags
	Cells[[posx,posy]]=nc
	if nc.PassFlags&3:
		if(!Cells.has(nc.MapPos+UP)):
			var pc=PotentialCells[nc.MapPos+UP] if PotentialCells.has(nc.MapPos+UP) else make_template_cell()
			pc.RequiredPassFlags|=((nc.PassFlags&3)<<4)
			pc.MapPos=Vector2i(nc.MapPos+UP)
			PotentialCells[pc.MapPos]=pc
		else:
			nc.PassFlags&=0b11111100
			nc.PassFlags|=(Cells[nc.MapPos+UP].PassFlags&48)>>4
	if nc.PassFlags&12:
		if !Cells.has(nc.MapPos+RIGHT):
			var pc=PotentialCells[nc.MapPos+RIGHT] if PotentialCells.has(nc.MapPos+RIGHT) else make_template_cell()
			pc.RequiredPassFlags|=((nc.PassFlags&12)<<4)
			pc.MapPos=nc.MapPos+RIGHT
			PotentialCells[pc.MapPos]=pc
		else:
			nc.PassFlags&=0b11110011
			nc.PassFlags|=(Cells[[posx+1,posy]].PassFlags&192)>>4
	if nc.PassFlags&48:
		if !Cells.has(nc.MapPos+Vector2i(0,1)):
			var pc=PotentialCells[nc.MapPos+Vector2i(0,1)] if PotentialCells.has(nc.MapPos+Vector2i(0,1)) else make_template_cell()
			pc.RequiredPassFlags|=((nc.PassFlags&48)>>4)
			pc.MapPos=Vector2i(nc.MapPos+Vector2i(0,+1))
			PotentialCells[nc.MapPos+Vector2i(0,1)]=pc
		else:
			nc.PassFlags&=0b11001111
			nc.PassFlags|=(Cells[nc.MapPos+Vector2i(0,1)].PassFlags&3)<<4
	if nc.PassFlags&192:
		if !Cells.has(nc.MapPos+Vector2i(-1,0)):
			var pc=PotentialCells[nc.MapPos+Vector2i(-1,0)] if PotentialCells.has(nc.MapPos+Vector2i(-1,0)) else make_template_cell()
			pc.RequiredPassFlags|=((nc.PassFlags&192)>>4)
			pc.MapPos=Vector2i(nc.MapPos+Vector2i(-1,0))
			PotentialCells[nc.MapPos+Vector2i(-1,0)]=pc
		else:
			nc.PassFlags&=0b00111111
			nc.PassFlags|=(Cells[nc.MapPos+Vector2i(-1,0)].PassFlags&12)<<4
	pass
	
## Adds one of the potential cells to the floor
func AddCell(nc:CellData, pflags:int,new:bool=false):
	var pos=nc.MapPos
	nc.PassFlags=pflags
	nc.PassFlags&=nc.AllowedPassFlags
	nc.PassFlags|=nc.RequiredPassFlags
	if nc.PassFlags&3:
		if !Cells.has(Vector2i(pos.x,pos.y-1)):
			if Cells.size()+PotentialCells.size()<=maximum_room_count:
				var pc=PotentialCells[Vector2i(pos.x,pos.y-1)] if PotentialCells.has(Vector2i(pos.x,pos.y-1)) else make_template_cell()
				pc.RequiredPassFlags|=((nc.PassFlags&3)<<4)
				pc.PassFlags|=((nc.PassFlags&3)<<4)
				pc.MapPos=nc.MapPos-Vector2i(0,-1)
				PotentialCells[Vector2i(pos.x,pos.y-1)]=pc
		else:
			nc.PassFlags&=0b11111100
			nc.PassFlags|=(Cells[Vector2i(pos.x,pos.y-1)].PassFlags&48)>>4
	if nc.PassFlags&12: 
		if !Cells.has(Vector2i(pos.x+1,pos.y)):
			if Cells.size()+PotentialCells.size()<=maximum_room_count:
				var pc=PotentialCells[Vector2i(pos.x+1,pos.y)] if PotentialCells.has(Vector2i(pos.x+1,pos.y)) else make_template_cell()
				pc.RequiredPassFlags|=((nc.PassFlags&12)<<4)
				pc.AllowedPassFlags|=(3&((nc.PassFlags&12)>>2)<<6) 
				pc.MapPos=nc.MapPos+Vector2i(1,0)
				PotentialCells[Vector2i(pos.x+1,pos.y)]=pc
		else:
			nc.PassFlags&-0b11110011
			nc.PassFlags|=(Cells[Vector2i(pos.x+1,pos.y)].PassFlags&192)>>4
	if nc.PassFlags&48:
		if !Cells.has(Vector2i(pos.x,pos.y+1)):
			if Cells.size()+PotentialCells.size()<=maximum_room_count:
				var pc=PotentialCells[Vector2i(pos.x,pos.y+1)] if PotentialCells.has(Vector2i(pos.x,pos.y+1)) else make_template_cell()
				pc.RequiredPassFlags|=((nc.PassFlags&48)>>4)
				pc.PassFlags|=((nc.PassFlags&48)>>4)
				pc.MapPos=nc.MapPos+Vector2i(1,0)
				PotentialCells[Vector2i(pos.x,pos.y+1)]=pc
		else:
			nc.PassFlags&=0b11001111
			nc.PassFlags|=(Cells[Vector2i(pos.x,pos.y+1)].PassFlags&3)<<4
	if nc.PassFlags&192:
		if !Cells.has(Vector2i(pos.x-1,pos.y)):
			if Cells.size()+PotentialCells.size()<=maximum_room_count:
				var pc=PotentialCells[Vector2i(pos.x-1,pos.y)] if PotentialCells.has(Vector2i(pos.x-1,pos.y)) else make_template_cell()
				pc.RequiredPassFlags|=((nc.PassFlags&192)>>4)
				pc.PassFlags|=((nc.PassFlags&192)>>4)
				pc.MapPos=nc.MapPos+Vector2i(-1,0)
				PotentialCells[Vector2i(pos.x-1,pos.y)]=pc
		else:
			nc.PassFlags&=0b00111111
			nc.PassFlags|=(Cells[Vector2i(pos.x-1,pos.y)].PassFlags&12)<<4
			
	Cells[nc.MapPos]=nc
	PotentialCells.erase(nc.MapPos)
	pass


func _ready() -> void:
	rand=RandomNumberGenerator.new()
	pass
	
## Sets up the 
func setup(rseed:int)->void:
	rand.seed=rseed
	PotentialCells.clear()
	Cells.clear()
	pass

## Generates a CellData instance with default data 
func make_template_cell()->CellData:
	var c:=CellData.new()
	c.PassFlags=0
	c.RequiredPassFlags=0
	c.RoomType=0
	return c
