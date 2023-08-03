extends Control

@onready var resolutions = $"Background/Tabs Container/Video/MarginContainer/ResContainer/Resolutions"

var _config = ConfigFile.new()
var path = "res://Config/settings.cfg"

func _ready():
	loadSettings()

func _on_button_pressed():
	self.visible = !self.visible

func loadSettings():
	var error = _config.load("res://Config/settings.cfg");
	if error != OK:
		# Create new cfg with default settings
		_config.set_value("Video Settings", "Resolution", 0)
		_config.save(path)
		return
	
	var resolution_index = _config.get_value("Video Settings", "Resolution", null)
	updateResolution(resolution_index)
	resolutions.select(resolution_index)


func _on_resolutions_item_selected(index):
	updateResolution(index)

func updateResolution(index: int):
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1024, 576))
		1:
			DisplayServer.window_set_size(Vector2i(1280, 720))
		2:
			DisplayServer.window_set_size(Vector2i(1366, 768))
		3:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		4:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
	_config.set_value("Video Settings", "Resolution", index)
	_config.save(path)
