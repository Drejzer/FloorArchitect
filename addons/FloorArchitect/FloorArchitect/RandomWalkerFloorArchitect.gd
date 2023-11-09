## Node for generating Dungeon floor layouts
##
## This node generates the general layout of rooms. Implements Random Walker / Drunkard's Walk algorithm.

class_name RandomWalkerFloorArchitect extends BaseFloorArchitect

@export var room_count : int = 10
@export var walker_count : int = 1
@export var walker_lifespan:int=-1
@export var continuation_bias:int=0
@export var allow_loops:=false

@export_range(0.0,1.0) var additional_walker_chance:float=0.0
@export var additional_walker_lifespan:int=5

## Direction bias
@export var direction_weigths:={Vector2i(0,-1):4, #Can't use Utils, because then It doesn't appear in the inspector properly
			Vector2i(1,0):4,
			Vector2i(0,1):4,
			Vector2i(-1,0):4,
			}


## Function that generates the floor layout
func _plan_floor()->void:
	var walkers:=[]
	cells.clear()
	potential_cells.clear()
	for _i in range(walker_count):
		walkers.append([Vector2i.ZERO,Vector2i.ZERO,walker_lifespan if walker_lifespan!=-1 else null,false])
	var init = Utils.create_template_cell()
	potential_cells[init.map_pos]=init
	var to_erase:=[]
	while cells.size() < room_count:
		var nv=[]
		if to_erase.size() >0:
			for i in walkers.size():
				if i not in to_erase:
					nv.append(walkers[i])
				elif walkers[i][3]==false:
					nv.append([cells.keys()[rand.randi_range(0,cells.keys().size()-1)],Vector2i.ZERO,walker_lifespan if walker_lifespan!=-1 else null,false])
			walkers=nv.duplicate(true)
			to_erase.clear() 
		if rand.randf()<additional_walker_chance:
			walkers.append([cells.keys()[rand.randi_range(0,cells.keys().size()-1)] if cells.size()>0 else Vector2i.ZERO,Vector2i.ZERO,additional_walker_lifespan if additional_walker_lifespan!=-1 else null,true])
		for i in walkers.size():
			if cells.size() < room_count:
				if !(walkers[i][0] in cells.keys()):
					var nc=Utils.create_template_cell(walkers[i][0],false)
					cells[walkers[i][0]]=nc
					if walkers[i][1] != Vector2i.ZERO:
						cells[walkers[i][0]-walkers[i][1]].passages[walkers[i][1]]=Utils.PassageType.NORMAL
						cells[walkers[i][0]].passages[-walkers[i][1]]=Utils.PassageType.NORMAL
				elif walkers[i][1] != Vector2i.ZERO && allow_loops:
						cells[walkers[i][0]-walkers[i][1]].passages[walkers[i][1]]=Utils.PassageType.NORMAL
						cells[walkers[i][0]].passages[-walkers[i][1]]=Utils.PassageType.NORMAL
				var d = _get_next_direction(walkers[i][1],direction_weigths.duplicate(true))
				walkers[i][0]=walkers[i][0]+d
				walkers[i][1]=d
				if walkers[i][2] != null:
					walkers[i][2]-=1
					if walkers[i][2]<1:
						to_erase.append(i)
	super()

## Picks next direction to walk in
func _get_next_direction(lastdir:Vector2i=Vector2i.ZERO,dirs:=direction_weigths.duplicate(true))->Vector2i:
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

