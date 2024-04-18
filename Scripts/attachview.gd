extends Control

signal upgrade_selected(direction)

func _on_forge_forward_pressed():
	if Globals.current_heat >= 100:
		upgrade_selected.emit("straight")

func _on_forge_up_pressed():
	if Globals.current_heat >= 100:
		upgrade_selected.emit("up")

func _on_forge_right_pressed():
	if Globals.current_heat >= 100:
		upgrade_selected.emit("right")

func _on_forge_down_pressed():
	if Globals.current_heat >= 100:
		upgrade_selected.emit("down")

func _on_forge_left_pressed():
	if Globals.current_heat >= 100:
		upgrade_selected.emit("left")
