extends Control

@onready var how_to_play = %"How to Play"


func _on_play_button_pressed():
	get_tree().change_scene_to_packed(Globals.MAIN)


func _on_how_to_play_button_pressed():
	how_to_play.visible = true


func _on_x_how_to_play_pressed():
	how_to_play.visible = false
