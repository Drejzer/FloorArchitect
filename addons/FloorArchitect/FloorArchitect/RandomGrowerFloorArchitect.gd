## Node for generating Dungeon floor layouts
##
## This node generates the general layout of rooms. The algorithm is based on the one used in Binding of Isaac.

class_name RandomGrowerFloorArchitect extends BaseFloorArchitect

@export var minimum_room_count:int=9
@export var maximum_room_count:int=17

## Function that generates the floor layout
func PlanFloor()->void:
	Cells.clear()
	PotentialCells.clear()
	var init = Utils.CreateTemplateCell()
	PotentialCells[init.MapPos]=init
	while Cells.size() < maximum_room_count && !PotentialCells.is_empty():
		if !PotentialCells.is_empty():
			var nextc=GetNextCell()
			RealizeCell(nextc)
		while PotentialCells.is_empty():
			EnforceMinimum()
			if Cells.size()>=minimum_room_count:
				break
	super()

## Picks next cell to be added from [member PotentialCells]
func GetNextCell()->CellData:
	var k=PotentialCells.keys()
	var i=rand.randi_range(0,k.size()-1)
	return PotentialCells[k[i]]

## Moves a cell from [member PotentialCells] to [member Cells]
##
## Removes the selected cell from [member PotentialCells], randomises it's passages while respecting existing cells, and adds it to [member Cells]. 
## Additionally adds to [member PotentialCells] according to the now defined passages
func RealizeCell(nc:CellData):
	var psgs=DefinePassages(Weigths,nc.Passages)
	nc.Passages=psgs
	if !Cells.has(nc.MapPos+Utils.UP):
		if nc.Passages[Utils.UP] not in [Utils.PassageType.NONE] \
		and Cells.size()+PotentialCells.size()<=maximum_room_count:
			var pc:CellData=PotentialCells[nc.MapPos+Utils.UP] if PotentialCells.has(nc.MapPos+Utils.UP) else Utils.CreateTemplateCell(nc.MapPos+Utils.UP)
			pc.Passages[Utils.DOWN]=nc.Passages[Utils.UP]
			PotentialCells[pc.MapPos]=pc
	else:
		nc.Passages[Utils.UP]=Cells[nc.MapPos+Utils.UP].Passages[Utils.DOWN]
		
	if !Cells.has(nc.MapPos+Utils.RIGHT):
		if  nc.Passages[Utils.RIGHT] not in [Utils.PassageType.NONE] \
		and Cells.size()+PotentialCells.size()<=maximum_room_count:
			var pc:CellData=PotentialCells[nc.MapPos+Utils.RIGHT] if PotentialCells.has(nc.MapPos+Utils.RIGHT) else Utils.CreateTemplateCell(nc.MapPos+Utils.RIGHT)
			pc.Passages[Utils.LEFT]=nc.Passages[Utils.RIGHT]
			PotentialCells[pc.MapPos]=pc
	else:
		nc.Passages[Utils.RIGHT]=Cells[nc.MapPos+Utils.RIGHT].Passages[Utils.LEFT]
		
	if !Cells.has(nc.MapPos+Utils.DOWN):
		if nc.Passages[Utils.DOWN] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED] \
		and Cells.size()+PotentialCells.size()<=maximum_room_count:
			var pc:CellData=PotentialCells[nc.MapPos+Utils.DOWN] if PotentialCells.has(nc.MapPos+Utils.DOWN) else Utils.CreateTemplateCell(nc.MapPos+Utils.DOWN)
			pc.Passages[Utils.UP]=nc.Passages[Utils.DOWN]
			PotentialCells[pc.MapPos]=pc
	else:
		nc.Passages[Utils.DOWN]=Cells[nc.MapPos+Utils.DOWN].Passages[Utils.UP]
		
	if !Cells.has(nc.MapPos+Utils.LEFT):
		if nc.Passages[Utils.LEFT] not in [Utils.PassageType.NONE] \
		and Cells.size()+PotentialCells.size()<=maximum_room_count:
			var pc:CellData=PotentialCells[nc.MapPos+Utils.LEFT] if PotentialCells.has(nc.MapPos+Utils.LEFT) else Utils.CreateTemplateCell(nc.MapPos+Utils.LEFT)
			pc.Passages[Utils.RIGHT]=nc.Passages[Utils.LEFT]
			PotentialCells[pc.MapPos]=pc
	else:
		nc.Passages[Utils.LEFT]=Cells[nc.MapPos+Utils.LEFT].Passages[Utils.RIGHT]
			
	Cells[nc.MapPos]=nc
	PotentialCells.erase(nc.MapPos)

## Forcefully adds additional room, if the minimum has not been reached
func EnforceMinimum()->void:
	var tmp2:=Cells.keys()
	var tmp:=[]
	while tmp2.size():
		tmp.push_back(tmp2.pop_at(rand.randi()%tmp2.size()))
	var psg=DefinePassages(Weigths)
	for i in tmp:
		if Cells[i].Passages[Utils.UP] == Utils.PassageType.NONE && !Cells.has(i+Utils.UP):
			psg[Utils.DOWN]=Utils.PassageType.NORMAL
			AddNewCell(i+Utils.UP,psg)
			return
		elif Cells[i].Passages[Utils.RIGHT] == Utils.PassageType.NONE && !Cells.has(i+Utils.RIGHT):
			psg[Utils.LEFT]=Utils.PassageType.NORMAL
			AddNewCell(i+Utils.RIGHT,psg)
			return
		elif Cells[i].Passages[Utils.DOWN] == Utils.PassageType.NONE && !Cells.has(i+Utils.DOWN):
			psg[Utils.UP]=Utils.PassageType.NORMAL
			AddNewCell(i+Utils.DOWN,psg)
			return 
		elif Cells[i].Passages[Utils.LEFT] == Utils.PassageType.NONE && !Cells.has(i+Utils.LEFT):
			psg[Utils.RIGHT]=Utils.PassageType.NORMAL
			AddNewCell(i+Utils.LEFT,psg)
			return
	

## Sets up the class. Allows for setting the seed of [member rand]
func setup(rseed:int=1337)->void:
	super(rseed)
	pass

