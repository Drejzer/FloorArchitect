extends Node
class_name Utils

## Describes types of passages (or lack thereof) between adjacent cells.
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

## Generates and returns a dictionary of shortest paths between each cell.
static func GetDistances(map:Dictionary)->Dictionary:
	var pthdict:={}
	#TODO
	return pthdict


## Finds all bridges and articulation points (cut vertices) of the provided map.
static func GetBridgesAndArticulationPoints(map:Dictionary)->Dictionary:
	var dfsd={}
	var parents={}
	for x in map.keys():
		dfsd[x]=-1;
		parents[x]=-1
	var current=map.keys()[0]
	dfsd[current]=0
	parents[current]=null
	
	var traverse =func (y,f):
		print(y)
		var b=true
		for d in map[y].Passages:
			if (map[y].Passages[d] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]) and dfsd[y+d]==-1:
				dfsd[y+d]=dfsd[y]+1
				parents[y+d]=y
				current=y+d
				b=false
				break
		if b:
			current=parents[y]
		if current!=null:
			f.call(current,f)
		
		
	var bapdict:={Bridges={},ArticulationPoints={}}
	var low = func (x):
		print(x)
	#low.call(map)
	traverse.call(Vector2i(0,0),traverse);
	print(parents)
	print(dfsd)
	return bapdict
