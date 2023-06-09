class_name SidewinderFloorArchitect extends BaseFloorArchitect

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

@export var MazeWidth:int=40
@export var MazeHeight:int=30

var Visited:=[]

func GetNextCell()->CellData:
	return CreateTemplateCell()


## Geerates the maze that will be used to generate levels.
func GenerateMaze()->void:
	pass
