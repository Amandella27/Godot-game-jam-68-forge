extends Control

const ATTACHVIEW = preload("res://Scenes/UI/attachview.tscn")

@onready var upgrade_1_button = %Upgrade1Button
@onready var upgrade_2_button = %Upgrade2Button
@onready var upgrade_3_button = %Upgrade3Button
@onready var main_container = $MainContainer

var current_menu = self

func _on_upgrade_1_button_pressed():
	checkUpgradeType(upgrade_1_button)
	main_container.visible = false
	
func checkUpgradeType(upgradeButton):
	if upgradeButton.text == "Forge Attachment":
		var forge_menu = ATTACHVIEW.instantiate()
		add_child(forge_menu)
		current_menu = forge_menu

func _input(event):
	if event.is_action_pressed("menu_back") and current_menu != null:
		current_menu.queue_free()
		main_container.visible = true
		current_menu = self
