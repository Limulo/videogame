extends Sprite

# scaling
var y1 = 159
var y2 = 240
var scale1 = 1
var scale2 = 2
var m = (y1-y2)/(scale1-scale2)
var q = y2 - (scale2*m)

# movement
var vel = 75
var moving=false

func _ready():
	set_pos(Vector2(272, 183))
	set_process(true)

func _process(delta):
	var y = get_pos().y
	var scale = calculate_scale(y)
	set_scale(Vector2(scale, scale))

func calculate_scale(y):
	return (y-q)/m