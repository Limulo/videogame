tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("Box", "Node2D", preload("box.gd"), preload("icon.png"))

func _exit_tree():
	remove_custom_type("MyButton")
