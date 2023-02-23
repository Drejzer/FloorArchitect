@tool
extends EditorPlugin

const AUTOLOAD_NAME = "Utils"

func _enter_tree() -> void:
	add_autoload_singleton(AUTOLOAD_NAME,"res://addons/Floorgen/Utils.gd")


func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_NAME)
	pass
