extends Node2D

func manage_talk(script):
	print ("Can't talk to windows")
	return_to_game(script)

func manage_examine(script):
	print ("it's yellow")
	return_to_game(script)

func manage_use(script):
	print("nope")
	return_to_game(script)

func return_to_game(s):
	set_script(s)