extends Button
var roomRef;
var mousePoint

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	roomRef = get_node("/root/Room")
	mousePoint = Vector2(319, 190)

func _on_Button_pressed():
#	print("pressed")
	roomRef.foo( mousePoint );
