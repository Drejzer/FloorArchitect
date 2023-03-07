extends Node
class_name Utils
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


static func GetDistanceMatrix(map:Dictionary)->Dictionary:
	var pthdict:={}
	return pthdict

static func GetBridgesAndArticulationPoints(map:Dictionary)->Dictionary:
	var dfsd={}
	for x in map.keys():
		dfsd[x]=-1;
	dfsd[map.keys()[0]]=0
	var bapdict:={Bridges={},ArticulationPoints={}}
	var low = func (x):
		print(x)
	low.call(map)
	return bapdict
