extends Control

var node_ref
var name
var pos

var script1 
var script2 = preload("res://scripts/object_code.gd")

func _ready():
	set_hidden(true)
	
# right mouse button pressed callback
func manage_right_click(r, n, p):
	node_ref=r
	name=n
	pos=p
	script1 = node_ref.action_script
	#set_process_input(true)
	set_pos(pos)
	set_hidden(false)

func _input(e):
	if(e.type==InputEvent.MOUSE_BUTTON and e.pressed and e.button_index==1):
		if true:
			node_ref.set_script(script1)
			node_ref.manage_talk()
		else:
			pass

func exit_UI():
	get_node("/root/Room").is_verb_UI_active=false
	#node_ref.set_script(script2)
	set_hidden(true)
	set_process_input(false)

func _on_Examine_pressed():
	print ("Examine ", name)
	exit_UI()
	node_ref.set_script(script1)
	node_ref.manage_examine(script2)
	
func _on_Use_pressed():
	print ("Use ", name)
	exit_UI()
	node_ref.set_script(script1)
	node_ref.manage_use(script2)

func _on_Talk_pressed():
	print ("Talk to ", name)
	exit_UI()
	node_ref.set_script(script1)
	node_ref.manage_talk(script2)
