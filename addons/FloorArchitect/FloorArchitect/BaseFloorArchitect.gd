## Base Node for generating Dungeon floor layouts. Holds declarations of common variables and methods
##
## This class acts as an abstract class, it doesn't provide any method definitions, for particular algorithm implementations look at classes derived from it.
class_name BaseFloorArchitect extends Node

var rand:=RandomNumberGenerator.new()

signal FloorPlanned
@export var Weigths:={"NONE":3
			,"NORMAL":5
			,"HIDDEN":0
			,"LOCKED":0
			,"CONNECTION":0}
			

## Dictionary of cells (using [CellData]) keyed by position (using [Vector2i])
@export var Cells: Dictionary={}
## Dictionary of cells that can be added to the map
var PotentialCells:Dictionary={}

## Function that generates the floor layout, should be overloaded for each implementation.[br]
## Base implementation should be called at the end.
func PlanFloor()->void:
	CleanInvalidPassages()
	FloorPlanned.emit()


## Adds a new [class CellData] in the specified position with the specified passages.
##
## Creates and adds a new [class CellData] to the [member Cells], will overwrite PassageType.NONE and PassageType.UNDEFINED of existing cells.
func AddNewCell(pos:Vector2i, passages:Dictionary,add_potential:bool=true):
	var nc:=Utils.CreateTemplateCell(pos)
	nc.Passages=passages
	if !Cells.has(nc.MapPos+Utils.UP):
		if add_potential && passages[Utils.UP] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]:
			var pc:CellData=PotentialCells[nc.MapPos+Utils.UP] if PotentialCells.has(nc.MapPos+Utils.UP) else Utils.CreateTemplateCell(nc.MapPos+Utils.UP)
			pc.Passages[Utils.DOWN]=nc.Passages[Utils.UP]
			PotentialCells[pc.MapPos]=pc
	else:
		if Cells[nc.MapPos+Utils.UP].Passages[Utils.DOWN] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]:
			nc.Passages[Utils.UP]=Cells[nc.MapPos+Utils.UP].Passages[Utils.DOWN]
		else:
			Cells[nc.MapPos+Utils.UP].Passages[Utils.DOWN]=nc.Passages[Utils.UP]
		
	if !Cells.has(nc.MapPos+Utils.RIGHT):
		if add_potential && passages[Utils.RIGHT] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]:
			var pc:CellData=(PotentialCells[nc.MapPos+Utils.RIGHT] if PotentialCells.has(nc.MapPos+Utils.RIGHT) else Utils.CreateTemplateCell(nc.MapPos+Utils.RIGHT))
			pc.Passages[Utils.LEFT]=nc.Passages[Utils.RIGHT]
			PotentialCells[pc.MapPos]=pc
	else:
		if Cells[nc.MapPos+Utils.RIGHT].Passages[Utils.LEFT] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]:
			nc.Passages[Utils.RIGHT]=Cells[nc.MapPos+Utils.RIGHT].Passages[Utils.LEFT]
		else:
			Cells[nc.MapPos+Utils.RIGHT].Passages[Utils.LEFT]=nc.Passages[Utils.RIGHT]
		
	if !Cells.has(nc.MapPos+Utils.DOWN):
		if add_potential && passages[Utils.DOWN] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]:
			var pc:CellData=PotentialCells[nc.MapPos+Utils.DOWN] if PotentialCells.has(nc.MapPos+Utils.DOWN) else Utils.CreateTemplateCell(nc.MapPos+Utils.DOWN)
			pc.Passages[Utils.UP]=nc.Passages[Utils.DOWN]
			PotentialCells[pc.MapPos]=pc
	else:
		if Cells[nc.MapPos+Utils.DOWN].Passages[Utils.UP] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]:
			nc.Passages[Utils.DOWN]=Cells[nc.MapPos+Utils.DOWN].Passages[Utils.UP]
		else:
			Cells[nc.MapPos+Utils.DOWN].Passages[Utils.UP]=nc.Passages[Utils.DOWN]
		
	if !Cells.has(nc.MapPos+Utils.LEFT):
		if add_potential && passages[Utils.LEFT] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]:
			var pc:CellData=PotentialCells[nc.MapPos+Utils.LEFT] if PotentialCells.has(nc.MapPos+Utils.LEFT) else Utils.CreateTemplateCell(nc.MapPos+Utils.LEFT)
			pc.Passages[Utils.RIGHT]=nc.Passages[Utils.LEFT]
			PotentialCells[pc.MapPos]=pc
	else:
		if Cells[nc.MapPos+Utils.LEFT].Passages[Utils.RIGHT] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]:
			nc.Passages[Utils.LEFT]=Cells[nc.MapPos+Utils.LEFT].Passages[Utils.RIGHT]
		else:
			Cells[nc.MapPos+Utils.LEFT].Passages[Utils.RIGHT]=nc.Passages[Utils.LEFT]
	Cells[nc.MapPos]=nc


## Eliminates "open" passages to nonexisting cells
func CleanInvalidPassages():
	for c in Cells.values():
		for p in c.Passages.keys():
			if c.Passages[p] not in [Utils.PassageType.NONE]:
				if !Cells.has(c.MapPos+p):
					c.Passages[p]=Utils.PassageType.NONE
			if c.Passages[p] == Utils.PassageType.UNDEFINED:
				c.Passages[p]=Utils.PassageType.NONE

func _ready() -> void:
	rand=RandomNumberGenerator.new()
	pass
	
## Sets up the class. Allows for setting the seed of [member rand]
func setup(rseed:int=1337)->void:
	rand.seed=rseed
	PotentialCells.clear()
	Cells.clear()
	pass


## Generates passages for a cell by replacing the UNDEFINED values by value randomly selected based on [member Weigths]
func DefinePassages(weigths:Dictionary,cps:Dictionary={})->Dictionary:
	var pt=[]
	for k in weigths.keys():
		for i in range(weigths[k]):
			pt.push_back(Utils.PassageType.get(k))
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
