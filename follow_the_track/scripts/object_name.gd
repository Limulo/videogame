extends Node2D

var text=""

onready var room = get_node("/root/Room")
onready var font = room.font
var window_size = Vector2()

var position

func _ready():
	position = get_pos()
	window_size = OS.get_window_size()

func set_name(name, pos):
	#print(name, " ", pos)
	text=name
	calculate_position(pos)
	update()

func calculate_position(p):
	var size = font.get_string_size(text)
	if p.x + size.x > window_size.x:
		position.x = window_size.x - size.x
	else:
		position.x = p.x
	if p.y - size.y < 0:
		position.y = size.y
	else:
		position.y=p.y
	#print(size, " ", position, " ", window_size)
	set_pos(position)

func _draw():
	font.draw(get_canvas_item(), Vector2(), text, Color(0,0,0))
