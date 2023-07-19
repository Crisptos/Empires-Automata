extends Resource
class_name ColonyStats

var red_str: int
var red_pop: int

var blue_str: int
var blue_pop: int

var green_str: int
var green_pop: int

var pink_str: int
var pink_pop: int

var yellow_str: int
var yellow_pop: int

func _init():
	red_str = 40
	red_pop = 0

	blue_str = 40
	blue_pop = 0

	green_str = 40
	green_pop = 0

	pink_str = 40
	pink_pop = 0

	yellow_str = 40
	yellow_pop = 0


func add_pop(i: int, labels: ColorRect):
	var counter = labels.get_child(i)
	match i:
		0:
			blue_pop+=1
			counter.set_text(str("Blue: ",blue_pop, " Avg Str: ", blue_str))
		1:
			green_pop+=1
			counter.set_text(str("Green: ",green_pop, " Avg Str: ", green_str))
		2:
			red_pop+=1
			counter.set_text(str("Red: ",red_pop, " Avg Str: ", red_str))
		3:
			pink_pop+=1
			counter.set_text(str("Pink: ",pink_pop," Avg Str: ", pink_str))
		4:
			yellow_pop+=1
			counter.set_text(str("Yellow: ",yellow_pop, " Avg Str: ", yellow_str))

func subtract_pop(i: int, labels: ColorRect):
	var counter = labels.get_child(i)
	match i:
		0:
			blue_pop-=1
			counter.set_text(str("Blue: ",blue_pop, " Avg Str: ", blue_str))
		1:
			green_pop-=1
			counter.set_text(str("Green: ",green_pop, " Avg Str: ", green_str))
		2:
			red_pop-=1
			counter.set_text(str("Red: ",red_pop, " Avg Str: ", red_str))
		3:
			pink_pop-=1
			counter.set_text(str("Pink: ",pink_pop," Avg Str: ", pink_str))
		4:
			yellow_pop-=1
			counter.set_text(str("Yellow: ",yellow_pop, " Avg Str: ", yellow_str))

func get_str_base(i: int) -> int:
	match i:
		0:
			return blue_str
		1:
			return green_str
		2:
			return red_str
		3:
			return pink_str
		4:
			return yellow_str
	return 0
	
func set_str_base(i: int, modifier: int):
	match i:
		0:
			blue_str+=modifier
		1:
			green_str+=modifier
		2:
			red_str+=modifier
		3:
			pink_str+=modifier
		4:
			yellow_str+=modifier
