## Node for generating Dungeon floor layouts, randomly selects nex cell to be added
##
## This node generates the general layout of rooms. It does not 

class_name BaseFloorArchitect extends Node

var rand:=RandomNumberGenerator.new()

signal FloorPlanned

@export var Weigths:={Defs.PassageType.NONE:3,Defs.PassageType.HIDDEN:0,Defs.PassageType.NORMAL:5,Defs.PassageType.CONNECTION:0}
@export var minimum_room_count:int=6
@export var maximum_room_count:int=7

## Dictionary of cells (using [CellData]) keyed by position (as 2-element array of ints)
@export var Cells: Dictionary={}
## Dictionary of cells, from which one can be added to the map
var PotentialCells:Dictionary={}

## Function that generates the floor layout
func plan_floor()->void:
	AddNewCell(Vector2i(0,0),{Defs.UP:Defs.PassageType.NORMAL,
	Defs.RIGHT : Defs.PassageType.NORMAL,
	Defs.DOWN : Defs.PassageType.NORMAL,
	Defs.LEFT : Defs.PassageType.NORMAL})
	
	while Cells.size() < maximum_room_count && !PotentialCells.is_empty():
		if !PotentialCells.is_empty():
			var nextc=GetNextCell()
			RealizeCell(nextc)
		while PotentialCells.is_empty():
			EnforceMinimum()
			if Cells.size()>=minimum_room_count:
				break
		await get_tree().process_frame
	CleanInvalidPassages()
	print("planned")
	FloorPlanned.emit()

## Picks next cell to be added from [member PotentialCells]
func GetNextCell()->CellData:
	var k=PotentialCells.keys()
	var i=rand.randi_range(0,k.size()-1)
	return PotentialCells[k[i]]

## Adds a new [class CellData] in the specified position with the specified passages.
##
## Creates and adds a new [class CellData] to the [member Cells], will overwrite PassageType.NONE of existing cells.
func AddNewCell(pos:Vector2i, passages:Dictionary):
	var nc:=CreateTemplateCell()
	nc.MapPos=pos
	nc.Passages=passages
	if !Cells.has(nc.MapPos+Defs.UP):
		if passages[Defs.UP] not in [Defs.PassageType.NONE,Defs.PassageType.UNDEFINED]:
			var pc:CellData=PotentialCells[nc.MapPos+Defs.UP] if PotentialCells.has(nc.MapPos+Defs.UP) else CreateTemplateCell()
			pc.Passages[Defs.DOWN]=nc.Passages[Defs.UP]
			pc.MapPos=nc.MapPos+Defs.UP
			PotentialCells[pc.MapPos]=pc
	else:
		if Cells[nc.MapPos+Defs.UP].Passages[Defs.DOWN] not in [Defs.PassageType.NONE,Defs.PassageType.UNDEFINED]:
			nc.Passages[Defs.UP]=Cells[nc.MapPos+Defs.UP].Passages[Defs.DOWN]
		else:
			Cells[nc.MapPos+Defs.UP].Passages[Defs.DOWN]=nc.Passages[Defs.UP]
		
	if !Cells.has(nc.MapPos+Defs.RIGHT):
		if passages[Defs.RIGHT] not in [Defs.PassageType.NONE,Defs.PassageType.UNDEFINED]:
			var pc:CellData=(PotentialCells[nc.MapPos+Defs.RIGHT] if PotentialCells.has(nc.MapPos+Defs.RIGHT) else CreateTemplateCell())
			pc.Passages[Defs.LEFT]=nc.Passages[Defs.RIGHT]
			pc.MapPos=nc.MapPos+Defs.RIGHT
			PotentialCells[pc.MapPos]=pc
	else:
		if Cells[nc.MapPos+Defs.RIGHT].Passages[Defs.LEFT] not in [Defs.PassageType.NONE,Defs.PassageType.UNDEFINED]:
			nc.Passages[Defs.RIGHT]=Cells[nc.MapPos+Defs.RIGHT].Passages[Defs.LEFT]
		else:
			Cells[nc.MapPos+Defs.RIGHT].Passages[Defs.LEFT]=nc.Passages[Defs.RIGHT]
		
	if !Cells.has(nc.MapPos+Defs.DOWN):
		if passages[Defs.DOWN] not in [Defs.PassageType.NONE,Defs.PassageType.UNDEFINED]:
			var pc:CellData=PotentialCells[nc.MapPos+Defs.DOWN] if PotentialCells.has(nc.MapPos+Defs.DOWN) else CreateTemplateCell()
			pc.MapPos=nc.MapPos+Defs.DOWN
			pc.Passages[Defs.UP]=nc.Passages[Defs.DOWN]
			PotentialCells[pc.MapPos]=pc
	else:
		if Cells[nc.MapPos+Defs.DOWN].Passages[Defs.UP] not in [Defs.PassageType.NONE,Defs.PassageType.UNDEFINED]:
			nc.Passages[Defs.DOWN]=Cells[nc.MapPos+Defs.DOWN].Passages[Defs.UP]
		else:
			Cells[nc.MapPos+Defs.DOWN].Passages[Defs.UP]=nc.Passages[Defs.DOWN]
		
	if !Cells.has(nc.MapPos+Defs.LEFT):
		if passages[Defs.LEFT] not in [Defs.PassageType.NONE,Defs.PassageType.UNDEFINED]:
			var pc:CellData=PotentialCells[nc.MapPos+Defs.LEFT] if PotentialCells.has(nc.MapPos+Defs.LEFT) else CreateTemplateCell()
			pc.Passages[Defs.RIGHT]=nc.Passages[Defs.LEFT]
			pc.MapPos=nc.MapPos+Defs.LEFT
			PotentialCells[pc.MapPos]=pc
	else:
		if Cells[nc.MapPos+Defs.LEFT].Passages[Defs.RIGHT] not in [Defs.PassageType.NONE,Defs.PassageType.UNDEFINED]:
			nc.Passages[Defs.LEFT]=Cells[nc.MapPos+Defs.LEFT].Passages[Defs.RIGHT]
		else:
			Cells[nc.MapPos+Defs.LEFT].Passages[Defs.RIGHT]=nc.Passages[Defs.LEFT]
	Cells[nc.MapPos]=nc

