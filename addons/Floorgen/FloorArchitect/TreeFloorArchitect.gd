extends BaseFloorArchitect

class_name TreeFloorArchitect

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var Visited:=[]

func GetNextCell()->CellData:
	return CreateTemplateCell()
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


