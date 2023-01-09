extends Node2D

class_name BaseFloorArchitect

var rand:=RandomNumberGenerator.new()

signal FloorPlanned

export var minimum_room_count:int=6
export var maximum_room_count:int=7
export var path_cull_threshold:int=4
export var loops_allowed:bool=true
export var multicell_rooms_allowed:bool=false

## Dictionary of cells (using CellData class) keyed by position (as 2-element array of ints)
export(Dictionary) var Cells:={}
## The Packed scene that is to be used as a Cell

var PotentialCells:={}

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
		
	while Cells.size() < minimum_room_count && !PotentialCells.empty():
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
		if PotentialCells.empty() && Cells.size()<minimum_room_count:
			enforce_minimum()
			pass
	cleanup()
	emit_signal("FloorPlanned")
	pass

func cleanup():
	for c in Cells.values():
		if c.PassFlags&3 && !Cells.has([(c as CellData).MapPos_x,(c as CellData).MapPos_y-1]):
			c.PassFlags&=0b11111100
		if c.PassFlags&12 && !Cells.has([(c as CellData).MapPos_x+1,(c as CellData).MapPos_y]):
			c.PassFlags&=0b11110011
		if c.PassFlags&48 && !Cells.has([(c as CellData).MapPos_x,(c as CellData).MapPos_y+1]):
			c.PassFlags&=0b11001111
		if c.PassFlags&192 && !Cells.has([(c as CellData).MapPos_x-1,(c as CellData).MapPos_y]):
			c.PassFlags&=0b00111111

func enforce_minimum()->void:
	var tmp :=Cells.keys()
	tmp.shuffle()
	var rpf:=0
	if rand.randi_range(1,3)==1:
		rpf=2
	if rand.randi_range(1,3)==1:
		rpf|=8
	if rand.randi_range(1,3)==1:
		rpf|=32
	if rand.randi_range(1,3)==1:
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
	

## Adds a new cell in the specified position with the specified flags. Adds potential cells based on the flags of the added cell
func AddNewCell(var posx:int,var posy:int,var pflags:int):
	var nc:=CellData.new()
	nc.MapPos_x=posx
	nc.MapPos_y=posy
	nc.PassFlags=pflags
	Cells[[posx,posy]]=nc
	if nc.PassFlags&3:
		if(!Cells.has([posx,posy-1])):
			var pc=PotentialCells[[posx,posy-1]] if PotentialCells.has([posx,posy-1]) else make_template_cell()
			pc.RequiredPassFlags|=((nc.PassFlags&3)<<4)
			pc.MapPos_x=nc.MapPos_x
			pc.MapPos_y=nc.MapPos_y-1
			PotentialCells[[posx,posy-1]]=pc
		else:
			nc.PassFlags&=0b11111100
			nc.PassFlags|=(Cells[[posx,posy-1]].PassFlags&48)>>4
	if nc.PassFlags&12:
		if !Cells.has([posx+1,posy]):
			var pc=PotentialCells[[posx+1,posy]] if PotentialCells.has([posx+1,posy]) else make_template_cell()
			pc.RequiredPassFlags|=((nc.PassFlags&12)<<4)
			pc.MapPos_x=nc.MapPos_x+1
			pc.MapPos_y=nc.MapPos_y
			PotentialCells[[posx+1,posy]]=pc
		else:
			nc.PassFlags&=0b11110011
			nc.PassFlags|=(Cells[[posx+1,posy]].PassFlags&192)>>4
	if nc.PassFlags&48:
		if !Cells.has([posx,posy+1]):
			var pc=PotentialCells[[posx,posy+1]] if PotentialCells.has([posx,posy+1]) else make_template_cell()
			pc.RequiredPassFlags|=((nc.PassFlags&48)>>4)
			pc.MapPos_x=nc.MapPos_x
			pc.MapPos_y=nc.MapPos_y+1
			PotentialCells[[posx,posy+1]]=pc
		else:
			nc.PassFlags&=0b11001111
			nc.PassFlags|=(Cells[[posx,posy+1]].PassFlags&3)<<4
	if nc.PassFlags&192:
		if !Cells.has([posx-1,posy]):
			var pc=PotentialCells[[posx-1,posy]] if PotentialCells.has([posx-1,posy]) else make_template_cell()
			pc.RequiredPassFlags|=((nc.PassFlags&192)>>4)
			pc.MapPos_x=nc.MapPos_x-1
			pc.MapPos_y=nc.MapPos_y
			PotentialCells[[posx-1,posy]]=pc
		else:
			nc.PassFlags&=0b00111111
			nc.PassFlags|=(Cells[[posx-1,posy]].PassFlags&12)<<4
	pass
	
