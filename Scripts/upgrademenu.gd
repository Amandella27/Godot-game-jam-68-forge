extends CanvasLayer

signal used_heat(amount)
signal menu_not_enough_heat()


const ATTACHVIEW = preload("res://Scenes/UI/attachview.tscn")


@onready var main_container = $UpgradeMenu/MainContainer
@onready var upgrade_1 = %Upgrade1
@onready var upgrade_2 = %Upgrade2
@onready var upgrade_3 = %Upgrade3
@onready var upgrade_1_button = $UpgradeMenu/MainContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/Upgrade1Button

var current_menu = self

func _ready():
	Globals.menusOpen = true
	upgrade_1_button.grab_focus()

func _on_upgrade_1_button_pressed():
	if checkUpgradeType(upgrade_1):
		main_container.visible = false
	
func _on_upgrade_2_button_pressed():
	if checkUpgradeType(upgrade_2):
		main_container.visible = false
	
func checkUpgradeType(upgradeText):
	if upgradeText.text == "Forge Attachment":
		var forge_menu = ATTACHVIEW.instantiate()
		add_child(forge_menu)
		forge_menu.upgrade_selected.connect(new_sword)
		forge_menu.not_enough_heat.connect(not_enough_heat)
		current_menu = forge_menu
		return true
	if upgradeText.text == "Repair Armor" and Globals.current_heat >= 50:
		used_heat.emit(-50)
		Globals.currentPlayer.armor_component.adjust_armor(100)
		return true
	else:
		not_enough_heat()

func _input(event):
	if event.is_action_pressed("menu_back") and current_menu != null:
		if current_menu == self:
			Globals.menusOpen = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		current_menu.queue_free()
		main_container.visible = true
		current_menu = self
		
func new_sword(direction: String):
	used_heat.emit(-100)
	Globals.currentWeapon.add_sword(direction)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()

func not_enough_heat():
	Globals.hud.more_heat_needed.text = str("Not enough\nheat")
	Globals.hud.more_heat_needed.label_settings.font_color = Color(1, 1, 1, 1)
	Globals.hud.more_heat_needed.label_settings.shadow_color = Color(0, 0, 0, 1)
	menu_not_enough_heat.emit()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	queue_free()
