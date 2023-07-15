## Base class for Floor architect that first generates a maze and then samples a subset of rooms from it multiple times.
##

class_name BaseSamplerFloorArchitect extends BaseFloorArchitect

@export_category("Maze Generation")
## The width of the generated maze
@export var MazeWidth:int=40
## The height of the generated maze
@export var MazeHeight:int=30
## what fraction of dead end cells are to be converted into loops
@export_range(0.0,1.0) var BraidTreshold:float=0.0

@export_category("Floor Sampling")
## How many cells are to be sampled in the layout
@export var SampleSize:int=9
## Starting room for sampling, default is (-1,-1) which signifies random selection
@export var InitialPosition:Vector2i=Vector2i(-1,-1)
@export_enum("Random","Deep","Wide") var SamplingMode:String="Random"

func PlanFloor()->void:
	SampleFloor()
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
		Cells[pos-InitPos]=PotentialCells[pos].duplicate()
		Cells[pos-InitPos].MapPos-=InitPos
		for p in Cells[pos-InitPos].Passages.keys():
			if !Cells.has(pos-InitPos+p) \
				&& !nextcells.has(pos+p) \
				&& Cells[pos-InitPos].Passages[p]==Utils.PassageType.NORMAL \
				&& PotentialCells.has(pos+p):
				nextcells.push_back(pos+p)
	pass

## Geerates the maze that will be used to sample floor layouts.
## Should be implemented in derived classes
func GenerateMaze()->void:
	pass

func BraidMaze()->void:
	var ends=Utils.GetLeaves(PotentialCells).keys().duplicate()
	var total=ends.size()*1.0
	while ends.size()/total>1-BraidTreshold:
		var i=rand.randi_range(0,ends.size()-1)
		var x=ends.pop_at(i)
		for p in PotentialCells[x].Passages.keys():
			if PotentialCells.has(x+p) && PotentialCells[x].Passages[p]==Utils.PassageType.NONE:
				PotentialCells[x].Passages[p]=Utils.PassageType.NORMAL
				PotentialCells[x+p].Passages[-p]=Utils.PassageType.NORMAL
				if ends.has(x+p):
					ends.pop_at(ends.find(x+p))
				break

## Seeds the [member rand] and calls [member GenerateMaze]
func setup(rseed:int=1337)->void:
	super(rseed)
	GenerateMaze()
	BraidMaze()
	pass
