extends Node3D

signal spawn_enemy_defeated(heatvalue)

const HANDATTACK = preload("res://Scenes/handattack.tscn")
const LAVASLUG = preload("res://Scenes/lavaslug.tscn")
const LAVA_BAT = preload("res://Scenes/lava_bat.tscn")
const LAVA_HAND = preload("res://Scenes/lava_hand.tscn")

@onready var spawn_timer = $SpawnTimer
@onready var positions = $Positions
@onready var wave_timer = $WaveTimer
@onready var rest_timer = $RestTimer
@onready var check_timer = $CheckTimer
@onready var snail_death = $SoundEffects/SnailDeath
@onready var bat_death = $SoundEffects/BatDeath


@export var spawnerOn: bool = true
@export var waveNumber: int = 1
@export var waveTime: int = 30
@export var restTime: int = 1

var spawnableEnemies: Array = [LAVASLUG,LAVA_BAT,LAVA_HAND]

var currentEnemies: Array
var currentSpawn: Array

var spawnPositions: Array
var enemy: Enemy
var skipSpawn: bool = false
var resting: bool = false
var checking: bool = false

var enemyRandomnessLevel = 2
var spawnRandomnessLevel: float = 5
var spawnTimeMin: float = 7
var spawnTimeMax: float = 7
var spawnTimeDifficultyMod: float = 1

func _ready():
	spawnPositions = positions.get_children()
	Globals.current_wave = waveNumber
	startWave()

func spawn_enemies():
	if !resting and spawnerOn:
		for points in spawnPositions:
			randomizePositions()
			if skipSpawn:
				skipSpawn = false
			elif checkForHand(points):
				pass
			else:
				points.add_child(enemy)
				currentEnemies.append(enemy)
				currentSpawn.append(enemy)

func randomizePositions():

	if waveNumber >= 5:
		enemyRandomnessLevel = randi_range(0,2)
		var randomSpawns = randf_range(1,10)
		if randomSpawns >= spawnRandomnessLevel:
			enemy = spawnableEnemies[enemyRandomnessLevel].instantiate()
			enemy.enemy_defeated.connect(enemy_defeated)
			if enemyRandomnessLevel == 2:
				enemy.hand_attack.connect(hand_attack)
		else:
			skipSpawn = true

	elif waveNumber >= 3:
		enemyRandomnessLevel = randi_range(0,1)
		var randomSpawns = randf_range(1,10)
		if randomSpawns >= spawnRandomnessLevel:
			enemy = spawnableEnemies[enemyRandomnessLevel].instantiate()
			enemy.enemy_defeated.connect(enemy_defeated)
			if enemyRandomnessLevel == 2:
				enemy.hand_attack.connect(hand_attack)
	elif waveNumber >= 1:
		enemyRandomnessLevel = 0
		var randomSpawns = randf_range(1,10)
		if randomSpawns >= spawnRandomnessLevel:
			enemy = spawnableEnemies[enemyRandomnessLevel].instantiate()
			enemy.enemy_defeated.connect(enemy_defeated)
			if enemyRandomnessLevel == 2:
				enemy.hand_attack.connect(hand_attack)

		else:
			skipSpawn = true
	
func enemy_defeated(node,type,heatvalue):
	if type == "LavaSlug":
		snail_death.play()
	if type == "LavaBat":
		bat_death.play()
	spawn_enemy_defeated.emit(heatvalue)
	currentEnemies.erase(node)

func startWave():
	wave_timer.start(waveTime)
	spawn_timer.start(randf_range((spawnTimeMin*spawnTimeDifficultyMod),(spawnTimeMax*spawnTimeDifficultyMod)))
	currentSpawn.clear()
	spawn_enemies()
	checkEmptySpawn()

func _on_wave_timer_timeout():
	waveNumber += 1
	Globals.current_wave = waveNumber
	if currentEnemies.is_empty():
		rest_timer.start(restTime)
		resting = true
	if spawnTimeDifficultyMod > .05:
		spawnTimeDifficultyMod -= .05
	spawnTimeMin = 7 * spawnTimeDifficultyMod
	spawnTimeMax = 7 * spawnTimeDifficultyMod
	spawnTimeMin = clamp(spawnTimeMin, 1, 7)
	spawnTimeMax = clamp(spawnTimeMax, 1, 7)	
	spawn_timer.stop()	
	wave_timer.stop()
	checking = true
	check_timer.start(1)
	
func _on_spawn_timer_timeout():
	currentSpawn.clear()
	spawn_enemies()
	checkEmptySpawn()

func _on_rest_timer_timeout():
	resting = false
	rest_timer.stop()
	startWave()

func reset_spawner():
	waveNumber = 1
	resting = false
	enemyRandomnessLevel = 0
	spawnRandomnessLevel = 5
	spawnTimeMin = 7
	spawnTimeMax = 7
	spawnTimeDifficultyMod = 1
	startWave()
	
func remove_enemies():
	for spawn in currentEnemies:
		if spawn != null:
			spawn.queue_free()

func hand_attack(location):
	print("test")
	var attack = HANDATTACK.instantiate()
	add_child(attack)
	attack.global_position = location
	attack.initialize()

func checkForHand(point):
	for spawn in point.get_children():
		if spawn is LavaHand:
			return true

func checkEmptySpawn():
	while currentSpawn.is_empty():
		spawn_enemies()

func _on_check_timer_timeout():
	if currentEnemies.is_empty():
		check_timer.stop()
		checking = false
		rest_timer.start(restTime)
		resting = true
	else:
		check_timer.start(1)