## Adds one of the potential cells to the floor, the pflags set the passflags
func AddCell(var nc:CellData,var pflags:int):
	var posx=nc.MapPos_x
	var posy=nc.MapPos_y
	nc.PassFlags=pflags
	nc.PassFlags&=nc.AllowedPassFlags
	nc.PassFlags|=nc.RequiredPassFlags
	if nc.PassFlags&3:
		if !Cells.has([posx,posy-1]):
			if Cells.size()+PotentialCells.size()<maximum_room_count:
				var pc=PotentialCells[[posx,posy-1]] if PotentialCells.has([posx,posy-1]) else make_template_cell()
				pc.RequiredPassFlags|=((nc.PassFlags&3)<<4)
				pc.PassFlags|=((nc.PassFlags&3)<<4)
				pc.MapPos_x=nc.MapPos_x
				pc.MapPos_y=nc.MapPos_y-1
				PotentialCells[[posx,posy-1]]=pc
		else:
			nc.PassFlags&=0b11111100
			nc.PassFlags|=(Cells[[posx,posy-1]].PassFlags&48)>>4
	if nc.PassFlags&12: 
		if !Cells.has([posx+1,posy]):
			if Cells.size()+PotentialCells.size()<maximum_room_count:
				var pc=PotentialCells[[posx+1,posy]] if PotentialCells.has([posx+1,posy]) else make_template_cell()
				pc.RequiredPassFlags|=((nc.PassFlags&12)<<4)
				pc.AllowedPassFlags|=(3&((nc.PassFlags&12)>>2)<<6) 
				pc.MapPos_x=nc.MapPos_x+1
				pc.MapPos_y=nc.MapPos_y
				PotentialCells[[posx+1,posy]]=pc
		else:
			nc.PassFlags&-0b11110011
			nc.PassFlags|=(Cells[[posx+1,posy]].PassFlags&192)>>4
	if nc.PassFlags&48:
		if !Cells.has([posx,posy+1]):
			if Cells.size()+PotentialCells.size()<maximum_room_count:
				var pc=PotentialCells[[posx,posy+1]] if PotentialCells.has([posx,posy+1]) else make_template_cell()
				pc.RequiredPassFlags|=((nc.PassFlags&48)>>4)
				pc.PassFlags|=((nc.PassFlags&48)>>4)
				pc.MapPos_x=nc.MapPos_x
				pc.MapPos_y=nc.MapPos_y+1
				PotentialCells[[posx,posy+1]]=pc
		else:
			nc.PassFlags&=0b11001111
			nc.PassFlags|=(Cells[[posx,posy+1]].PassFlags&3)<<4
	if nc.PassFlags&192:
		if !Cells.has([posx-1,posy]):
			if Cells.size()+PotentialCells.size()<maximum_room_count:
				var pc=PotentialCells[[posx-1,posy]] if PotentialCells.has([posx-1,posy]) else make_template_cell()
				pc.RequiredPassFlags|=((nc.PassFlags&192)>>4)
				pc.PassFlags|=((nc.PassFlags&192)>>4)
				pc.MapPos_x=nc.MapPos_x-1
				pc.MapPos_y=nc.MapPos_y
				PotentialCells[[posx-1,posy]]=pc
		else:
			nc.PassFlags&=0b00111111
			nc.PassFlags|=(Cells[[posx-1,posy]].PassFlags&12)<<4
			
	Cells[[nc.MapPos_x,nc.MapPos_y]]=nc
	PotentialCells.erase([nc.MapPos_x,nc.MapPos_y])
	pass


func _ready() -> void:
	rand.randomize()
	pass
	
func setup(var rseed:int=13375334)->void:
	rand.seed=rseed
	PotentialCells.clear()
	Cells.clear()
	pass
	
func make_template_cell()->CellData:
	var c:=CellData.new()
	c.PassFlags=0
	c.RequiredPassFlags=0
	c.RoomType=0
	return c
