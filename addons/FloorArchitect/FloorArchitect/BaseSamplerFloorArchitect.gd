## Base class for Floor architect that first generates a maze and then samples a subset of rooms from it multiple times.
##

class_name BaseSamplerFloorArchitect extends BaseFloorArchitect

@export_category("Maze Generation")
## The width of the generated maze
@export var maze_width:int=40
## The height of the generated maze
@export var maze_height:int=30
## what fraction of dead end cells are to be converted into loops
@export_range(0.0,1.0) var braid_treshold:float=0.0

@export_category("Floor Sampling")
## How many cells are to be sampled in the layout
@export var sample_size:int=9
## Starting room for sampling, default is (-1,-1) which signifies random selection
@export var initial_position:Vector2i=Vector2i(-1,-1)
@export_enum("Random","Deep","Wide") var sampling_mode:String="Random"

func plan_floor()->void:
	sample_floor()
	super()

func sample_floor()->void:
	cells.clear()
	var nextcells:=[]
	var init_pos:Vector2i
	if initial_position==Vector2i(-1,-1):
		var x:=rand.randi_range(0,maze_width-1)
		var y:=rand.randi_range(0,maze_height-1)
		init_pos=Vector2i(x,y)
	nextcells.push_back(init_pos)
	while cells.size()<sample_size:
		if nextcells.is_empty():
			#print("Sampled Full Maze")
			break
		var pos=(nextcells.pop_front() if sampling_mode == "Wide" 
				else nextcells.pop_back() if sampling_mode=="Deep" 
				else nextcells.pop_at(rand.randi()%nextcells.size()))
		cells[pos-init_pos]=potential_cells[pos].duplicate()
		cells[pos-init_pos].map_pos-=init_pos
		for p in cells[pos-init_pos].passages.keys():
			if (!cells.has(pos-init_pos+p)
					and !nextcells.has(pos+p)
					and cells[pos-init_pos].passages[p]==Utils.PassageType.NORMAL
					and potential_cells.has(pos+p)):
				nextcells.push_back(pos+p)
	pass

## "Virtual" function for generating the maze that will be used to sample floor layouts.
## Should be implemented in derived classes.
func _generate_maze()->void:
	pass

func braid_maze()->void:
	var ends=Utils.get_leaves_and_crossroads(potential_cells)["Leaves"].keys().duplicate()
	var total=ends.size()*1.0
	while ends.size()/total>1-braid_treshold:
		var i=rand.randi_range(0,ends.size()-1)
		var x=ends.pop_at(i)
		for p in potential_cells[x].passages.keys():
			if potential_cells.has(x+p) && potential_cells[x].passages[p]==Utils.PassageType.NONE:
				potential_cells[x].passages[p]=Utils.PassageType.NORMAL
				potential_cells[x+p].passages[-p]=Utils.PassageType.NORMAL
				if ends.has(x+p):
					ends.pop_at(ends.find(x+p))
				break

## Seeds the [member rand] and calls [member GenerateMaze]
func setup(rseed:int=1337)->void:
	super(rseed)
	_generate_maze()
	braid_maze()
	pass
