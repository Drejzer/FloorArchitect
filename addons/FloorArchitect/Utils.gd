## Class declaring static funcions, enums and constants used in the FloorArchitect plugin

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

## Returns a dictionary of Vector2i positions as keys and true boolean values, representing the leaves or dead ends of the level
static func GetLeaves(map:Dictionary)->Dictionary:
	var leaves:={}
	for r in map.keys():
		var c=0
		for p in map[r].Passages:
			if(map[r].Passages[p] not in [Utils.PassageType.UNDEFINED,Utils.PassageType.NONE]):
				c+=1
		if c==1:
			leaves[r]=true
	return leaves

## Generates and returns a dictionary of shortest paths between each cell.[br]
## Expects a Dictionary of [CellData], with [member CellData.MapPos] as keys[br]
## Returns a dictionary with two dictionaries adressed by "DistanceMatrix" and "PathMatrix" respectively.
static func GetShortestPathsAndDistances(map:Dictionary)->Dictionary:
	const inf=9999999999999999 #nothing should be that big and it still is far from an overflow
	var pths:={}
	var dist:={}
	for from in map.keys():
		pths[from]={}
		dist[from]={}
		for to in map.keys():
			if to==from:
				dist[from][to]=0
				pths[from][to]=null
			elif to-from not in map[to].Passages.keys():
				pths[from][to]=null
				dist[from][to]=inf
			elif map[from].Passages[to-from] not in [Utils.PassageType.NONE,Utils.PassageType.UNDEFINED]:
				pths[from][to]=to
				dist[from][to]=1
			else:
				pths[from][to]=null
				dist[from][to]=inf
		pass
	for through in map.keys():
		for from in map.keys():
			for to in map.keys():
				if dist[from][through]<inf and dist[through][to]<inf:
					if dist[from][through]+dist[through][to]<dist[from][to]:
						dist[from][to]=dist[from][through]+dist[through][to]
						pths[from][to]=through
	return {"PathMatrix":pths,"DistanceMatrix":dist}


## Finds all bridges and articulation points (cut vertices) of the provided map.[br]
## Expects a Dictionary of [CellData], with [member CellData.MapPos] as keys.
##
## Returns a dictionary consisting of a pair of dictionaries one adressed "Bridges" and the other adressed "ArticulationPoints"
## 
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
						bapdict.Bridges[[y,y+d]]=[y+d,y]
					if low[y+d]>=dfso[y] and parents[y]!=null:
						bapdict.ArticulationPoints[y]=true
		if parents[y]==null:
			if cc>1:
				bapdict.ArticulationPoints[y]=true
		pass
	
	parents[map.keys()[0]]=null
	traverse.call(map.keys()[0],traverse);
	return bapdict

## Generates a CellData instance at position (0,0) with 4 UNDEFINED passages
static func CreateTemplateCell(pos:Vector2i=Vector2i.ZERO)->CellData:
	var c:=CellData.new()
	c.MapPos=pos
	c.Passages={Utils.UP:Utils.PassageType.UNDEFINED,
			Utils.RIGHT:Utils.PassageType.UNDEFINED,
			Utils.DOWN:Utils.PassageType.UNDEFINED,
			Utils.LEFT:Utils.PassageType.UNDEFINED}
	c.RoomType=0
	return c
