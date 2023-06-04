## Node for generating Dungeon floor layouts, randomly selects nex cell to be added
##
## This node generates the general layout of rooms. It does not 

class_name BaseFloorArchitect extends Node

var rand:=RandomNumberGenerator.new()

signal FloorPlanned

@export var Weigths:={Utils.PassageType.NONE:3
			,Utils.PassageType.NORMAL:5
			,Utils.PassageType.HIDDEN:0
			,Utils.PassageType.LOCKED:0
			,Utils.PassageType.CONNECTION:0}
			
@export var minimum_room_count:int=6
@export var maximum_room_count:int=9

## Dictionary of cells (using [CellData]) keyed by position (as 2-element array of ints)
@export var Cells: Dictionary={}
## Dictionary of cells, from which one can be added to the map
var PotentialCells:Dictionary={}

## Function that generates the floor layout
func plan_floor()->void:
	var init = CreateTemplateCell()
	PotentialCells[init.MapPos]=init
	
	while Cells.size() < maximum_room_count && !PotentialCells.is_empty():
		if !PotentialCells.is_empty():
			var nextc=GetNextCell()
			RealizeCell(nextc)
		while PotentialCells.is_empty():
			EnforceMinimum()
			if Cells.size()>=minimum_room_count:
				break
	CleanInvalidPassages()
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
	if !Cells.has(nc.MapPos+Utils.UP):
		if passages[Utils.UP] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]:
			var pc:CellData=PotentialCells[nc.MapPos+Utils.UP] if PotentialCells.has(nc.MapPos+Utils.UP) else CreateTemplateCell()
			pc.Passages[Utils.DOWN]=nc.Passages[Utils.UP]
			pc.MapPos=nc.MapPos+Utils.UP
			PotentialCells[pc.MapPos]=pc
	else:
		if Cells[nc.MapPos+Utils.UP].Passages[Utils.DOWN] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]:
			nc.Passages[Utils.UP]=Cells[nc.MapPos+Utils.UP].Passages[Utils.DOWN]
		else:
			Cells[nc.MapPos+Utils.UP].Passages[Utils.DOWN]=nc.Passages[Utils.UP]
		
	if !Cells.has(nc.MapPos+Utils.RIGHT):
		if passages[Utils.RIGHT] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]:
			var pc:CellData=(PotentialCells[nc.MapPos+Utils.RIGHT] if PotentialCells.has(nc.MapPos+Utils.RIGHT) else CreateTemplateCell())
			pc.Passages[Utils.LEFT]=nc.Passages[Utils.RIGHT]
			pc.MapPos=nc.MapPos+Utils.RIGHT
			PotentialCells[pc.MapPos]=pc
	else:
		if Cells[nc.MapPos+Utils.RIGHT].Passages[Utils.LEFT] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]:
			nc.Passages[Utils.RIGHT]=Cells[nc.MapPos+Utils.RIGHT].Passages[Utils.LEFT]
		else:
			Cells[nc.MapPos+Utils.RIGHT].Passages[Utils.LEFT]=nc.Passages[Utils.RIGHT]
		
	if !Cells.has(nc.MapPos+Utils.DOWN):
		if passages[Utils.DOWN] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]:
			var pc:CellData=PotentialCells[nc.MapPos+Utils.DOWN] if PotentialCells.has(nc.MapPos+Utils.DOWN) else CreateTemplateCell()
			pc.MapPos=nc.MapPos+Utils.DOWN
			pc.Passages[Utils.UP]=nc.Passages[Utils.DOWN]
			PotentialCells[pc.MapPos]=pc
	else:
		if Cells[nc.MapPos+Utils.DOWN].Passages[Utils.UP] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]:
			nc.Passages[Utils.DOWN]=Cells[nc.MapPos+Utils.DOWN].Passages[Utils.UP]
		else:
			Cells[nc.MapPos+Utils.DOWN].Passages[Utils.UP]=nc.Passages[Utils.DOWN]
		
	if !Cells.has(nc.MapPos+Utils.LEFT):
		if passages[Utils.LEFT] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]:
			var pc:CellData=PotentialCells[nc.MapPos+Utils.LEFT] if PotentialCells.has(nc.MapPos+Utils.LEFT) else CreateTemplateCell()
			pc.Passages[Utils.RIGHT]=nc.Passages[Utils.LEFT]
			pc.MapPos=nc.MapPos+Utils.LEFT
			PotentialCells[pc.MapPos]=pc
	else:
		if Cells[nc.MapPos+Utils.LEFT].Passages[Utils.RIGHT] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]:
			nc.Passages[Utils.LEFT]=Cells[nc.MapPos+Utils.LEFT].Passages[Utils.RIGHT]
		else:
			Cells[nc.MapPos+Utils.LEFT].Passages[Utils.RIGHT]=nc.Passages[Utils.LEFT]
	Cells[nc.MapPos]=nc

