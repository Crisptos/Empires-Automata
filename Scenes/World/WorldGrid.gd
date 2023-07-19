class_name WorldGrid
extends TileMap

# Node/Scene References
@export var show_grid: bool = false
var colony_stats = ColonyStats.new()

@onready var DebugMode = $DebugMode
@onready var PopulationHandler = $Population

@onready var counter = get_node("../CanvasLayer/GUI/CounterRect")

var PersonScene = preload("res://Scenes/Person/person.tscn")

# TileMap Relevent Vars
var width = 100
var height = 80
var cell_size = 16

# World State related variables
var grid: Dictionary = {}
var population: Dictionary = {}
var noise := FastNoiseLite.new()
var dirx = RandomNumberGenerator.new()
var diry = RandomNumberGenerator.new()

enum ACTIONS {STAY, FIGHT, MOVE, ENCOUNTER, HARVEST}

# Node Initialization
func _ready():
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	generate_grid()

# Cell Behavior and Rule Checking
func spawn_person(pos: Vector2, colony: int):
	if !cell_place_check(pos):
		return
	var new_person = PersonScene.instantiate()
	new_person.init(colony, grid_to_world(pos), colony_stats.get_str_base(colony))
	population[pos] = new_person
	PopulationHandler.add_child(new_person)
	colony_stats.add_pop(colony, counter)

func cell_place_check(pos: Vector2) -> bool:
	if pos.x < 0 || pos.y < 0 || pos.x >= width || pos.y >= height:
		return false
	elif grid[pos] < .20:
		return false
	elif population.has(pos):
		return false
	return true

func check_valid_tile(pos: Vector2) -> ACTIONS:
	if pos.x < 0 || pos.y < 0 || pos.x >= width || pos.y >= height:
		return ACTIONS.STAY
	elif grid[pos] < .20:
		return ACTIONS.STAY
	elif grid[pos] > .55:
		return ACTIONS.HARVEST
	elif population.has(pos):
		return ACTIONS.ENCOUNTER
	return ACTIONS.MOVE

func friend_or_foe(target: Vector2, colony: int) -> bool:
	if population[target].colony != colony:
		return false
	return true

func cell_fight(c1: Vector2, c2: Vector2) -> bool:
	if population[c1].strength < population[c2].strength:
		return false
	return true

func move_cell(cell: Person, old_spot: Vector2, new_spot: Vector2):
	cell.position = grid_to_world(new_spot)
	population.erase(old_spot)
	population[new_spot] = cell

func delete_cell(cell: Person, pos: Vector2):
	colony_stats.subtract_pop(cell.colony, counter)
	population.erase(pos)
	cell.die()

func get_empty_pos(current_pos: Vector2) -> Vector2:
	var full = 0
	for x in range(-1,1):
		for y in range(-1,1):
			if !population.has(Vector2(current_pos.x+x, current_pos.y+y)):
				return Vector2(current_pos.x+x, current_pos.y+y)
	return current_pos

func harvest_tile(pos: Vector2, colony_id: int):
	set_cell(0,pos,0, Vector2i(0,0))
	grid[pos] = .55
	colony_stats.set_str_base(colony_id, 1)

func update_cells():
	
	for pos in population:
		
		var current_person = population[pos]
		
		# Check to see if that cell is alive
		if !current_person.is_alive():
			delete_cell(current_person, pos)
			return
		
		# Check to see if they can reproduce
		if current_person.can_reproduce():
			var new_spot = get_empty_pos(pos)
			if new_spot != pos:
				spawn_person(new_spot, current_person.colony)
		
		# Check for valid movement
		var new_spot = Vector2(round(pos.x+dirx.randf_range(-1.0, 1.0)), round(pos.y+diry.randf_range(-1.0, 1.0)))
		match check_valid_tile(new_spot):
			ACTIONS.HARVEST:
				move_cell(current_person, pos, new_spot)
				harvest_tile(new_spot, current_person.colony)
			ACTIONS.MOVE:
				move_cell(current_person, pos, new_spot)
			ACTIONS.ENCOUNTER:
				match friend_or_foe(new_spot, current_person.colony):
					false:
						if cell_fight(pos, new_spot):
							delete_cell(population[new_spot], new_spot)
							move_cell(current_person, pos, new_spot)
						else:
							delete_cell(current_person, pos)
		current_person.update(colony_stats.get_str_base(current_person.colony))


# World Generation
func generate_grid():
	for x in width:
		for y in height:
			var rand = abs(noise.get_noise_2d(x,y))
			grid[Vector2(x,y)] = rand
			if rand < .20:
				set_cell(0,Vector2i(x,y),1, Vector2i(0,0))
			elif rand > .55:
				set_cell(0,Vector2(x,y), 2, Vector2i(0,0))
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
