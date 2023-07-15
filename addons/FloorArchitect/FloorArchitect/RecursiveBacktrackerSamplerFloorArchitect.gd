## Floor architect that first generates a maze using Prim's Algorithm and then samples a subset of rooms from it multiple times
class_name RecursiveBacktrackerSamplerFloorArchitect extends BaseSamplerFloorArchitect

## Geerates the maze that will be used to sample floor layouts.
func GenerateMaze()->void:
	var stack:=[]
	var dirs:=[Utils.UP,Utils.RIGHT,Utils.DOWN,Utils.LEFT]
	stack.push_front([Vector2i.ZERO,dirs.duplicate(true)])
	PotentialCells[Vector2i.ZERO]=Utils.CreateTemplateCell(Vector2i.ZERO,true)
	while !stack.is_empty():
		if stack.front()[1].is_empty():
			stack.pop_front()
		else:
			var current=stack.front()[0]+stack.front()[1].pop_at(rand.randi_range(0,stack.front()[1].size()-1))
			if !(PotentialCells.has(current) \
					|| current.x<0 \
					|| current.x>=MazeWidth \
					|| current.y<0 \
					|| current.y>=MazeHeight):
				PotentialCells[stack.front()[0]].Passages[current-stack.front()[0]]=Utils.PassageType.NORMAL
				var nc:=Utils.CreateTemplateCell(current,true)
				nc.Passages[stack.front()[0]-current]=Utils.PassageType.NORMAL
				PotentialCells[current]=nc
				stack.push_front([current,dirs.duplicate(true)])

