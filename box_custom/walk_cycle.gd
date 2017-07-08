extends Node2D

var mouse_pos
var already_pressed = false

func _ready():
	print("room ready")
	set_process(true)

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and !already_pressed:
		already_pressed = true
		mouse_pos = get_global_mouse_pos()
		print("mouse: ", mouse_pos)

		if get_node("obstacle").check_collision(mouse_pos):
			get_node("Player").reach(get_node("obstacle").player_position)

		else:
			get_node("Player").reach(mouse_pos)

	if !Input.is_mouse_button_pressed(BUTTON_LEFT):
		already_pressed = false

func say_hi():
	print("hi")
	
