extends CharacterBody3D

class_name Enemy

@export var SPEED: int = 2

var direction: Vector3
var player_to_attack:CharacterBody3D = null

func _ready():
	
	player_to_attack = Globals.currentPlayer

func _physics_process(_delta):

	direction = global_position.direction_to(Vector3(player_to_attack.global_position.x,0,player_to_attack.global_position.z))
	
	velocity = SPEED * direction

	move_and_slide()
