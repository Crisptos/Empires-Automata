class_name Person
extends Sprite2D

var colony: int
var age: int
var strength: int
var mutation_gen = RandomNumberGenerator.new()
var mutation = RandomNumberGenerator.new()
var reproduction: int

func init(color: int, pos: Vector2, base_str: int):
	position = pos
	frame = color
	colony = color
	age = 0
	reproduction = 0
	mutation = round(mutation_gen.randf_range(-4.0, 4.0))
	strength = base_str + mutation

func is_alive() -> bool:
	if age >= strength:
		return false
	return true

func can_reproduce() -> bool:
	if reproduction < 50:
		return false
	reproduction = 0
	return true

func die():
	queue_free()

func update(base_str: int):
	age+=1
	reproduction+=5
	strength = base_str + mutation


