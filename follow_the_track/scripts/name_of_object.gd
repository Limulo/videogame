extends Node2D

var pos
var font
var name

func display_name(f,p,n):
	font = f
	pos = p
	name = n
	update()

func _draw():
	if showObjectName:
		font.draw(get_canvas_item(), pos, name, Color(0,0,0))