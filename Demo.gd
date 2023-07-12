extends Node2D

@export var CellScene:PackedScene

var gen=false

var briges_and_aps:={}
var dists:={}
	
func _ready() -> void:
	#randomize()
	$FloorArchitect.setup(1337)
	genmap()
			
func _process(_delta: float) -> void:
	var cdir=Vector2(0,0)
	if Input.is_action_just_released("test"):
			genmap()
	elif Input.is_action_just_released("display_AP"):
		if gen:
			briges_and_aps=Utils.GetBridgesAndArticulationPoints($FloorArchitect.Cells)
			for c in $map.get_children():
				if c.has_method("set_Content_visibility"):
					c.set_Content_visibility(c.Data.MapPos in briges_and_aps["ArticulationPoints"])
			dists=Utils.GetShortestPathsAndDistances($FloorArchitect.Cells)

	
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
	$FloorArchitect.PlanFloor()
	gen=true
	

func _on_BaseFloorArchitect_FloorPlanned() -> void:
	await get_tree().process_frame
	for i in $FloorArchitect.Cells:
			var x=CellScene.instantiate()
			x.Size_x=64
			x.Size_y=64
			x.setup($FloorArchitect.Cells[i])
			$map.add_child(x,true)
	pass
