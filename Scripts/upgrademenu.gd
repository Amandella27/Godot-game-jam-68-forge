extends CanvasLayer

const ATTACHVIEW = preload("res://Scenes/UI/attachview.tscn")

@onready var upgrade_1_button = %Upgrade1Button
@onready var upgrade_2_button = %Upgrade2Button
@onready var upgrade_3_button = %Upgrade3Button
@onready var main_container = $UpgradeMenu/MainContainer


var current_menu = self

func _ready():
	Globals.menusOpen = true

func _on_upgrade_1_button_pressed():
	checkUpgradeType(upgrade_1_button)
	main_container.visible = false
	
func _on_upgrade_2_button_pressed():
	checkUpgradeType(upgrade_2_button)
	main_container.visible = false
	
func checkUpgradeType(upgradeButton):
	if upgradeButton.text == "Forge Attachment":
		var forge_menu = ATTACHVIEW.instantiate()
		add_child(forge_menu)
		current_menu = forge_menu
	if upgradeButton.text == "Repair Armor":
		Globals.current_heat -= 50
		Globals.hud.update_heat(Globals.current_heat)
		Globals.currentPlayer.armor_component.adjust_armor(100)

func _input(event):
	if event.is_action_pressed("menu_back") and current_menu != null:
		if current_menu == self:
			Globals.menusOpen = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		current_menu.queue_free()
		main_container.visible = true
		current_menu = self
