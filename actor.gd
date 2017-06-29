extends Sprite

var curBox = 0
var dstBox = 0
var nextBox = 0
var curPos = Vector2()
var dstPos= Vector2()
var nextPos= Vector2()

var roomRef

func _ready():
	roomRef = get_node("/root/Room")

func actor_init(box, position):
	print ("actor init")
	curBox = box
	curPos = position
	print(curBox , " - " ,curPos)
	set_pos(curPos)
	
func setDestBox(box):
	dstBox = box
	dstPos = dstBox.LL
	if dstBox != curBox:
		calculateNextBox(curBox, dstBox)
	print("Devo andare in " , nextBox.ID)
	curBox = nextBox
	curPos = nextPos
	set_pos(curPos)

func calculateNextBox(src, dst):
	var src_idx=src.ID
	var dst_idx=dst.ID
	var next = roomRef.walk_matrix[src_idx-1][dst_idx-1]
	for b in roomRef.boxes:
		if next == b.ID:
			nextBox = b
			nextPos = nextBox.LL
			break

	
	
