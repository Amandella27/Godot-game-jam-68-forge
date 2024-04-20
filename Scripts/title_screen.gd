extends Control

@onready var how_to_play = %"How to Play"
@onready var play_button = %PlayButton


func _ready():
	play_button.grab_focus()

func _on_play_button_pressed():
	get_tree().change_scene_to_packed(Globals.MAIN)

func _on_how_to_play_button_pressed():
	how_to_play.visible = true

func _on_how_to_play_closed():
	how_to_play.grab_focus()


#func _input(event):
	#if event is InputEventJoypadMotion:
		#if how_to_play.has_focus() or play_button.has_focus():
			#pass
		#else:
			#play_button.grab_focus()
