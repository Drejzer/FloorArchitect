## Node for generating Dungeon floor layouts with self-avoiding random walk
##
## This node generates the general layout of rooms, using self-avoiding random walk.

class_name SelfAvoidingWalkerFloorArchitect extends BaseFloorArchitect

@export var main_path_length:int=9
@export var sideroom_count:int=3
## Bias towards moving in the same direction, the value set is added to the weigth
@export var continuation_bias:int=0

## Direction bias
@export var direction_weigths:={Vector2i(0,-1):4, #Can't use Utils, because then It doesn't appear in the inspector properly
			Vector2i(1,0):4,
			Vector2i(0,1):4,
			Vector2i(-1,0):4,
			}

var _path:=[]

## Function that generates the floor layout
func _plan_floor()->void:
	cells.clear()
	potential_cells.clear()
	_walk()
	_realise_path()
	_make_side_rooms()
	super()

func _walk()->void:
	var d:=_get_next_direction()
	_path.push_back(Vector2i.ZERO)
	var pos=Vector2i.ZERO
	var bad:=[]
	while _path.size()<main_path_length:
		var dirs=direction_weigths.duplicate()
		var newd=_get_next_direction(d)
		while pos+newd in _path || pos+newd in bad:
			dirs.erase(newd)
			if dirs.size()==0:
				pos=_path.back()
				bad.push_back(_path.pop_back())
				break
			newd=_get_next_direction(d,dirs)
		_path.push_back(pos+newd)
		pos=pos+newd
		d=newd
	pass


func _realise_path()->void:
	var current=Utils.create_template_cell(_path.pop_front())
	add_new_cell(current.map_pos,current.passages,false)
	while _path.size()>0:
		var prev=current.map_pos
		current=Utils.create_template_cell(_path.pop_front())
		current.passages[prev-current.map_pos]=Utils.PassageType.NORMAL
		add_new_cell(current.map_pos,current.passages,false)
	

func _make_side_rooms()->void:
	var tmp=direction_weigths.keys()
	var dirs:=[]
	while tmp.size():
		dirs.push_back(tmp.pop_at(rand.randi()%tmp.size()))
	while cells.size()<main_path_length+sideroom_count:
		var r = rand.randi_range(0,cells.size()-2)
		var pos=cells.keys()[r]
		for p in dirs:
			if pos+p not in cells.keys():
				var nc=Utils.create_template_cell(pos+p)
				nc.passages[-p]=Utils.PassageType.NORMAL
				add_new_cell(nc.map_pos,nc.passages,false)
				break
	pass

## Picks next direction to walk in
func _get_next_direction(lastdir:Vector2i=Vector2i.ZERO,dirs:=direction_weigths.duplicate(true))->Vector2i:
	var k=[]
	if lastdir!=Vector2i.ZERO and lastdir in dirs:
		dirs[lastdir]+=continuation_bias
	for i in dirs.keys():
		for x in range(dirs[i]):
			k.push_back(i)
	if lastdir!=Vector2i.ZERO and lastdir in dirs:
		dirs[lastdir]-=continuation_bias
	var i=rand.randi_range(0,k.size()-1)
	return k[i]


## Sets up the class. Allows for setting the seed of [member rand]
func setup(rseed:int=1337)->void:
	super(rseed)
	pass

