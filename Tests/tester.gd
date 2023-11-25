extends Node2D

@export var Randomise:bool=false
@export var Seed:int=1337
@export var size:=10
@export var CellScene:PackedScene

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
var mpe
var mpl=0
var ldmp=0
var admp=0
var mmdmp=0
var maze_b_t
var maze_e_t

const alg = "SelfAvoidingWalker_07mpl03src_0cb"
const rcnt = 100
var cell_heat:={}
var pass_heat:={}
var output:=FileAccess.open("res://Tests/data/"+var_to_str(rcnt)+alg+".csv",FileAccess.WRITE)
#var phm:=FileAccess.open("res://Tests/data/phm_RWFA_100_1wac025l5-t-cb0.json",FileAccess.WRITE)
#var chm:=FileAccess.open("res://Tests/data/chm_RWFA_100_1wac025l5-t-cb0.json",FileAccess.WRITE)

# 10-25-50-100
func _ready() -> void:
	seed(291943)
	
	for x in range(-(rcnt-1),(rcnt),1):
		for y in range(-(rcnt-1),(rcnt),1):
			var p = Vector2i(x,y)
			cell_heat[p]=0
			pass_heat[p]={}
			pass_heat[p][Utils.NORTH]=0
			pass_heat[p][Utils.SOUTH]=0
			pass_heat[p][Utils.EAST]=0
			pass_heat[p][Utils.WEST]=0
		
	$FloorArchitect.setup(Seed)
	var line:="Seed;RoomCount;LeafCount;ConnectorCount;3CrossCount;4CrossCount;APCount;BridgeCount;Diameter;GenTime;DistTime;BAPTime;NodeTime;Algorithm;AvgDistToMPth;MaxDistToMPth;MPthLen"#;MazeTime"
	output.store_line(line)
	for _j in range(5000):
		Seed=randi()
		maze_b_t=Time.get_ticks_usec()
		$FloorArchitect.setup(Seed)
		maze_e_t= Time.get_ticks_usec()
		layout_b_t=Time.get_ticks_usec()
		$FloorArchitect._plan_floor()
		line="%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%d;%s;%f;%d;%d"%[Seed,rcnt,nodes["Leaves"].size(),nodes["Connectors"].size(),nodes["3Cross"].size(),nodes["4Cross"].size(),bap[0]["ArticulationPoints"].size(),bap[0]["Bridges"].size(),diam,layout_e_t-layout_b_t,dist_e_t-dist_b_t,bap_e_t-bap_b_t,nodes_e_t-nodes_b_t,alg,admp,mmdmp,mpl]#,maze_e_t-maze_b_t]
		output.store_line(line)
		for c in $FloorArchitect.cells:
			cell_heat[c]+=1
			if $FloorArchitect.cells[c].passages[Utils.NORTH] == Utils.PassageType.NORMAL:
				pass_heat[c][Utils.NORTH] += 1
			if $FloorArchitect.cells[c].passages[Utils.EAST] == Utils.PassageType.NORMAL:
				pass_heat[c][Utils.EAST] += 1
			if $FloorArchitect.cells[c].passages[Utils.WEST] == Utils.PassageType.NORMAL:
				pass_heat[c][Utils.WEST] += 1
			if $FloorArchitect.cells[c].passages[Utils.SOUTH] == Utils.PassageType.NORMAL:
				pass_heat[c][Utils.SOUTH] += 1
		$FloorArchitect.cells.clear()
		
#	chm.store_string(JSON.stringify(cell_heat))
#	phm.store_string(JSON.stringify(pass_heat))
	
	for i in cell_heat:
		var x=CellScene.instantiate()
		x.size_x=16
		x.size_y=16
		x.setup([i,cell_heat[i]],pass_heat[i])
		$map.add_child(x,true)
	pass
	get_tree().quit()
	

func _process(delta: float) -> void:
	var cdir=Vector2.ZERO
	cdir.y=-1 if Input.is_action_pressed("c_up") else (1 if Input.is_action_pressed("c_down") else 0) 
	cdir.x=-1 if Input.is_action_pressed("c_left") else (1 if Input.is_action_pressed("c_right") else 0)
	cdir=cdir.normalized()*delta*1000
	$Camera2D.position+=cdir

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
	mpl=0
	admp=0
	mmdmp=0
	
	mpe=null
	for i in nodes["Leaves"]:
		if dists["DistanceMatrix"][Vector2i.ZERO][i]>mpl:
			mpl=dists["DistanceMatrix"][Vector2i.ZERO][i]
			mpe=i
	var mp = []
	var step = Vector2i.ZERO
	while(step != mpe && mpe!=null):
		mp.push_back(step)
		step = dists["ParentsLists"][mpe][step]
	if mpe !=null:
		mp.push_back(mpe)
	
	var ccnip=0
	var tmpc=0
	for c in $FloorArchitect.cells:
		if !c in mp:
			ccnip += 1
			var dtp = 9999999
			for i in mp:
				if dists["DistanceMatrix"][c][i]<dtp:
					dtp = dists["DistanceMatrix"][c][i]
			if dtp>mmdmp:
				mmdmp=dtp
			tmpc+=dtp
	
	admp = (tmpc*1.0)/(ccnip*1.0) 
	
	for i in dists["DistanceMatrix"]:
		for j in dists["DistanceMatrix"][i]:
			if dists["DistanceMatrix"][i][j]>diam:
				diam=dists["DistanceMatrix"][i][j]
			
	pass # Replace with function body.
