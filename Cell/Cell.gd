extends Node2D

## use as representation of passages
var Data:CellData=CellData.new()
signal SetupFinished
@export var Size_x:int
@export var Size_y:int

func setup(d:CellData) -> void:
	Data.PassFlags=d.PassFlags
	Data.RequiredPassFlags=d.RequiredPassFlags
	Data.MapPos_x=d.MapPos_x
	Data.MapPos_y=d.MapPos_y
	Data.RoomType=d.RoomType
	configure_walls()
	position=Vector2(Data.MapPos_x*Size_x,Data.MapPos_y*Size_y)
	emit_signal("SetupFinished")
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	configure_walls()
	pass # Replace with function body.

func configure_walls()->void:
	match(Data.PassFlags&3):
		0:
			$Passages/PN/Sprite.visible=true
			$Passages/PN/Sprite2.visible=false
			$Passages/PN/Sprite3.visible=false
		1:
			$Passages/PN/Sprite.visible=false
			$Passages/PN/Sprite2.visible=true
			$Passages/PN/Sprite3.visible=false
		2:
			$Passages/PN/Sprite.visible=false
			$Passages/PN/Sprite2.visible=false
			$Passages/PN/Sprite3.visible=true
		3:
			$Passages/PN/Sprite.visible=false
			$Passages/PN/Sprite2.visible=false
			$Passages/PN/Sprite3.visible=false
	match(Data.PassFlags&(3*4)):
		0:
			$Passages/PE/Sprite.visible=true
			$Passages/PE/Sprite2.visible=false
			$Passages/PE/Sprite3.visible=false
		1*4:
			$Passages/PE/Sprite.visible=false
			$Passages/PE/Sprite2.visible=true
			$Passages/PE/Sprite3.visible=false
		2*4:
			$Passages/PE/Sprite.visible=false
			$Passages/PE/Sprite2.visible=false
			$Passages/PE/Sprite3.visible=true
		3*4:
			$Passages/PE/Sprite.visible=false
			$Passages/PE/Sprite2.visible=false
			$Passages/PE/Sprite3.visible=false
	match(Data.PassFlags&(3*16)):
		0:
			$Passages/PS/Sprite.visible=true
			$Passages/PS/Sprite2.visible=false
			$Passages/PS/Sprite3.visible=false
		1*16:
			$Passages/PS/Sprite.visible=false
			$Passages/PS/Sprite2.visible=true
			$Passages/PS/Sprite3.visible=false
		2*16:
			$Passages/PS/Sprite.visible=false
			$Passages/PS/Sprite2.visible=false
			$Passages/PS/Sprite3.visible=true
		3*16:
			$Passages/PS/Sprite.visible=false
			$Passages/PS/Sprite2.visible=false
			$Passages/PS/Sprite3.visible=false
	match(Data.PassFlags&(3*64)):
		0:
			$Passages/PW/Sprite.visible=true
			$Passages/PW/Sprite2.visible=false
			$Passages/PW/Sprite3.visible=false
		1*64:
			$Passages/PW/Sprite.visible=false
			$Passages/PW/Sprite2.visible=true
			$Passages/PW/Sprite3.visible=false
		2*64:
			$Passages/PW/Sprite.visible=false
			$Passages/PW/Sprite2.visible=false
			$Passages/PW/Sprite3.visible=true
		3*64:
			$Passages/PW/Sprite.visible=false
			$Passages/PW/Sprite3.visible=false
			$Passages/PW/Sprite2.visible=false
	pass