## Moves a cell from [member PotentialCells] to [member Cells]
##
## Removes the selected cell from [member PotentialCells], randomises it's passages while respecting existing cells, and adds it to [member Cells]. 
## Additionally adds to [member PotentialCells] according to the now defined passages
func RealizeCell(nc:CellData):
	var psgs=GeneratePassages(Weigths,nc.Passages)
	nc.Passages=psgs
	if !Cells.has(nc.MapPos+Defs.UP):
		if nc.Passages[Defs.UP] not in [Defs.PassageType.NONE] \
		and Cells.size()+PotentialCells.size()<=maximum_room_count:
			var pc:CellData=PotentialCells[nc.MapPos+Defs.UP] if PotentialCells.has(nc.MapPos+Defs.UP) else CreateTemplateCell()
			pc.MapPos=nc.MapPos+Defs.UP
			pc.Passages[Defs.DOWN]=nc.Passages[Defs.UP]
			PotentialCells[pc.MapPos]=pc
	else:
		nc.Passages[Defs.UP]=Cells[nc.MapPos+Defs.UP].Passages[Defs.DOWN]
		
	if !Cells.has(nc.MapPos+Defs.RIGHT):
		if  nc.Passages[Defs.RIGHT] not in [Defs.PassageType.NONE] \
		and Cells.size()+PotentialCells.size()<=maximum_room_count:
			var pc:CellData=PotentialCells[nc.MapPos+Defs.RIGHT] if PotentialCells.has(nc.MapPos+Defs.RIGHT) else CreateTemplateCell()
			pc.MapPos=nc.MapPos+Defs.RIGHT
			pc.Passages[Defs.LEFT]=nc.Passages[Defs.RIGHT]
			PotentialCells[pc.MapPos]=pc
	else:
		nc.Passages[Defs.RIGHT]=Cells[nc.MapPos+Defs.RIGHT].Passages[Defs.LEFT]
		
	if !Cells.has(nc.MapPos+Defs.DOWN):
		if nc.Passages[Defs.DOWN] not in [Defs.PassageType.NONE,Defs.PassageType.UNDEFINED] \
		and Cells.size()+PotentialCells.size()<=maximum_room_count:
			var pc:CellData=PotentialCells[nc.MapPos+Defs.DOWN] if PotentialCells.has(nc.MapPos+Defs.DOWN) else CreateTemplateCell()
			pc.MapPos=nc.MapPos+Defs.DOWN
			pc.Passages[Defs.UP]=nc.Passages[Defs.DOWN]
			PotentialCells[pc.MapPos]=pc
	else:
		nc.Passages[Defs.DOWN]=Cells[nc.MapPos+Defs.DOWN].Passages[Defs.UP]
		
	if !Cells.has(nc.MapPos+Defs.LEFT):
		if nc.Passages[Defs.LEFT] not in [Defs.PassageType.NONE] \
		and Cells.size()+PotentialCells.size()<=maximum_room_count:
			var pc:CellData=PotentialCells[nc.MapPos+Defs.LEFT] if PotentialCells.has(nc.MapPos+Defs.LEFT) else CreateTemplateCell()
			pc.MapPos=nc.MapPos+Defs.LEFT
			pc.Passages[Defs.RIGHT]=nc.Passages[Defs.LEFT]
			PotentialCells[pc.MapPos]=pc
	else:
		nc.Passages[Defs.LEFT]=Cells[nc.MapPos+Defs.LEFT].Passages[Defs.RIGHT]
			
	Cells[nc.MapPos]=nc
	PotentialCells.erase(nc.MapPos)

