extends Node3D

const ENEMY = preload("res://Scenes/enemy.tscn")

var spawnPositions: Array
var enemy: Enemy

func _ready():
	spawnPositions = get_children()
	spawn_enemies()
	
func spawn_enemies():
	for positions in spawnPositions:
		enemy = ENEMY.instantiate()
		positions.add_child(enemy)
