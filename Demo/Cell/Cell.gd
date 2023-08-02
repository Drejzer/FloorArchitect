extends Node2D

## Used as representation of passages
signal setup_finished
@export var size_x:int
@export var size_y:int
var data:CellData=CellData.new()

func setup(d:CellData) -> void:
	data.passages=d.passages
	data.map_pos=d.map_pos
	data.cell_type=d.cell_type
	configure_walls()
	position=Vector2(data.map_pos.x*size_x,data.map_pos.y*size_y)
	setup_finished.emit()
	

func _ready() -> void:
	set_process(false)
	configure_walls()
	pass # Replace with function body.

## Sets up the display of the cell's walls
func configure_walls()->void:
	match(data.passages[Utils.NORTH]):
		Utils.PassageType.NONE,Utils.PassageType.HIDDEN:
			$Passages/PN/Sprite.visible=true
			$Passages/PN/Sprite2.visible=false
			$Passages/PN/Sprite3.visible=false
		Utils.PassageType.LOCKED:
			$Passages/PN/Sprite.visible=false
			$Passages/PN/Sprite2.visible=true
			$Passages/PN/Sprite3.visible=false
		Utils.PassageType.NORMAL:
			$Passages/PN/Sprite.visible=false
			$Passages/PN/Sprite2.visible=false
			$Passages/PN/Sprite3.visible=true
		Utils.PassageType.CONNECTION:
			$Passages/PN/Sprite.visible=false
			$Passages/PN/Sprite2.visible=false
			$Passages/PN/Sprite3.visible=false
		_:
			$Passages/PN/Sprite.visible=true
			$Passages/PN/Sprite2.visible=false
			$Passages/PN/Sprite3.visible=false
			$Passages/PN.rotation+=1
			
	match(data.passages[Utils.EAST]):
		Utils.PassageType.NONE,Utils.PassageType.HIDDEN:
			$Passages/PE/Sprite.visible=true
			$Passages/PE/Sprite2.visible=false
			$Passages/PE/Sprite3.visible=false
		Utils.PassageType.LOCKED:
			$Passages/PE/Sprite.visible=false
			$Passages/PE/Sprite2.visible=true
			$Passages/PE/Sprite3.visible=false
		Utils.PassageType.NORMAL:
			$Passages/PE/Sprite.visible=false
			$Passages/PE/Sprite2.visible=false
			$Passages/PE/Sprite3.visible=true
		Utils.PassageType.CONNECTION:
			$Passages/PE/Sprite.visible=false
			$Passages/PE/Sprite2.visible=false
			$Passages/PE/Sprite3.visible=false
		_:
			$Passages/PE.rotation+=1
			$Passages/PE/Sprite.visible=true
			$Passages/PE/Sprite2.visible=false
			$Passages/PE/Sprite3.visible=false
			
	match(data.passages[Utils.SOUTH]):
		Utils.PassageType.NONE,Utils.PassageType.HIDDEN:
			$Passages/PS/Sprite.visible=true
			$Passages/PS/Sprite2.visible=false
			$Passages/PS/Sprite3.visible=false
		Utils.PassageType.LOCKED:
			$Passages/PS/Sprite.visible=false
			$Passages/PS/Sprite2.visible=true
			$Passages/PS/Sprite3.visible=false
		Utils.PassageType.NORMAL:
			$Passages/PS/Sprite.visible=false
			$Passages/PS/Sprite2.visible=false
			$Passages/PS/Sprite3.visible=true
		Utils.PassageType.CONNECTION:
			$Passages/PS/Sprite.visible=false
			$Passages/PS/Sprite2.visible=false
			$Passages/PS/Sprite3.visible=false
		_:
			$Passages/PS.rotation+=1
			$Passages/PS/Sprite.visible=true
			$Passages/PS/Sprite2.visible=false
			$Passages/PS/Sprite3.visible=false
			
	match(data.passages[Utils.WEST]):
		Utils.PassageType.NONE,Utils.PassageType.HIDDEN:
			$Passages/PW/Sprite.visible=true
			$Passages/PW/Sprite2.visible=false
			$Passages/PW/Sprite3.visible=false
		Utils.PassageType.LOCKED:
			$Passages/PW/Sprite.visible=false
			$Passages/PW/Sprite2.visible=true
			$Passages/PW/Sprite3.visible=false
		Utils.PassageType.NORMAL:
			$Passages/PW/Sprite.visible=false
			$Passages/PW/Sprite2.visible=false
			$Passages/PW/Sprite3.visible=true
		Utils.PassageType.CONNECTION:
			$Passages/PW/Sprite.visible=false
			$Passages/PW/Sprite3.visible=false
			$Passages/PW/Sprite2.visible=false
		_:
			$Passages/PW.rotation+=1
			$Passages/PW/Sprite.visible=true
			$Passages/PW/Sprite2.visible=false
			$Passages/PW/Sprite3.visible=false
	pass

func set_Content_visibility(isap:bool)->void:
	$ContentImage.visible=isap;
	pass
