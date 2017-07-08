extends Node2D

var player_position
const TEXTURE_H_SIZE=64
const TEXTURE_V_SIZE=64

const OFFSET_X = TEXTURE_H_SIZE/2
const OFFSET_Y = TEXTURE_V_SIZE/2

func _ready():
	print("Object created")
	player_position = Vector2(get_pos().x - 40, get_pos().y)

func check_collision(pos):
	var coords =get_pos()
	if pos.x > (coords.x-OFFSET_X) and pos.x < (coords.x+OFFSET_X):
		if pos.y > (coords.y-OFFSET_Y) and pos.y < (coords.y+OFFSET_Y):
			return true
	else:
		return false

func stop():
	print ("stop")
	