## Eliminates "open" passages to nonexisting cells
func CleanInvalidPassages():
	for c in Cells.values():
		print("¿",c.MapPos,c.Passages)
		for p in c.Passages.keys():
			if c.Passages[p] not in [Defs.PassageType.NONE]:
				if !Cells.has(c.MapPos+p):
					c.Passages[p]=Defs.PassageType.NONE
		print("¡",c.MapPos,c.Passages)

## Forcefully adds additional room, if the minimum has not been reached
func EnforceMinimum()->void:
	var tmp:=Cells.keys()
	tmp.shuffle()
	var psg=GeneratePassages(Weigths)
	for i in tmp:
		if Cells[i].Passages[Defs.UP] == Defs.PassageType.NONE && !Cells.has(i+Defs.UP):
			psg[Defs.DOWN]=Defs.PassageType.NORMAL
			AddNewCell(i+Defs.UP,psg)
			return
		elif Cells[i].Passages[Defs.RIGHT] == Defs.PassageType.NONE && !Cells.has(i+Defs.RIGHT):
			psg[Defs.LEFT]=Defs.PassageType.NORMAL
			AddNewCell(i+Defs.RIGHT,psg)
			return
		elif Cells[i].Passages[Defs.DOWN] == Defs.PassageType.NONE && !Cells.has(i+Defs.DOWN):
			psg[Defs.UP]=Defs.PassageType.NORMAL
			AddNewCell(i+Defs.DOWN,psg)
			return 
		elif Cells[i].Passages[Defs.LEFT] == Defs.PassageType.NONE && !Cells.has(i+Defs.LEFT):
			psg[Defs.RIGHT]=Defs.PassageType.NORMAL
			AddNewCell(i+Defs.LEFT,psg)
			return
	


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
func CreateTemplateCell()->CellData:
	var c:=CellData.new()
	c.Passages={Defs.UP:Defs.PassageType.UNDEFINED,
			Defs.RIGHT:Defs.PassageType.UNDEFINED,
			Defs.DOWN:Defs.PassageType.UNDEFINED,
			Defs.LEFT:Defs.PassageType.UNDEFINED}
	c.RoomType=0
	return c

## Generates passages for a cell by replacing the UNDEFINED values by value randomly selected based on [member Weigths]
func GeneratePassages(weigths:Dictionary,cps:Dictionary={})->Dictionary:
	var pt=[]
	for k in weigths.keys():
		for i in range(weigths[k]):
			pt.push_back(k)
	var psg
	if !cps.is_empty():
		psg=cps
	else:
		psg={Defs.UP:Defs.PassageType.UNDEFINED,
			Defs.RIGHT:Defs.PassageType.UNDEFINED,
			Defs.DOWN:Defs.PassageType.UNDEFINED,
			Defs.LEFT:Defs.PassageType.UNDEFINED}
	for k in psg.keys():
		if psg[k] == Defs.PassageType.UNDEFINED:
			psg[k]=pt[rand.randi_range(0,pt.size()-1)]
	return psg
