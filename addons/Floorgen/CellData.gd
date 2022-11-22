extends Reference

class_name CellData

export(int,FLAGS,"NORTH1","NORTH2","EAST1","EAST2","SOUTH1","SOUTH2", "WEST1","WEST2") var PassFlags:int
export(int,FLAGS,"NORTH1","NORTH2","EAST1","EAST2","SOUTH1","SOUTH2", "WEST1","WEST2") var ReqPassFlags:int
export var size_x:int
export var size_y:int
export var content_id:int
export var map_pos_x:int
export var map_pos_y:int

func make_template()->CellData:
	var cd:CellData
	cd.size_x=size_x
	cd.size_y=size_y
	return cd

