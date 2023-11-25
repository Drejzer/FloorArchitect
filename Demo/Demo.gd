extends Node2D

@export var CellScene:PackedScene
@export var architect_seed:=2343772919 #123321

var gen=false

var briges_and_aps:=[]
var dists:={}
	
func _ready() -> void:
	#randomize()
	$FloorArchitect.setup(architect_seed)
	genmap()

func _process(_delta: float) -> void:
	var cdir=Vector2(0,0)
	if Input.is_action_just_released("test"):
		genmap()
	elif Input.is_action_just_released("test2"):
		genmap()
		$FloorArchitect.cells=$FloorArchitect.potential_cells.duplicate(true)
		_on_BaseFloorArchitect_FloorPlanned()
	elif Input.is_action_just_released("display_AP"):
		if gen:
			briges_and_aps=Utils.get_bridges_and_articulation_points($FloorArchitect.cells)
			for i in range(briges_and_aps.size()):
				if briges_and_aps.size()>1:
					print(i,"th disjoint subgraph with origin at ",briges_and_aps[i]["Origin"])
				for c in $map.get_children():
					if c.has_method("set_Content_visibility"):
						c.set_Content_visibility(c.get_node("ContentImage").visible || c.data.map_pos in briges_and_aps[i]["ArticulationPoints"])
						
			var tme=Time.get_ticks_usec()
			dists=Utils.dijkstra_distances($FloorArchitect.cells)
			print(Time.get_ticks_usec()-tme)
	
	cdir.y=-1 if Input.is_action_pressed("c_up") else (1 if Input.is_action_pressed("c_down") else 0) 
	cdir.x=-1 if Input.is_action_pressed("c_left") else (1 if Input.is_action_pressed("c_right") else 0)
	cdir=cdir.normalized()*_delta*1000
	$Camera2D.position+=cdir


func genmap():
	gen=false
	$map.free()
	var m=Node2D.new()
	m.name="map"
	add_child(m,true)
	$FloorArchitect._plan_floor()
	gen=true
	

func _on_BaseFloorArchitect_FloorPlanned() -> void:
	await get_tree().process_frame
	for i in $FloorArchitect.cells:
		var x=CellScene.instantiate()
		x.size_x=64
		x.size_y=64
		await get_tree().process_frame
		x.setup($FloorArchitect.cells[i])
		$map.add_child(x,true)
		await get_tree().process_frame
	pass
