extends Node

onready var nav2d = get_node("walk_area")
onready var player = get_node("walk_area/Ego")

var scale_factor = 2
var font = preload("res://resources/fonts/font1.tres")
var base_window_size= Vector2()

var is_verb_UI_active = false

var objects=[]

func _ready():
	base_window_size = OS.get_window_size()
	OS.set_window_size(base_window_size*scale_factor)
	for o in get_node("objects").get_children():
		objects.append(o)

func clearObjectsName():
	for o in objects:
		o.showObjectName=false
		o.update()

func load_script(the_object, the_script):
	print(the_object, " ", the_script)
