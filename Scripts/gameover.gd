extends CanvasLayer

signal reset_game()

@onready var survived_waves = $Panel/MarginContainer/VBoxContainer/SurvivedWaves

func _ready():
	survived_waves.text = str("Waves  Survived: ", Globals.current_wave-1)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true

func _on_quit_pressed():
	get_tree().quit()
	
func _on_retry_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	reset_game.emit()
	queue_free()
