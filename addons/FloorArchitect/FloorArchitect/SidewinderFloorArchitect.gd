## Floor architect that first generates a maze using Sidewinder Algorithm and then samples a subset of rooms from it multiple times
##
## test.

class_name SidewinderFloorArchitect extends BaseFloorArchitect

@export_category("Maze Generation")
## The width of the generated maze
@export var MazeWidth:int=40
## The height of the generated maze
@export var MazeHeight:int=30
## what fraction of dead end cells are to be converted into loops
@export_range(0.0,1.0) var BraidTreshold:float=0.0
## The probability of ending the "run" of cells in the algorithm
@export_range(0.0,1.0) var EndRunProbablility:float=0.5

@export_category("Floor Sampling")
## How many cells are to be sampled in the layout
@export var SampleSize:int=9
## Starting room for sampling, default is (-1,-1) which signifies random selection
@export var InitialPosition:Vector2i=Vector2i(-1,-1)
@export_enum("Random","Deep","Wide") var SamplingMode:String="Random"

func PlanFloor()->void:
	SampleFloor()
	if Input.is_key_pressed(KEY_DELETE):
		Cells=PotentialCells.duplicate(true)
	super()

func SampleFloor()->void:
	Cells.clear()
	var nextcells:=[]
	var InitPos:Vector2i
	if InitialPosition==Vector2i(-1,-1):
		var x:=rand.randi_range(0,MazeWidth-1)
		var y:=rand.randi_range(0,MazeHeight-1)
		InitPos=Vector2i(x,y)
	nextcells.push_back(InitPos)
	while Cells.size()<SampleSize:
		if nextcells.is_empty():
			print("Sampled Full Maze")
			break
		var pos=(nextcells.pop_front() if SamplingMode == "Wide" else (nextcells.pop_back() if SamplingMode=="Deep" else nextcells.pop_at(rand.randi()%nextcells.size())))
		Cells[pos-InitPos]=Utils.DuplicateCell(PotentialCells[pos])
		Cells[pos-InitPos].MapPos-=InitPos
		for p in Cells[pos-InitPos].Passages.keys():
			if !Cells.has(pos-InitPos+p) \
				&& !nextcells.has(pos+p) \
				&& Cells[pos-InitPos].Passages[p]==Utils.PassageType.NORMAL \
				&& PotentialCells.has(pos+p):
				nextcells.push_back(pos+p)
	pass

## Geerates the maze that will be used to sample floor layouts.
func GenerateMaze()->void:
	var run:=[]
	for y in range(MazeHeight):
		for x in range(MazeWidth):
			var nc:=Utils.CreateTemplateCell()
			nc.MapPos=Vector2i(x,y)
			if run.is_empty():
				nc.Passages[Utils.LEFT]=Utils.PassageType.NONE
			else:
				nc.Passages[Utils.LEFT]=Utils.PassageType.NORMAL
			if PotentialCells.has(nc.MapPos+Utils.UP):
				nc.Passages[Utils.UP]=PotentialCells[nc.MapPos+Utils.UP].Passages[Utils.DOWN]
			else:
				nc.Passages[Utils.UP]=Utils.PassageType.NONE
			var toend:=rand.randf()<EndRunProbablility
			run.push_back(nc.MapPos)
			if toend && y!=MazeHeight-1:
				nc.Passages[Utils.RIGHT]=Utils.PassageType.NONE
				PotentialCells[nc.MapPos]=nc
				var r=rand.randi_range(0,run.size()-1)
				for i in run:
					PotentialCells[i].Passages[Utils.DOWN]=Utils.PassageType.NORMAL if i==run[r] else Utils.PassageType.NONE 
				run.clear()
			else:
				nc.Passages[Utils.RIGHT]=Utils.PassageType.NORMAL
				PotentialCells[nc.MapPos]=nc
		
		if !run.is_empty():
			var r=rand.randi_range(0,run.size()-1)
			for i in run:
				PotentialCells[i].Passages[Utils.DOWN]=Utils.PassageType.NORMAL if i==run[r] else Utils.PassageType.NONE 
			run.clear()
		
		

## Seeds the [member rand] and calls [member GenerateMaze]
func setup(rseed:int=1337)->void:
	super(rseed)
	GenerateMaze()
	pass
