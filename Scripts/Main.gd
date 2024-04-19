extends Node3D

const PLAYER = preload("res://Scenes/player.tscn")
const PAUSEMENU = preload("res://Scenes/UI/pausemenu.tscn")
const UPGRADEMENU = preload("res://Scenes/UI/upgrademenu.tscn")

@onready var ui_elements = $UIElements
@onready var hud = $UIElements/HUD
@onready var player_manager = $PlayerManager
@onready var enemy_spawner = $EnemySpawner
@onready var lava = $World/volcanopit/Lava
@onready var ambient_lava = $World/AmbientLava
@onready var background_music = $BackgroundMusic

var paused = null
var upgradeMenu
var playerNearAnvil:bool = false
var playerSpawnLocation = Vector3(-3,0,-7)


func _ready():
	ambient_lava.play()
	background_music.play()
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
		
	elif event.is_action_pressed("use") and playerNearAnvil == true and upgradeMenu == null:
		upgradeMenu = UPGRADEMENU.instantiate()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		ui_elements.add_child(upgradeMenu)
		upgradeMenu.used_heat.connect(update_heat_bar)
		upgradeMenu.menu_not_enough_heat.connect(clear_not_enough_heat_warning)
	elif event.is_action_pressed("use") and playerNearAnvil == true and upgradeMenu != null:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		upgradeMenu.queue_free()

	elif event.is_action_pressed("remove_enemies") and paused == null and !OS.has_feature("web"):
		enemy_spawner.remove_enemies()

func _on_anvil_near_anvil():
	playerNearAnvil = true
	if Globals.input_mode == "Mouse":
		Globals.currentPlayer.interact_popup_e.visible = true
	elif Globals.input_mode == "Controller":
		Globals.currentPlayer.interact_popup_y.visible = true
	
	
func _on_anvil_left_anvil():
	playerNearAnvil = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Globals.currentPlayer.interact_popup_y.visible = false
	Globals.currentPlayer.interact_popup_e.visible = false

	if upgradeMenu != null:
		upgradeMenu.queue_free()

func update_health_bar(new_value):
	hud.update_health(new_value)

func update_armor_bar(new_value):
	hud.update_armor(new_value)
	
func update_heat_bar(adjustment):
	hud.update_heat(adjustment)
	Globals.current_heat = clamp(Globals.current_heat+adjustment, 0, 150)
	Globals.currentPlayer.checkHeatBuffs()
	
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

func _on_ambient_lava_finished():
	ambient_lava.play()

func clear_not_enough_heat_warning():
	await get_tree().create_timer(3).timeout
	var more_heat_needed_tween = create_tween()
	var more_heat_needed_shadow_tween = create_tween()
	more_heat_needed_tween.tween_property(hud.more_heat_needed.label_settings, "font_color", Color(1, 1, 1, 0), 1).set_ease(Tween.EASE_OUT).set_delay(3.0)
	more_heat_needed_shadow_tween.tween_property(hud.more_heat_needed.label_settings, "shadow_color", Color(0, 0, 0, 0), .65).set_ease(Tween.EASE_OUT).set_delay(3.0)
