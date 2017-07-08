extends Polygon2D

export(String) var name="the window"

var vertices = []
var indices = []
var n_triangles = 0
var mouse=Vector2()
var showObjectName=false

onready var font = get_node("/root/Room").font
onready var wa = get_node("/root/Room/walk_area")

func _ready():
	vertices = get_polygon()
	indices = Geometry.triangulate_polygon( vertices )
	#print( vertices )
	#print( indices )
	n_triangles = indices.size() / 3
	#print( n_triangles )

	set_process_unhandled_input(true)

func is_inside(point):
	var inside = false
	for i in range( n_triangles ):
		var v1 =  vertices[ indices[i*3 + 0] ]
		var v2 =  vertices[ indices[i*3 + 1] ]
		var v3 =  vertices[ indices[i*3 + 2] ]
		inside = Geometry.point_is_inside_triangle ( mouse, v1, v2, v3 )
		if inside:
			return true
	return false

func _unhandled_input(e):
	if(e.type == InputEvent.MOUSE_BUTTON or e.type==InputEvent.MOUSE_MOTION):
		mouse = e.pos
		if( is_inside(mouse) ):
			get_tree().set_input_as_handled()
			if(e.type==InputEvent.MOUSE_BUTTON and e.pressed and e.button_index==1):
				print(name, ": inside")
				var interact_point = get_node("interact_point").get_pos()
				wa.goto(interact_point)
			elif(e.type==InputEvent.MOUSE_MOTION):
				showObjectName=true
				update()
		else:
			if(e.type==InputEvent.MOUSE_MOTION and showObjectName):
				showObjectName=false
				update()

func _draw():
	if showObjectName:
		font.draw(get_canvas_item(), mouse, name, Color(0,0,0))