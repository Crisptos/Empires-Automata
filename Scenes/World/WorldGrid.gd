class_name WorldGrid
extends TileMap

# Node/Scene References
@export var show_grid: bool = false
@onready var DebugMode = $DebugMode
@onready var PopulationHandler = $Population
var PersonScene = preload("res://Scenes/Person/person.tscn")

# TileMap Relevent Vars
var width = 100
var height = 80
var cell_size = 16

# World State related variables
var grid: Dictionary = {}
var population: Dictionary = {}
var noise := FastNoiseLite.new()

# UI Related Vars
var selected_color: int

# Node Initialization
func _ready():
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	generate_grid()

# Cell Behavior and Rule Checking
func spawn_person(pos: Vector2):
	if !check_valid_tile(pos):
		return
	var new_person = PersonScene.instantiate()
	new_person.init(selected_color, grid_to_world(pos))
	population[pos] = new_person
	PopulationHandler.add_child(new_person)
	print("Spawned Person")

func check_valid_tile(pos: Vector2) -> bool:
	if grid[pos] < .20:
		print("Cannot place a unit in water")
		return false
	elif population.has(pos):
		print("Cannot place a unit on top of another one")
		return false
	return true

# World Generation
func generate_grid():
	for x in width:
		for y in height:
			var rand = abs(noise.get_noise_2d(x,y))
			grid[Vector2(x,y)] = rand
			
			if rand < .20:
				set_cell(0,Vector2i(x,y),1, Vector2i(0,0))
			else:
				set_cell(0,Vector2i(x,y),0, Vector2i(0,0))
			
			if show_grid:
				var rect = ReferenceRect.new()
				rect.position = grid_to_world(Vector2(x,y))
				rect.size = Vector2(cell_size, cell_size)
				rect.editor_only = false
				DebugMode.add_child(rect)

# Utility Functions
func grid_to_world(_pos: Vector2) -> Vector2:
	return _pos * cell_size

func world_to_grid(_pos: Vector2) -> Vector2:
	return floor(_pos/cell_size)

# UI Signal
func _on_item_list_item_selected(index):
	selected_color = index
