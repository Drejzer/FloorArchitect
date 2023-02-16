## Node for generating Dungeon floor layouts
##
## This 

class_name BaseFloorArchitect extends Node

var rand:=RandomNumberGenerator.new()

signal FloorPlanned

@export var Weigths:={Defs.PassageType.NONE:3,Defs.PassageType.HIDDEN:0,Defs.PassageType.NORMAL:5,Defs.PassageType.CONNECTION:0}
@export var minimum_room_count:int=6
@export var maximum_room_count:int=7
#export var multicell_rooms_allowed:bool=false
## Dictionary of cells (using [CellData]) keyed by position (as 2-element array of ints)
@export var Cells: Dictionary={}
## Dictionary of cells, from which one can be added to the map
var PotentialCells:={}

## Function that generates the floor layout
func plan_floor()->void:
	var fc:=rand.randi_range(0,4)
	match(fc):
#		0:
#			AddNewCell(0,0,(2|8|32|128))
#		1:
#			AddNewCell(0,0,(3|8|32|128))
#		2:
#			AddNewCell(0,0,(2|12|32|128))
#		3:
#			AddNewCell(0,0,(2|8|48|128))
#		4:
#			AddNewCell(0,0,(2|8|32|192))
		_:
			pass
		
	while Cells.size() < minimum_room_count && !PotentialCells.is_empty():
		var pckeylist= PotentialCells.keys()
		var i = rand.randi_range(0,pckeylist.size()-1)
		var nextc:=(PotentialCells[pckeylist[i]] as CellData)
		var psgs=GeneratePassages(nextc,Weigths)
		AddCell(nextc,psgs)
		if PotentialCells.is_empty() && Cells.size()<minimum_room_count:
			enforce_minimum()
	cleanup()
	FloorPlanned.emit()
	pass

## Eliminates "open" passages to nonexisting cells
func cleanup():
	for c in Cells.values():
		for p in c.Passages.keys():
			if c.Passages[p] not in [Defs.PassageType.NONE,Defs.PassageType.UNDEFINED]:
				if !Cells.has(c.MapPos+p):
					c.Passages[p]=Defs.PassageType.NONE

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
			#AddNewCell(i[0],i[1]-1,rpf|32)
			return
		elif Cells[i].PassFlags&12==0:
			Cells[i].PassFlags|=8
			#AddNewCell(i[0]+1,i[1],rpf|128)
			return
		elif Cells[i].PassFlags&48==0:
			Cells[i].PassFlags|=32
			#AddNewCell(i[0],i[1]+1,rpf|2)
			return
		elif Cells[i].PassFlags&192==0:
			Cells[i].PassFlags|=128
			#AddNewCell(i[0]-1,i[1],rpf|8)
			return
	

## Adds a new [CellData] in the specified position with the specified  [member Defs.PassageType]. Adds potential [CellData]s and modifies existing [CellData]s.
##
## Creates and adds a new [CellData] to the [member Cells] 

func AddNewCell(posx:int, posy:int, passages:Dictionary):
	var nc:=CellData.new()
	nc.MapPos=Vector2i(posx,posy)
	nc.Passages=passages
	Cells[nc.MapPos]=nc
	if nc.Passages[Defs.UP] not in [Defs.PassageTypes.NONE,Defs.PassageType.UNDEFINED]:
		if(!Cells.has(nc.MapPos+Defs.UP)):
			var pc:CellData=PotentialCells[nc.MapPos+Defs.UP] if PotentialCells.has(nc.MapPos+Defs.UP) else make_template_cell()
			pc.Passages[Defs.Down]=nc.Passages[Defs.UP]
			pc.MapPos=Vector2i(nc.MapPos+Defs.UP)
			PotentialCells[pc.MapPos]=pc
		else:
			nc.Passages[Defs.UP]=Cells[nc.MapPos+Defs.UP].Passages[Defs.DOWN]
	if nc.Passages[Defs.Right] not in [Defs.PassageTypes.NONE,Defs.PassageType.UNDEFINED]:
		if !Cells.has(nc.MapPos+Defs.RIGHT):
			var pc:CellData=(PotentialCells[nc.MapPos+Defs.RIGHT] if PotentialCells.has(nc.MapPos+Defs.RIGHT) else make_template_cell())
			pc.Passages[Defs.LEFT]=nc.Passages[Defs.RIGHT]
			pc.MapPos=nc.MapPos+Defs.RIGHT
			PotentialCells[pc.MapPos]=pc
		else:
			nc.Passages[Defs.RIGHT]=Cells[nc.MapPos+Defs.RIGHT].Passages[Defs.LEFT]
	if nc.Passages[Defs.DOWN] not in [Defs.PassageTypes.NONE,Defs.PassageType.UNDEFINED]:
		if !Cells.has(nc.MapPos+Defs.DOWN):
			var pc:CellData=PotentialCells[nc.MapPos+Defs.DOWN] if PotentialCells.has(nc.MapPos+Defs.DOWN) else make_template_cell()
			pc.Passages[Defs.UP]=nc.Passages[Defs.DOWN]
			pc.MapPos=nc.MapPos+Defs.DOWN
			PotentialCells[pc.MapPos]=pc
		else:
			nc.Passages[Defs.DOWN]=Cells[nc.MapPos+Defs.DOWN].Passages[Defs.UP]
	if nc.Passages[Defs.LEFT] not in [Defs.PassageTypes.NONE,Defs.PassageType.UNDEFINED]:
		if !Cells.has(nc.MapPos+Vector2i(-1,0)):
			var pc=PotentialCells[nc.MapPos+Defs.LEFT] if PotentialCells.has(nc.MapPos+Defs.LEFT) else make_template_cell()
			pc.RequiredPassFlags|=((nc.PassFlags&192)>>4)
			pc.MapPos=nc.MapPos+Defs.LEFT
			PotentialCells[nc.MapPos+Vector2i(-1,0)]=pc
		else:
			nc.Passages=Cells[nc.MapPos+Defs.LEFT]
			nc.PassFlags|=(Cells[nc.MapPos+Vector2i(-1,0)].PassFlags&12)<<4
	pass
	
## Adds one of the cells from [member PotentialCells] to the [member Cells] dictionary
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
	
## Sets up the class. Allows for setting the seed of [member rand]
func setup(rseed:int)->void:
	rand.seed=rseed
	PotentialCells.clear()
	Cells.clear()
	pass

## Generates a CellData instance with default data 
func make_template_cell()->CellData:
	var c:=CellData.new()
	c.Passages={Defs.UP:Defs.PassageType.UNDEFINED,
			Defs.RIGHT:Defs.PassageType.UNDEFINED,
			Defs.DOWN:Defs.PassageType.UNDEFINED,
			Defs.LEFT:Defs.PassageType.UNDEFINED}
	c.RoomType=0
	return c

func GeneratePassages(cell:CellData,weigths:Dictionary)->Dictionary:
	var pt=[]
	for k in weigths.keys():
		for i in range(weigths[k]):
			pt+=[k]
	var psg=cell.Passages
	for k in psg.keys():
		if psg[k] == Defs.PassageType.UNDEFINED:
			psg[k]=pt[rand.randi_range(0,pt.size()-1)]
	return psg
