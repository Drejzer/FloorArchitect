extends Node
enum PassageType {
				UNDEFINED=-1,
				NONE=0,
				NORMAL=1,
				HIDDEN=2,
				CONNECTION=3,
				LOCKED=4
				}
const UP=Vector2i(0,-1)
const RIGHT=Vector2i(1,0)
const DOWN=Vector2i(0,1)
const LEFT=Vector2i(-1,0)


static func _low():
	pass

static func GetDistanceMatrix(map:Dictionary)->Dictionary:
	var pthdict:={}
	
	return pthdict

static func GetBridgesAndArticulationPoints(map:Dictionary)->Dictionary:
	var bapdict:={}
	return bapdict