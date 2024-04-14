extends Node3D

const ENEMY = preload("res://Scenes/enemy.tscn")

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
		enemy = ENEMY.instantiate()
	else:
		skipSpawn = true

func _on_spawn_timer_timeout():
	spawn_enemies()
