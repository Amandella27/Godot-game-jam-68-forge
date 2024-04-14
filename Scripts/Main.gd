extends Node3D

const PAUSEMENU = preload("res://Scenes/pausemenu.tscn")

var paused = null

func _input(event):
	
	if event.is_action_pressed("menu") and paused == null:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		paused = PAUSEMENU.instantiate()
		add_child(paused)
