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
## Vector pointing UP, used to identify exits from a cell
const UP=Vector2i(0,-1)
## Vector pointing RIGHT, used to identify exits from a cell
const RIGHT=Vector2i(1,0)
## Vector pointing DOWN, used to identify exits from a cell
const DOWN=Vector2i(0,1)
## Vector pointing LEFTt, used to identify exits from a cell
const LEFT=Vector2i(-1,0)

## Generates and returns a dictionary of shortest paths between each cell.
static func GetDistances(map:Dictionary)->Dictionary:
	var pthdict:={}
	#TODO
	return pthdict


## Finds all bridges and articulation points (cut vertices) of the provided map.
static func GetBridgesAndArticulationPoints(map:Dictionary)->Dictionary:
	var bapdict:={"Bridges":{},"ArticulationPoints":{}}
	var time:=[0]
	var dfso:={}
	var parents:={}
	var low:={}
	var visited:={}
	
	for x in map.keys():
		dfso[x]=-1
		parents[x]=null
		low[x]=-1
		visited[x]=false
	
	var traverse:=func (y,f)->void:
		time[0]+=1
		visited[y]=true
		dfso[y]=time[0]
		low[y]=time[0]
		var cc:=0
		for d in map[y].Passages:
			if (map[y].Passages[d] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]):
				if parents[y]==y+d:
					continue
				if visited[y+d]:
					low[y]=min(low[y],dfso[y+d])
				else:
					cc+=1
					parents[y+d]=y
					f.call(y+d,f)
					low[y]=min(low[y],low[y+d])
					if low[y+d]==dfso[y+d]:
						bapdict.Bridges[[y,y+d]]=true
					if low[y+d]>=dfso[y] and parents[y]!=null:
						bapdict.ArticulationPoints[y]=true
		if parents[y]==null:
			if cc>1:
				bapdict.ArticulationPoints[y]=true
		pass
	
	parents[map.keys()[0]]=null
	traverse.call(map.keys()[0],traverse);
	return bapdict
