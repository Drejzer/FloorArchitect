## Class declaring static funcions, enums and constants used in the FloorArchitect plugin

extends Node
class_name Utils

## Assumes an array [key,value]
class PriorityQueue:
	var _q:=[]
	func _heapify(pos:int):
		var left=_q[pos*2+1].duplicate() if pos*2+1<_q.size() else [999999,null]
		var right=_q[pos*2+2].duplicate() if pos*2+2<_q.size() else [999999,null]
		var min=left if left[0]<right[0]&&left[0]<_q[pos][0] else (right if right[0]<_q[pos][0]&&right[0]<_q[pos][0] else _q[pos].duplicate())
		if min==left:
			_q[pos*2+1]=_q[pos].duplicate()
			_q[pos]=min
			_heapify(pos*2+1)
		elif min==right:
			_q[pos*2+2]=_q[pos].duplicate()
			_q[pos]=min
			_heapify(pos*2+2)
	func is_empty():
		return _q.is_empty()
	func enqueue(x):
		var i=_q.size()
		_q.push_back(x)
		while i>0&&_q[i][0]<_q[(i-1)/2][0]:
			var tmp=_q[(i-1)/2].duplicate()
			_q[(i-1)/2]=_q[i]
			_q[i]=tmp
			i=(i-1)/2
	func front():
		return _q.front()
	func dequeue():
		var fr=_q.front()
		if _q.size()>1:
			_q[0]=_q.pop_back()
			_heapify(0)
		else :
			_q.pop_back()
		return fr

enum RoomType {
			Start=0,
			Boss=1,
			Encounter=2,
			Challenge=3,
			Treasure=4,
			Shop=5
			}

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
## Returns an array of dictionaries consisting of a pair of dictionaries one adressed "Bridges" and the other adressed "ArticulationPoints"[br]
## If the size of returned array is bigger than 1, the map is not coherent. 
static func GetBridgesAndArticulationPoints(map:Dictionary)->Array:
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
	var result:=[]
	parents[map.keys()[0]]=null
	for k in map.keys():
		if !visited[k]:
			traverse.call(map.keys()[0],traverse);
			result.push_back(bapdict.duplicate(true))
			bapdict.clear()
	return result

## Generates a CellData instance at position (0,0) with 4 UNDEFINED passages
static func CreateTemplateCell(pos:Vector2i=Vector2i.ZERO,defined:bool=false)->CellData:
	var c:=CellData.new()
	c.MapPos=pos
	c.Passages={Utils.UP:Utils.PassageType.NONE,
			Utils.RIGHT:Utils.PassageType.NONE,
			Utils.DOWN:Utils.PassageType.NONE,
			Utils.LEFT:Utils.PassageType.NONE} if defined else {Utils.UP:Utils.PassageType.UNDEFINED,
			Utils.RIGHT:Utils.PassageType.UNDEFINED,
			Utils.DOWN:Utils.PassageType.UNDEFINED,
			Utils.LEFT:Utils.PassageType.UNDEFINED}
	c.CellType=0
	return c
	
static func DijkstraDistance(map:Dictionary)->Dictionary:
	var res:={"DistanceMatrix":{},"ParentsLists":{}}
	for start in map.keys():
		var visited:={}
		var pq:=PriorityQueue.new()
		for p in map.keys():
			visited[p]=false
		res["DistanceMatrix"][start]=map.duplicate(true)
		res["ParentsLists"][start]=map.duplicate(true)
		var working=res["DistanceMatrix"][start]
		var parents=res["ParentsLists"][start]
		pq.enqueue([0,start,null])
		while !pq.is_empty():
			var current=pq.dequeue()
			if current[1]!=null && !visited[current[1]]:
				visited[current[1]]=true
				working[current[1]]=current[0]
				parents[current[1]]=current[2]
				for d in map[current[1]].Passages:
					if map[current[1]].Passages[d] not in [PassageType.NONE,PassageType.UNDEFINED]:
						pq.enqueue([current[0]+1,current[1]+d,current[1]])
		
	return res
