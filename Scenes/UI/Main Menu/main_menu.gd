extends Control

@onready var options: Control = $CanvasLayer/options_menu

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/World/world.tscn")


func _on_options_pressed():
	options.visible = !options.visible
