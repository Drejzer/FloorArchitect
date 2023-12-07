## Node for generating Dungeon floor layouts
##
## This node generates the general layout of rooms.

class_name PlaceAndConnectFloorArchitect extends BaseFloorArchitect

@export var room_count:int=9

@export var additional_passages:int=0

## Function that generates the floor layout
func plan_floor()->void:
	cells.clear()
	_place_rooms()
	_connect_rooms()
	super()

func _place_rooms()->void:
	var pot_places:=[Vector2i.ZERO]
	while cells.size()<room_count:
		var p = pot_places.pop_at(rand.randi_range(0,pot_places.size()-1))
		if !cells.has(p):
			var nc=Utils.create_template_cell(p)
			cells[p]=nc
			for ps in nc.passages.keys():
				if !cells.has(p+ps):
					pot_places.push_back(p+ps)
	
func _connect_rooms()->void:
	var cells_by_set:={}
	var set_by_cell:={}
	var pairs:=[]
	var loops:=[]
	
	var merge:=func(a,b):
		var sb=set_by_cell[b]
		var sa=set_by_cell[a]
		if set_by_cell[a]<set_by_cell[b]:
			for i in cells_by_set[sb]:
				set_by_cell[i]=sa
			cells_by_set[sa]+=cells_by_set[sb]
			cells_by_set.erase(sb)
			cells[b].passages[a-b]=Utils.PassageType.NORMAL
			cells[a].passages[b-a]=Utils.PassageType.NORMAL
		elif set_by_cell[a]>set_by_cell[b]:
			for i in cells_by_set[sb]:
				set_by_cell[i]=sa
			cells_by_set[sa]+=cells_by_set[sb]
			cells_by_set.erase(sb)
			cells[a].passages[b-a]=Utils.PassageType.NORMAL
			cells[b].passages[a-b]=Utils.PassageType.NORMAL
		else :
			loops.push_back([a,b])
	var count=0
	for x in cells.keys():
		cells_by_set[count]=[x]
		set_by_cell[x]=count
		count+=1
		if cells.has(x+Utils.NORTH):
			pairs.push_back([x,x+Utils.NORTH])
		if cells.has(x+Utils.WEST):
			pairs.push_back([x,x+Utils.WEST])
	
	while cells_by_set.size()>1:
		var p:=pairs.pop_at(rand.randi_range(0,pairs.size()-1))
		merge.call(p[0],p[1])
	loops+=pairs
	for _i in range(additional_passages):
		if !loops.is_empty():
			var p:=loops.pop_at(rand.randi_range(0,loops.size()-1))
			cells[p[0]].passages[p[1]-p[0]]=Utils.PassageType.NORMAL
			cells[p[1]].passages[p[0]-p[1]]=Utils.PassageType.NORMAL
