extends Node2D

@export var Randomise:bool=false
@export var Seed:int=1337
@export var size:=10

var layout_b_t
var layout_e_t
var dists
var nodes
var bap
var dist_b_t
var dist_e_t
var nodes_b_t
var nodes_e_t
var bap_b_t
var bap_e_t
var diam=0

var output:=FileAccess.open("res://Tests/data/log_RGFA10p3-5_"+Time.get_datetime_string_from_system()+".csv",FileAccess.WRITE)

func _ready() -> void:
	if Randomise:
		randomize()
		Seed=randi()
	$FloorArchitect.setup(Seed)
	var line:="Seed;RoomCount;LeafCount;3CrossCount;4CrossCount;APCount;BridgeCount;Diameter;GenTime;DistTime;BAPTime;NodeTime"
#	print(line)
	output.store_line(line)
	for _j in range(25):
		randomize()
		Seed=randi()
		$FloorArchitect.setup(Seed)
		for _i in range(200):
			layout_b_t=Time.get_ticks_usec()
			$FloorArchitect._plan_floor()
			line="%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d"%[Seed,$FloorArchitect.minimum_room_count,nodes["Leaves"].size(),nodes["3Cross"].size(),nodes["4Cross"].size(),bap[0]["ArticulationPoints"].size(),bap[0]["Bridges"].size(),diam,layout_e_t-layout_b_t,dist_e_t-dist_b_t,bap_e_t-bap_b_t,nodes_e_t-nodes_b_t]
			#print(line)
			output.store_line(line)
			$FloorArchitect.cells.clear()
	get_tree().quit()
	


func _on_floor_architect_floor_planned() -> void:
	layout_e_t=Time.get_ticks_usec()
	nodes_b_t=Time.get_ticks_usec()
	nodes=Utils.get_leaves_and_crossroads($FloorArchitect.cells)
	nodes_e_t=Time.get_ticks_usec()
	bap_b_t=Time.get_ticks_usec()
	bap=Utils.get_bridges_and_articulation_points($FloorArchitect.cells)
	bap_e_t=Time.get_ticks_usec()
	dist_b_t=Time.get_ticks_usec()
	dists=Utils.dijkstra_distances($FloorArchitect.cells)
	dist_e_t=Time.get_ticks_usec()
	for i in dists["DistanceMatrix"]:
		for j in dists["DistanceMatrix"][i]:
			if dists["DistanceMatrix"][i][j]>diam:
				diam=dists["DistanceMatrix"][i][j]
	pass # Replace with function body.
