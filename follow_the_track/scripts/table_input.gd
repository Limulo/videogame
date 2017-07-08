extends Polygon2D


var vertices = []
var indices = []
var n_triangles = 0
var mouse=Vector2()
onready var wa = get_node("/root/Room/walk_area")

func _ready():
	vertices = get_polygon()
	indices = Geometry.triangulate_polygon( vertices )
	#print( vertices )
	#print( indices )
	n_triangles = indices.size() / 3
	#print( n_triangles )

	set_process_unhandled_input(true)

func _unhandled_input(e):
	#if (e.type == InputEvent.MOUSE_MOTION):
	if (e.type == InputEvent.MOUSE_BUTTON and e.pressed and e.button_index==1):
		mouse = e.pos
		var inside = false
		for i in range( n_triangles ):
			var v1 =  vertices[ indices[i*3 + 0] ]
			var v2 =  vertices[ indices[i*3 + 1] ]
			var v3 =  vertices[ indices[i*3 + 2] ]
			inside = Geometry.point_is_inside_triangle ( mouse, v1, v2, v3 )
			if(inside):
				print("table: inside")
				# handle the input and stop its propagation
				get_tree().set_input_as_handled()
				var interact_point = get_node("interact_point").get_pos()
				wa.goto(interact_point)
				return
		#outside
		return