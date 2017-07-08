extends Navigation2D

var begin= Vector2()
var end = Vector2()
var path=[]

onready var player=get_node("Ego")

func _ready():
	set_process_unhandled_input(true)
	pass
	
func _unhandled_input(event):
	if (event.type == InputEvent.MOUSE_BUTTON and event.pressed and event.button_index==1):
		print("Unhandled Input di Node")
		#get_tree().set_input_as_handled()
		goto(event.pos)

func goto(dst):
	end = dst
	begin = player.get_pos()
	update_path()

func update_path():
	var p = get_simple_path(begin, end, true)
	path = Array(p)
	path.invert()
	player.moving=true
	set_process(true)

func _process(delta):
	if(path.size()>1):
		var to_walk = delta*player.vel
		while to_walk>0 and path.size()>=2:
			var pFrom=path[path.size()-1]
			var pTo=path[path.size()-2]
			var d = pFrom.distance_to(pTo)
			#print("d: ", d, " to_walk: ", to_walk)
			#TODO
			if d<=to_walk:
				path.remove(path.size()-1)
				to_walk=0
			else:
				path[path.size()-1] = pFrom.linear_interpolate(pTo, to_walk/d)
				to_walk=0
		var atPos = path[path.size()-1]
		atPos = atPos.floor()
		#print(atPos)
		player.set_pos(atPos)
		if path.size()<2:
			path=[]
			set_process(false)
			player.moving=false
	else:
		set_process(false)
		player.moving=false
