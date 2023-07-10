extends Node2D

@onready var WorldState = $WorldGrid

func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		var spawnLoc = WorldState.world_to_grid(get_global_mouse_position())
		WorldState.spawn_person(spawnLoc)
