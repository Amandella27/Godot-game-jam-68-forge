extends Node3D

signal spawn_enemy_defeated(heatvalue)

const LAVASLUG = preload("res://Scenes/lavaslug.tscn")
const LAVA_BAT = preload("res://Scenes/lava_bat.tscn")

@onready var spawn_timer = $SpawnTimer
@onready var positions = $Positions
@onready var wave_timer = $WaveTimer
@onready var rest_timer = $RestTimer

@export var spawnerOn: bool = true
@export var waveNumber: int = 1
@export var spawnableEnemies: Array[PackedScene]

var currentEnemies: Array

var spawnPositions: Array
var enemy: Enemy
var skipSpawn: bool = false
var resting: bool = false

var enemyRandomnessLevel = randi_range(0,0)
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
			else:
				points.add_child(enemy)
				currentEnemies.append(enemy)

func randomizePositions():
	if waveNumber >= 1:
		var randomSpawns = randf_range(1,10)
		if randomSpawns >= spawnRandomnessLevel:
			enemy = spawnableEnemies[enemyRandomnessLevel].instantiate()
			enemy.enemy_defeated.connect(enemy_defeated)
		else:
			skipSpawn = true
	if waveNumber >= 4:
		enemyRandomnessLevel = randi_range(0,1)
		var randomSpawns = randf_range(1,10)
		if randomSpawns >= spawnRandomnessLevel:
			enemy = spawnableEnemies[enemyRandomnessLevel].instantiate()
			enemy.enemy_defeated.connect(enemy_defeated)
		else:
			skipSpawn = true
	
func enemy_defeated(heatvalue):
	spawn_enemy_defeated.emit(heatvalue)

func startWave():
	print("Spawn Min: ", spawnTimeMin)
	print("Spawn Max: ", spawnTimeMax)
	print(spawnTimeDifficultyMod)
	wave_timer.start(10)
	spawn_timer.start(randf_range((spawnTimeMin*spawnTimeDifficultyMod),(spawnTimeMax*spawnTimeDifficultyMod)))
	spawn_enemies()

func _on_wave_timer_timeout():
	waveNumber += 1
	Globals.current_wave = waveNumber
	if spawnTimeDifficultyMod > .05:
		spawnTimeDifficultyMod -= .05
	spawnTimeMin = 7 * spawnTimeDifficultyMod
	spawnTimeMax = 7 * spawnTimeDifficultyMod
	spawnTimeMin = clamp(spawnTimeMin, 1, 7)
	spawnTimeMax = clamp(spawnTimeMax, 1, 7)
	spawn_timer.stop()
	wave_timer.stop()
	resting = true
	rest_timer.start(5)
	
	
func _on_spawn_timer_timeout():
	spawn_enemies()

func _on_rest_timer_timeout():
	resting = false
	rest_timer.stop()
	startWave()

func reset_spawner():
	waveNumber = 1
	resting = false
	enemyRandomnessLevel = randi_range(0,0)
	spawnRandomnessLevel = 5
	spawnTimeMin = 7
	spawnTimeMax = 7
	spawnTimeDifficultyMod = 1
	startWave()
	
func remove_enemies():
	for spawn in currentEnemies:
		if spawn != null:
			spawn.queue_free()
