extends PanelContainer

func _ready():
	get_tree().paused = true

func _input(event):
	
	if event.is_action_pressed("menu"):
		get_tree().paused = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		queue_free()


func _on_resume_pressed():
	get_tree().paused = false
	queue_free()


func _on_quit_pressed():
	get_tree().quit()