## Moves a cell from [member PotentialCells] to [member Cells]
##
## Removes the selected cell from [member PotentialCells], randomises it's passages while respecting existing cells, and adds it to [member Cells]. 
## Additionally adds to [member PotentialCells] according to the now defined passages
func RealizeCell(nc:CellData):
	var psgs=GeneratePassages(Weigths,nc.Passages)
	nc.Passages=psgs
	if !Cells.has(nc.MapPos+Utils.UP):
		if nc.Passages[Utils.UP] not in [Utils.PassageType.NONE] \
		and Cells.size()+PotentialCells.size()<=maximum_room_count:
			var pc:CellData=PotentialCells[nc.MapPos+Utils.UP] if PotentialCells.has(nc.MapPos+Utils.UP) else CreateTemplateCell()
			pc.MapPos=nc.MapPos+Utils.UP
			pc.Passages[Utils.DOWN]=nc.Passages[Utils.UP]
			PotentialCells[pc.MapPos]=pc
	else:
		nc.Passages[Utils.UP]=Cells[nc.MapPos+Utils.UP].Passages[Utils.DOWN]
		
	if !Cells.has(nc.MapPos+Utils.RIGHT):
		if  nc.Passages[Utils.RIGHT] not in [Utils.PassageType.NONE] \
		and Cells.size()+PotentialCells.size()<=maximum_room_count:
			var pc:CellData=PotentialCells[nc.MapPos+Utils.RIGHT] if PotentialCells.has(nc.MapPos+Utils.RIGHT) else CreateTemplateCell()
			pc.MapPos=nc.MapPos+Utils.RIGHT
			pc.Passages[Utils.LEFT]=nc.Passages[Utils.RIGHT]
			PotentialCells[pc.MapPos]=pc
	else:
		nc.Passages[Utils.RIGHT]=Cells[nc.MapPos+Utils.RIGHT].Passages[Utils.LEFT]
		
	if !Cells.has(nc.MapPos+Utils.DOWN):
		if nc.Passages[Utils.DOWN] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED] \
		and Cells.size()+PotentialCells.size()<=maximum_room_count:
			var pc:CellData=PotentialCells[nc.MapPos+Utils.DOWN] if PotentialCells.has(nc.MapPos+Utils.DOWN) else CreateTemplateCell()
			pc.MapPos=nc.MapPos+Utils.DOWN
			pc.Passages[Utils.UP]=nc.Passages[Utils.DOWN]
			PotentialCells[pc.MapPos]=pc
	else:
		nc.Passages[Utils.DOWN]=Cells[nc.MapPos+Utils.DOWN].Passages[Utils.UP]
		
	if !Cells.has(nc.MapPos+Utils.LEFT):
		if nc.Passages[Utils.LEFT] not in [Utils.PassageType.NONE] \
		and Cells.size()+PotentialCells.size()<=maximum_room_count:
			var pc:CellData=PotentialCells[nc.MapPos+Utils.LEFT] if PotentialCells.has(nc.MapPos+Utils.LEFT) else CreateTemplateCell()
			pc.MapPos=nc.MapPos+Utils.LEFT
			pc.Passages[Utils.RIGHT]=nc.Passages[Utils.LEFT]
			PotentialCells[pc.MapPos]=pc
	else:
		nc.Passages[Utils.LEFT]=Cells[nc.MapPos+Utils.LEFT].Passages[Utils.RIGHT]
			
	Cells[nc.MapPos]=nc
	PotentialCells.erase(nc.MapPos)

## Eliminates "open" passages to nonexisting cells
func CleanInvalidPassages():
	for c in Cells.values():
		for p in c.Passages.keys():
			if c.Passages[p] not in [Utils.PassageType.NONE]:
				if !Cells.has(c.MapPos+p):
					c.Passages[p]=Utils.PassageType.NONE

## Forcefully adds additional room, if the minimum has not been reached
func EnforceMinimum()->void:
	var tmp:=Cells.keys()
	tmp.shuffle()
	var psg=GeneratePassages(Weigths)
	for i in tmp:
		if Cells[i].Passages[Utils.UP] == Utils.PassageType.NONE && !Cells.has(i+Utils.UP):
			psg[Utils.DOWN]=Utils.PassageType.NORMAL
			AddNewCell(i+Utils.UP,psg)
			return
		elif Cells[i].Passages[Utils.RIGHT] == Utils.PassageType.NONE && !Cells.has(i+Utils.RIGHT):
			psg[Utils.LEFT]=Utils.PassageType.NORMAL
			AddNewCell(i+Utils.RIGHT,psg)
			return
		elif Cells[i].Passages[Utils.DOWN] == Utils.PassageType.NONE && !Cells.has(i+Utils.DOWN):
			psg[Utils.UP]=Utils.PassageType.NORMAL
			AddNewCell(i+Utils.DOWN,psg)
			return 
		elif Cells[i].Passages[Utils.LEFT] == Utils.PassageType.NONE && !Cells.has(i+Utils.LEFT):
			psg[Utils.RIGHT]=Utils.PassageType.NORMAL
			AddNewCell(i+Utils.LEFT,psg)
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
	c.Passages={Utils.UP:Utils.PassageType.UNDEFINED,
			Utils.RIGHT:Utils.PassageType.UNDEFINED,
			Utils.DOWN:Utils.PassageType.UNDEFINED,
			Utils.LEFT:Utils.PassageType.UNDEFINED}
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
		psg={Utils.UP:Utils.PassageType.UNDEFINED,
			Utils.RIGHT:Utils.PassageType.UNDEFINED,
			Utils.DOWN:Utils.PassageType.UNDEFINED,
			Utils.LEFT:Utils.PassageType.UNDEFINED}
	for k in psg.keys():
		if psg[k] == Utils.PassageType.UNDEFINED:
			psg[k]=pt[rand.randi_range(0,pt.size()-1)]
	return psg



