extends CanvasLayer

@onready var how_to_play = $HowToPlay

func _ready():
	get_tree().paused = true

func _input(event):
	
	if event.is_action_pressed("menu"):
		get_tree().paused = false
		if Globals.menusOpen == false:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		queue_free()
	if event.is_action_pressed("menu_back"):
		how_to_play.visible = false

func _on_resume_pressed():
	get_tree().paused = false
	if Globals.menusOpen == false:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()


func _on_quit_pressed():
	get_tree().quit()

func _on_howto_play_pressed():
	how_to_play.visible = true
