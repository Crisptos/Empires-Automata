extends Node2D

@onready var WorldState = $WorldGrid

# UI Related Vars
var selected_color: int
var play: bool = false

func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		var spawnLoc = WorldState.world_to_grid(get_global_mouse_position())
		WorldState.spawn_person(spawnLoc, selected_color)
		
func _process(_delta):
	if(play):
		WorldState.update_cells()


func _on_check_button_toggled(button_pressed):
	play = !play


func _on_item_list_item_selected(index):
	selected_color = index
