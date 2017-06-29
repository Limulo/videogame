extends Node

# DISPLAY Stuff ##########################
const SCALE_FACTOR = 2
var baseWindowSize
var mousePoint
var prevMousePoint
var fixedPoint

var previous = false
var bBoxDebug = false
var boxes = []
var closestBox

var walk_matrix = [
[1,2,2,2,2,2,2,2],
[1,2,3,3,3,3,3,3],
[2,2,3,5,5,5,5,5],
[5,5,5,4,5,5,7,5],
[3,3,3,4,5,6,4,8],
[5,5,5,5,5,6,5,8],
[4,4,4,4,4,4,7,4],
[5,5,5,5,5,6,5,8]
]

var actorRef

var init_box
var init_pos = Vector2()

func _ready():
	# init
	var baseWindowSize = OS.get_window_size()
	OS.set_window_size(baseWindowSize*SCALE_FACTOR)
	mousePoint = Vector2()
	prevMousePoint = Vector2()
	#fixedPoint = (baseWindowSize*0.5).floor()
	
	for box in get_node("boxes").get_children():
		boxes.append(box)
	
	for b in boxes:
		if b.ID == 2:
			init_box = b
			init_pos = b.LL
			break
	actorRef = get_node("Actor")
	actorRef.actor_init(init_box, init_pos)
	set_process(true)

func _process(delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		mousePoint = (get_global_mouse_pos()+Vector2(0.5, 0.5)).floor()
		# request redraw only if it is strictly needed 
		if mousePoint != prevMousePoint:
			prevMousePoint = mousePoint
			print( "Mouse: ", mousePoint )
			actorRef.setDestBox(foo( mousePoint ) )
			update()
	

func _draw():
	pass

func foo( wannaReachPoint ):
	# instruct all the boxes to calculate
	# their best point to a given one
	for b in boxes:
		b.getClosest( wannaReachPoint )
	# then find which one is the best one 
	# and get the corresponding box ID
	
	var best = Vector3(320,200,0) # TODO: this should be a very large vector

	for b in boxes:
		b.bHighlight = false
		var distance = b.closestPoint - two2three( wannaReachPoint )
		if  distance.length() < best.length():
			best = distance
			closestBox = b
	closestBox.bHighlight = true
	for b in boxes:
		b.update()
	return closestBox
	
# UTILITY functions ############################

# conversion between vectors of different dimensions
func two2three( v2d ):
	return Vector3(v2d.x, v2d.y, 0)

func three2two( v3d ):
	return Vector2(v3d.x, v3d.y)