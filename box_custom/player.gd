extends Node2D

var pos
var dst
var isWalking = false
var path
var step

var vel = 50
signal reached

func _ready():
	print("Player ready")
	pos = get_pos()
	dst = pos
	connect("reached",get_node("/root/Room"),"say_hi")
	connect("reached",get_node("/root/Room/obstacle"),"stop")
	set_process(true)

func _process(delta):
	pos = get_pos()
	if isWalking:
		walk(dst, delta)

func reach(to):
	dst = to
	isWalking = true
	path = dst - pos
	step = path.normalized() * vel
	print("dst ", dst)

func walk(to,time):
	#check_direction()
	var distance = pos.distance_to(to)
	if distance > step.length()*time:
		pos = pos + (step * time)
		set_pos(pos)
		#yield()
		#yield( get_node("AnimationPlayer"), "finished" ) per ispirarsi
	else:
		pos = to
		isWalking = false
		emit_signal("reached")
		
