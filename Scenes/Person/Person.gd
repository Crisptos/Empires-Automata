class_name Person
extends Sprite2D

var colony: int
var age: int
var strength: int
var base_strength: int
var strength_addon = RandomNumberGenerator.new()
var reproduction: int

func init(color: int, pos: Vector2):
	position = pos
	frame = color
	colony = color
	age = 0
	reproduction = 0
	base_strength = 60
	strength = base_strength + round(strength_addon.randf_range(1.0, 8.0))

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


