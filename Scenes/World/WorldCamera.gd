extends Camera2D

@export var move_sensitivity = 100.0
var drag_sensitivity = 1.0
var zoom_min = 0.4
var zoom_max = 2.0
var zoom_speed = 0.05
var zoom_sensitivity = 1.25

func _ready():
	set_limit(SIDE_TOP, -10000)
	set_limit(SIDE_BOTTOM, 10000)
	set_limit(SIDE_LEFT, -10000)
	set_limit(SIDE_RIGHT, 10000)

func _process(delta):
	if Input.is_action_pressed("CAMERA_UP"):
		position.y -= move_sensitivity * delta
	elif Input.is_action_pressed("CAMERA_DOWN"):
		position.y += move_sensitivity * delta
	elif Input.is_action_pressed("CAMERA_LEFT"):
		position.x -= move_sensitivity * delta
	elif Input.is_action_pressed("CAMERA_RIGHT"):
		position.x += move_sensitivity * delta

func _input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		position -= event.relative * drag_sensitivity/zoom
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom += Vector2(zoom_speed, zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom -= Vector2(zoom_speed, zoom_speed)
		zoom = clamp(zoom, Vector2(zoom_min, zoom_min), Vector2(zoom_max, zoom_max))
