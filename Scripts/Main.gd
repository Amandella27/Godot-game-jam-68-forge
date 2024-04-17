extends Node3D

const PLAYER = preload("res://Scenes/player.tscn")
const PAUSEMENU = preload("res://Scenes/UI/pausemenu.tscn")
const UPGRADEMENU = preload("res://Scenes/UI/upgrademenu.tscn")

@onready var ui_elements = $UIElements
@onready var hud = $UIElements/HUD
@onready var player_manager = $PlayerManager
@onready var enemy_spawner = $EnemySpawner
@onready var lava = $WorldEnvironment/Lava

var paused = null
var upgradeMenu
var playerNearAnvil:bool = false
var playerSpawnLocation = Vector3(-3,0,-7)

func _ready():
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	spawn_player(playerSpawnLocation)
	
	enemy_spawner.spawn_enemy_defeated.connect(update_heat_bar)

func spawn_player(location:Vector3):
	var player = PLAYER.instantiate()
	player.player_armor_changed.connect(update_armor_bar)
	player.player_health_changed.connect(update_health_bar)
	player.player_armor_broken.connect(armor_broken_warning)
	player.player_gameover.connect(gameover)
	Globals.currentPlayer = player
	player_manager.add_child(player)
	
	player.global_position = location

func _input(event):
	
	if event.is_action_pressed("menu") and paused == null:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		paused = PAUSEMENU.instantiate()
		ui_elements.add_child(paused)
		
	if event.is_action_pressed("use") and playerNearAnvil == true and upgradeMenu == null:
		upgradeMenu = UPGRADEMENU.instantiate()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		ui_elements.add_child(upgradeMenu)
		upgradeMenu.used_heat.connect(update_heat_bar)
	elif event.is_action_pressed("use") and playerNearAnvil == true and upgradeMenu != null:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		upgradeMenu.queue_free()

	if event.is_action_pressed("remove_enemies") and paused == null:
		enemy_spawner.remove_enemies()

func _on_anvil_near_anvil():
	playerNearAnvil = true
	Globals.currentPlayer.interact_popup.visible = true
	
func _on_anvil_left_anvil():
	playerNearAnvil = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Globals.currentPlayer.interact_popup.visible = false
	
	if upgradeMenu != null:
		upgradeMenu.queue_free()

func update_health_bar(new_value):
	hud.update_health(new_value)

func update_armor_bar(new_value):
	hud.update_armor(new_value)
	
func update_heat_bar(adjustment):
	hud.update_heat(adjustment)
	Globals.current_heat += adjustment
	
func armor_broken_warning():
	hud.armor_warning()

func gameover():
	hud.gameover()

func _on_hud_reset_game():
	Globals.reset_globals()
	enemy_spawner.remove_enemies()
	enemy_spawner.reset_spawner()
	spawn_player(playerSpawnLocation)
	update_heat_bar(-150)
	lava.get_overlapping_bodies()


func _on_lava_body_entered(body):
	if body == Globals.currentPlayer:
		gameover()
