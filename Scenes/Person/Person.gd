class_name Person
extends Sprite2D

var colony: int
var age: int
var strength: int
var is_alive: bool

func init(color: int, pos: Vector2):
	position = pos
	frame = color
	colony = color
	age = 0
	strength = 10
	is_alive = true


