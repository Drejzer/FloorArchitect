extends Node2D

class_name FloorArchitect

var defs=preload("res://addons/Floorgen/defs.gd").new()

export(Dictionary) var Cells
## The Packed scene that is to be used as a Cell
export(PackedScene) var CellScene

var CellSlots:=[]

func _add_cell(var pos_x,var pos_y):
	
	pass

func _ready() -> void:
	pass
