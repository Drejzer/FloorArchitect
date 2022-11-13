extends Node2D

## use as representation of passages
export(int,FLAGS,"NORTH1","NORTH2","EAST1","EAST2","SOUTH1","SOUTH2", "WEST1","WEST2") var PassFlags:int

func _setup(var p:int) -> void:
	PassFlags=p

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
