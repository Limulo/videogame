extends Node

onready var nav2d = get_node("walk_area")
onready var player = get_node("walk_area/Ego")

var scale_factor = 2
var font = preload("res://resources/fonts/font1.tres")



func _ready():
	OS.set_window_size(OS.get_window_size()*scale_factor)
	set_process_unhandled_input(true)


