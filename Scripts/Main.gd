extends Node3D

const PAUSEMENU = preload("res://Scenes/UI/pausemenu.tscn")
const UPGRADEMENU = preload("res://Scenes/UI/upgrademenu.tscn")

var paused = null
var upgradeMenu
var playerNearAnvil:bool = false

func _ready():
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	
	if event.is_action_pressed("menu") and paused == null:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		paused = PAUSEMENU.instantiate()
		add_child(paused)
		
	if event.is_action_pressed("use") and playerNearAnvil == true and upgradeMenu == null:
		upgradeMenu = UPGRADEMENU.instantiate()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		add_child(upgradeMenu)
	elif event.is_action_pressed("use") and playerNearAnvil == true and upgradeMenu != null:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		upgradeMenu.queue_free()

func _on_anvil_near_anvil():
	playerNearAnvil = true
	Globals.currentPlayer.interact_popup.visible = true
	
func _on_anvil_left_anvil():
	playerNearAnvil = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Globals.currentPlayer.interact_popup.visible = false
	
	if upgradeMenu != null:
		upgradeMenu.queue_free()
