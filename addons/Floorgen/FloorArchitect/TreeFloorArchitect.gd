extends BaseFloorArchitect

class_name TreeFloorArchitect

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
@export_enum(DFS,BFS)

var Visited:=[]

func GetNextCell()->CellData:
	

func AddCell(nc):

## Selcts cells using DFS
func DepthFirst_cell_addition()->void:
	pass

func BreadthFirst_cell_addition()->void:
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


