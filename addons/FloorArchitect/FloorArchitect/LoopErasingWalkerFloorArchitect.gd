## Node for generating Dungeon floor layouts with loop-erased random walk
##
## This node generates the general layout of rooms, using loop-erased random walk.

class_name LoopErasingWalkerFloorArchitect extends BaseFloorArchitect

@export var main_path_length:int=9
@export var sideroom_count:int=3
@export var continuation_bias:int=0

var path:=[]
## DIrection bias
@export var direction_weigths:={Vector2i(0,-1):4, #Can't use Utils, because then It doesn't appear in the inspector properly
			Vector2i(1,0):4,
			Vector2i(0,1):4,
			Vector2i(-1,0):4}
			
## Function that generates the floor layout
func PlanFloor()->void:
	Cells.clear()
	PotentialCells.clear()
	Walk()
	RealizePath()
	MakeSideRooms()
	super()

func Walk()->void:
	var d:=GetNextDirection()
	path.push_back(Vector2i.ZERO)
	var pos=Vector2i.ZERO
	while path.size()<main_path_length:
		while pos+d in path:
			path.pop_back()
		path.push_back(pos+d)
		pos=pos+d
		d=GetNextDirection(d)
	pass


func RealizePath()->void:
	var current=Utils.CreateTemplateCell()
	current.MapPos=path.pop_front()
	AddNewCell(current.MapPos,current.Passages,false)
	while path.size()>0:
		var prev=current.MapPos
		current=Utils.CreateTemplateCell()
		current.MapPos=path.pop_front()
		current.Passages[prev-current.MapPos]=Utils.PassageType.NORMAL
		AddNewCell(current.MapPos,current.Passages,false)
	

func MakeSideRooms()->void:
	var tmp=direction_weigths.keys()
	var dirs:=[]
	while tmp.size():
		dirs.push_back(tmp.pop_at(rand.randi()%tmp.size()))
	while Cells.size()<main_path_length+sideroom_count:
		var r = rand.randi_range(0,Cells.size()-1)
		var pos=Cells.keys()[r]
		for p in dirs:
			if pos+p not in Cells.keys():
				var nc=Utils.CreateTemplateCell()
				nc.MapPos=pos+p
				nc.Passages[-p]=Utils.PassageType.NORMAL
				AddNewCell(nc.MapPos,nc.Passages,false)
				break
	pass

## Picks next direction to walk in
func GetNextDirection(lastdir:Vector2i=Vector2i.ZERO,dirs:=direction_weigths.duplicate(true))->Vector2i:
	var k=[]
	if lastdir!=Vector2i.ZERO:
		dirs[lastdir]+=continuation_bias
	for i in dirs.keys():
		for x in range(dirs[i]):
			k.push_back(i)
	if lastdir!=Vector2i.ZERO:
		dirs[lastdir]-=continuation_bias
	var i=rand.randi_range(0,k.size()-1)
	return k[i]


## Sets up the class. Allows for setting the seed of [member rand]
func setup(rseed:int=1337)->void:
	super(rseed)
	pass

