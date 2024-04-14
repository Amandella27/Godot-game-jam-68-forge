extends Node3D

const ENEMY = preload("res://Scenes/enemy.tscn")

@onready var spawn_timer = $SpawnTimer

var spawnPositions: Array
var enemy: Enemy
var skipSpawn: bool = false

func _ready():
	spawnPositions = get_children()
	spawn_enemies()
	
func spawn_enemies():
	for positions in spawnPositions:
		randomizePositions()
		if skipSpawn:
			skipSpawn = false
		else:
			positions.add_child(enemy)

func randomizePositions():
	var randomSpawns = randi_range(1,10)
	if randomSpawns >= 7:
		enemy = ENEMY.instantiate()
	else:
		skipSpawn = true

func _on_spawn_timer_timeout():
	spawn_enemies()
