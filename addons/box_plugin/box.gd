tool
extends Node2D

export(int, 1, 20) var ID
export(int, FLAGS, "x_flip", "y_flip", "ignore_scale", "player_only", "locked", "invisible") var BoxFlags = 0
export (int, 1, 10) var mask
export (int) var scale

export(Vector2) var UL = Vector2() 
export(Vector2) var LL = Vector2() 
export(Vector2) var LR = Vector2() 
export(Vector2) var UR = Vector2() 

# DISPLAY stuff ###############################
#var borderCol = Color(120,0, 120)
var lineCol = Color(120, 120, 120)
var bHighlight = false

###############################################

var roomRef

var bRegular = true # is the box a line or a convex quadrilateral
const N_LINES = 4
var planes = [] # lines between vertices
var coords3D = [] # 3D vertices for plane calculation
var closests = [] # best candidates to be the point to go to (3D)
var closestPoint  # 3D closest point
var wannaReachPoint
#########################

func _enter_tree():
	print("box ", ID, " ready")
	print("Box ",ID, " created")
	roomRef = get_node("/root/Room")
	
	closestPoint = Vector3()
	wannaReachPoint = Vector3()
	
	# calculate the coordinates for the 3D array
	coords3D.append(two2three(UL))
	coords3D.append(two2three(LL))
	coords3D.append(two2three(LR))
	coords3D.append(two2three(UR))
	
	bRegular = is_box_regular(coords3D);
	if bRegular:
		print("Box ", ID, " is regular")
	else:
		print("Box ", ID, " is unregular")
		
	# planes are only needed if the box is regular
	if bRegular:
		for i in range(N_LINES):
			planes.append( build_plane(coords3D[i], coords3D[(i+1)%N_LINES]) )


func _draw():
	var col = Color()
	if bHighlight:
		col = Color(255, 0, 0)
		if bRegular:
			draw_colored_polygon([UL, LL, LR, UR], col)
	else:
		col = Color(120,0, 120)
	# border
	draw_line(UL, LL, col)
	draw_line(LL, LR, col)
	draw_line(LR, UR, col)
	draw_line(UR, UL, col)
	# lines
	draw_line( three2two(wannaReachPoint), three2two(closestPoint), lineCol)


# Utility: we calculate the area of quadrilateral in order to check if 
# the box is a regular one (a partition of the plane) or a peculiar one (a line).
# In the latter case, we'll need to compute the point to go to only on one plane
func is_box_regular ( corners ):
	var d1 = corners[2] - corners[0]
	var d2 = corners[3] - corners[1]
	var area = 0.5*( d1.cross(d2) ).length()
	if area==0:
		return false
	return true
	
func getClosest( _wannaReachPoint ):
	wannaReachPoint = two2three(_wannaReachPoint)
	# calculate the destination point
	# NOTE: planes calculation is only 
	# needed if the box is regular
	if !bRegular:
		# The box is NOT regular (i.e. the box is a line)
		# check if the line is horizontal
		if (coords3D[0]-coords3D[1]).length() == 0:
			# the line is horizontal
			print("is horizontal")
			closestPoint = closestPointOnLine(coords3D[0],coords3D[3], wannaReachPoint)
		else:
			# line is not horizontal (i.e. vertical or oblique)
			print("is NOT horizontal")
			closestPoint = closestPointOnLine(coords3D[0], coords3D[1], wannaReachPoint)
	else:
		# the box is regular (i.e. convex quadrilateral)
		if inside( planes, wannaReachPoint ):
			# mouse click happened inside the box
			# you have arrived!
			closestPoint = wannaReachPoint
		else:
			# populate an array containing 4 distances from
			# the wanna-reach-point to the closest point 
			# for each side
			for i in range(N_LINES):
				closests.append( closestPointOnLine( coords3D[i], coords3D[(i+1)%N_LINES], wannaReachPoint) )
				closests[i] = closests[i] - wannaReachPoint

			var best = Vector3(320,200,0) # TODO: this should be a very large vector

			for i in range(N_LINES):
				if closests[i].length() < best.length():
					best = closests[i]
			closestPoint = best + wannaReachPoint
	print( "Box", ID, " ", closestPoint )
	closests.clear() # clear the vector


# return a Plane obj created from
# two given points
func build_plane(point_a, point_b):
	var segment = point_b - point_a
	segment = segment.normalized()
	var N = Vector3(-segment.y,segment.x,0)
	var D = N.dot(point_a)
	return Plane(N,D)

# return true if the point is within the polygon or on its border
func inside(planes, point):
	var inside = true
	for p in planes:
	    if (p.normal.dot(point) - p.d > 0):
	        inside = false
	        break
	return inside

# given a point, and a segment,
# calculate the closest point to it which
# lies on that segment 
func closestPointOnLine(start, end, point):
	
	# SEGMENT: is a vector starting in "start" and pointing toward "end"
	var segment = end - start
	var segment_magnitude = segment.length()
	
	var p = build_plane( start, end )
	var projected_point = p.project( point )
	
	# START_PROJECTED: is a vector starting in "start" and pointing toward "projected_point"
	var start_projected = projected_point - start
	
	# we use the dot product to know if the two segments are aligned
	# (the dot product can never be zero because the two vectors are always aligned)
	if segment.dot(start_projected) > 0:
		# vectors are concordant
		if start_projected.length() > segment_magnitude:
			return end
	else:
		# vector are not concordant
		return start
	return projected_point


# conversion between vectors of different dimensions
func two2three( v2d ):
	return Vector3(v2d.x, v2d.y, 0)

func three2two( v3d ):
	return Vector2(v3d.x, v3d.y)
	

