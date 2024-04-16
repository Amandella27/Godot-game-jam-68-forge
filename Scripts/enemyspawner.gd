extends Node3D

signal spawn_enemy_defeated(heatvalue)

const LAVASLUG = preload("res://Scenes/lavaslug.tscn")

@onready var spawn_timer = $SpawnTimer
@onready var positions = $Positions

@export var spawnerOn: bool = true

var spawnPositions: Array
var enemy: Enemy
var skipSpawn: bool = false

func _ready():
	if spawnerOn:
		spawnPositions = positions.get_children()
		spawn_enemies()
	else:
		pass
	
func spawn_enemies():
	for points in spawnPositions:
		randomizePositions()
		if skipSpawn:
			skipSpawn = false
		else:
			points.add_child(enemy)

func randomizePositions():
	var randomSpawns = randi_range(1,10)
	if randomSpawns >= 7:
		enemy = LAVASLUG.instantiate()
		enemy.enemy_defeated.connect(enemy_defeated)
	else:
		skipSpawn = true

func _on_spawn_timer_timeout():
	spawn_enemies()

func enemy_defeated(heatvalue):
	spawn_enemy_defeated.emit(heatvalue)
