extends Node2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
@export @onready var CellScene:PackedScene

func _ready() -> void:
	randomize()
	$FloorArchitect.setup(randi())
# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_released("test"):
		while $map.get_child_count()>0:
			$map.get_child(0).free()
		$FloorArchitect.Cells.clear()
		$FloorArchitect.PotentialCells.clear()	
		$FloorArchitect.plan_floor()



func _on_BaseFloorArchitect_FloorPlanned() -> void:
	for i in $FloorArchitect.Cells:
			var x=CellScene.instantiate()
			x.Size_x=64
			x.Size_y=64
			x.setup($FloorArchitect.Cells[i])
			x.position=Vector2(x.Data.MapPos_x*x.Size_x,x.Data.MapPos_y*x.Size_y)
			$map.add_child(x)
	pass # Replace with function body.