extends Node2D

## Used as representation of passages
signal setup_finished
@export var size_x:int
@export var size_y:int
var weigth:int=0
var passages:={}

func setup(pos,psg) -> void:
	position.x = pos[0].x * size_x
	position.y = pos[0].y * size_y
	weigth=pos[1]
	passages=psg
	set_color()
	configure_walls()
	setup_finished.emit()

func _ready() -> void:
	set_process(false)
	pass

func set_color():
	if weigth<=0:
		$CellImage.modulate = Color(0,0,0,0)
	elif weigth<1000:
		var ci := clampf((weigth*1.0)/1000.0,0.00,1)
		$CellImage.modulate = Color(0,ci,0.275,1)
		#Color(ci,ci,ci,1)
	elif weigth<3000:
		var ci := clampf(((weigth-1000)*1.0)/2000.0,0,1)
		$CellImage.modulate = Color(ci,1,0.275,1)
		#Color(1,1,1-ci,1)
	else:
		var ci := clampf(((weigth-3000)*1.0)/2000.0,0,1)
		$CellImage.modulate = Color(1,1-ci,0.275,1)
		#Color(1,1-ci,0,1)
		

## Sets up the display of the cell's walls
func configure_walls()->void:
	var w
	w = passages[Vector2i(0,-1)]
	if w<=0:
		$Passages/PN.modulate = Color(0,0,0,0)
	elif w<1000:
		var ci := clampf((w*2.0)/1000.0,0,1)
		$Passages/PN.modulate = Color(0,ci,0.275,1)
	elif w<3000:
		var ci := clampf(((w-1000)*2.0)/2000.0,0,1)
		$Passages/PN.modulate = Color(ci,1,0.275,1)
	else:
		var ci := clampf(((w-3000)*2.0)/2000.0,0,1)
		$Passages/PN.modulate = Color(1,1-ci,0.275,1)
	
	w = passages[Vector2i(0,1)]
	if w<=0:
		$Passages/PS.modulate = Color(0,0,0,0)
	elif w<1000:
		var ci := clampf((w*2.0)/1000.0,0,1)
		$Passages/PS.modulate = Color(0,ci,0.275,1)
	elif w<3000:
		var ci := clampf(((w-1000)*2.0)/2000.0,0,1)
		$Passages/PS.modulate = Color(ci,1,0.275,1)
	else:
		var ci := clampf(((w-3000)*2.0)/2000.0,0,1)
		$Passages/PS.modulate = Color(1,1-ci,0.275,1)
	
	w = passages[Vector2i(1,0)]
	if w<=0:
		$Passages/PE.modulate = Color(0,0,0,0)
	elif w<1000:
		var ci := clampf((w*2.0)/1000.0,0,1)
		$Passages/PE.modulate = Color(0,ci,0.275,1)
	elif w<3000:
		var ci := clampf(((w-1000)*2.0)/2000.0,0,1)
		$Passages/PE.modulate = Color(ci,1,0.275,1)
	else:
		var ci := clampf(((w-3000)*2.0)/2000.0,0,1)
		$Passages/PE.modulate = Color(1,1-ci,0.275,1)
		
	w = passages[Vector2i(-1,0)]
	if w<=0:
		$Passages/PW.modulate = Color(0,0,0,0)
	elif w<1000:
		var ci := clampf((w*2.0)/1000.0,0,1)
		$Passages/PW.modulate = Color(0,ci,0.275,1)
	elif w<3000:
		var ci := clampf(((w-1000)*2.0)/2000.0,0,1)
		$Passages/PW.modulate = Color(ci,1,0.275,1)
	else:
		var ci := clampf(((w-3000)*2.0)/2000.0,0,1)
		$Passages/PW.modulate = Color(1,1-ci,0.275,1)
	pass
