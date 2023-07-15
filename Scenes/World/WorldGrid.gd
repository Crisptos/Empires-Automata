class_name WorldGrid
extends TileMap

# Node/Scene References
@export var show_grid: bool = false
@onready var DebugMode = $DebugMode
@onready var PopulationHandler = $Population

@onready var RedLabel = get_node("../CanvasLayer/GUI/Red")
@onready var BlueLabel = get_node("../CanvasLayer/GUI/Blue")
@onready var GreenLabel = get_node("../CanvasLayer/GUI/Green")
@onready var YellowLabel = get_node("../CanvasLayer/GUI/Yellow")
@onready var PinkLabel = get_node("../CanvasLayer/GUI/Pink")

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

var red = 0
var blue = 0
var green = 0
var yellow = 0
var pink = 0

enum ACTIONS {STAY, FIGHT, MOVE, ENCOUNTER}

# Node Initialization
func _ready():
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	generate_grid()

# Cell Behavior and Rule Checking
func spawn_person(pos: Vector2, colony: int):
	if check_valid_tile(pos) != ACTIONS.MOVE:
		return
	var new_person = PersonScene.instantiate()
	new_person.init(colony, grid_to_world(pos))
	population[pos] = new_person
	PopulationHandler.add_child(new_person)
	match colony:
		0:
			blue+=1
			BlueLabel.set_text(str("Blue: ", blue))
		1:
			green+=1
			GreenLabel.set_text(str("Green: ", green))
		2:
			red+=1
			RedLabel.set_text(str("Red: ", red))
		3:
			pink+=1
			PinkLabel.set_text(str("Pink: ", pink))
		4:
			yellow+=1
			YellowLabel.set_text(str("Yellow: ", yellow))

func check_valid_tile(pos: Vector2) -> ACTIONS:
	if pos.x < 0 || pos.y < 0 || pos.x >= width || pos.y >= height:
		return ACTIONS.STAY
	elif grid[pos] < .20:
		return ACTIONS.STAY
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
	match cell.colony:
		0:
			blue-=1
			BlueLabel.set_text(str("Blue: ", blue))
		1:
			green-=1
			GreenLabel.set_text(str("Green: ", green))
		2:
			red-=1
			RedLabel.set_text(str("Red: ", red))
		3:
			pink-=1
			PinkLabel.set_text(str("Pink: ", pink))
		4:
			yellow-=1
			YellowLabel.set_text(str("Yellow: ", yellow))
			
	population.erase(pos)
	cell.die()

func get_empty_pos(current_pos: Vector2) -> Vector2:
	var full = 0
	for x in range(-1,1):
		for y in range(-1,1):
			if !population.has(Vector2(current_pos.x+x, current_pos.y+y)):
				return Vector2(current_pos.x+x, current_pos.y+y)
	
	return current_pos

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
		current_person.age+=1
		current_person.reproduction+=5


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
