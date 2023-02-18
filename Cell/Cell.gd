extends Node2D

## Used as representation of passages
var Data:CellData=CellData.new()
signal SetupFinished
@export var Size_x:int
@export var Size_y:int

func setup(d:CellData) -> void:
	Data.Passages=d.Passages
	Data.MapPos=d.MapPos
	Data.RoomType=d.RoomType
	configure_walls()
	position=Vector2(Data.MapPos.x*Size_x,Data.MapPos.y*Size_y)
	emit_signal("SetupFinished")
	

func _ready() -> void:
	set_process(false)
	configure_walls()
	pass # Replace with function body.

## Sets up the display of 
func configure_walls()->void:
	match(Data.Passages[Defs.UP]):
		Defs.PassageType.NONE,Defs.PassageType.HIDDEN:
			$Passages/PN/Sprite.visible=true
			$Passages/PN/Sprite2.visible=false
			$Passages/PN/Sprite3.visible=false
		Defs.PassageType.LOCKED:
			$Passages/PN/Sprite.visible=false
			$Passages/PN/Sprite2.visible=true
			$Passages/PN/Sprite3.visible=false
		Defs.PassageType.NORMAL:
			$Passages/PN/Sprite.visible=false
			$Passages/PN/Sprite2.visible=false
			$Passages/PN/Sprite3.visible=true
		Defs.PassageType.CONNECTION:
			$Passages/PN/Sprite.visible=false
			$Passages/PN/Sprite2.visible=false
			$Passages/PN/Sprite3.visible=false
		_:
			$Passages/PN/Sprite.visible=true
			$Passages/PN/Sprite2.visible=false
			$Passages/PN/Sprite3.visible=false
			Data.Passages[Defs.UP]=Defs.PassageType.NONE
			
	match(Data.Passages[Defs.RIGHT]):
		Defs.PassageType.NONE:
			$Passages/PE/Sprite.visible=true
			$Passages/PE/Sprite2.visible=false
			$Passages/PE/Sprite3.visible=false
		Defs.PassageType.LOCKED:
			$Passages/PE/Sprite.visible=false
			$Passages/PE/Sprite2.visible=true
			$Passages/PE/Sprite3.visible=false
		Defs.PassageType.NORMAL:
			$Passages/PE/Sprite.visible=false
			$Passages/PE/Sprite2.visible=false
			$Passages/PE/Sprite3.visible=true
		Defs.PassageType.CONNECTION:
			$Passages/PE/Sprite.visible=false
			$Passages/PE/Sprite2.visible=false
			$Passages/PE/Sprite3.visible=false
		_:
			Data.Passages[Defs.RIGHT]=Defs.PassageType.NONE
			$Passages/PE/Sprite.visible=true
			$Passages/PE/Sprite2.visible=false
			$Passages/PE/Sprite3.visible=false
			
	match(Data.Passages[Defs.DOWN]):
		Defs.PassageType.NONE:
			$Passages/PS/Sprite.visible=true
			$Passages/PS/Sprite2.visible=false
			$Passages/PS/Sprite3.visible=false
		Defs.PassageType.LOCKED:
			$Passages/PS/Sprite.visible=false
			$Passages/PS/Sprite2.visible=true
			$Passages/PS/Sprite3.visible=false
		Defs.PassageType.NORMAL:
			$Passages/PS/Sprite.visible=false
			$Passages/PS/Sprite2.visible=false
			$Passages/PS/Sprite3.visible=true
		Defs.PassageType.CONNECTION:
			$Passages/PS/Sprite.visible=false
			$Passages/PS/Sprite2.visible=false
			$Passages/PS/Sprite3.visible=false
		_:
			Data.Passages[Defs.DOWN]=Defs.PassageType.NONE
			$Passages/PS/Sprite.visible=true
			$Passages/PS/Sprite2.visible=false
			$Passages/PS/Sprite3.visible=false
			
	match(Data.Passages[Defs.LEFT]):
		Defs.PassageType.NONE:
			$Passages/PW/Sprite.visible=true
			$Passages/PW/Sprite2.visible=false
			$Passages/PW/Sprite3.visible=false
		Defs.PassageType.LOCKED:
			$Passages/PW/Sprite.visible=false
			$Passages/PW/Sprite2.visible=true
			$Passages/PW/Sprite3.visible=false
		Defs.PassageType.NORMAL:
			$Passages/PW/Sprite.visible=false
			$Passages/PW/Sprite2.visible=false
			$Passages/PW/Sprite3.visible=true
		Defs.PassageType.CONNECTION:
			$Passages/PW/Sprite.visible=false
			$Passages/PW/Sprite3.visible=false
			$Passages/PW/Sprite2.visible=false
		_:
			Data.Passages[Defs.LEFT]=Defs.PassageType.NONE
			$Passages/PW/Sprite.visible=true
			$Passages/PW/Sprite2.visible=false
			$Passages/PW/Sprite3.visible=false
	pass
