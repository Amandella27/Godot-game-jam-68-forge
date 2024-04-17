extends Control

signal upgrade_selected(direction)

func _on_forge_forward_pressed():
	if Globals.current_heat >= 100:
		upgrade_selected.emit("straight")

func _on_forge_up_pressed():
	if Globals.current_heat >= 100:
		upgrade_selected.emit("up")
