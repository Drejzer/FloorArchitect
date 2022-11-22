extends Node2D

class_name FloorArchitect

var rand:=RandomNumberGenerator.new()

export var minimum_cell_count:int=6
export var maximum_cell_count:int=7
export var path_cull_threshold:int=4
export var loops_allowed:bool=true
export var multicell_rooms_allowed:bool=false

## Dictionary of cells (using CellData class) keyed by position (as 2-element array of ints)
export(Dictionary) var Cells:={}
## The Packed scene that is to be used as a Cell
export(PackedScene) onready var CellScene

var PotentialCells:=[]


func plan_floor()->void:
	var fc:=rand.randi_range(0,4)
	match(fc):
		0:
			_add_cell(0,0,(2|8|32|128))
		1:
			_add_cell(0,0,(0|8|32|128))
		2:
			_add_cell(0,0,(2|0|32|128))
		3:
			_add_cell(0,0,(2|8|0|128))
		4:
			_add_cell(0,0,(2|8|32|0))
		_:
			pass
		
	while Cells.size() < minimum_cell_count && !PotentialCells.empty():
		var i = rand.randi_range(0,PotentialCells.size())
		var nextc:=(PotentialCells[i] as CellData)
	pass


func make_floor()->void:
	pass


func _add_cell(var posx:int,var posy:int,var pflags:int):
	pass

func _ready() -> void:
	pass
	
func setup(var rseed:int)->void:
	rand.seed=rseed
	PotentialCells.clear()
	Cells.clear()
	pass

