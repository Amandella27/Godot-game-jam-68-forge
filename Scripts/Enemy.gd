extends CharacterBody3D

class_name Enemy

@export var SPEED: int = 2

@onready var animation_player = $lavaslug/AnimationPlayer

var direction: Vector3
var player_to_attack:CharacterBody3D = null

func _ready():
	
	player_to_attack = Globals.currentPlayer

func _physics_process(_delta):

	if !player_to_attack == null:
		direction = global_position.direction_to(Vector3(player_to_attack.global_position.x,0,player_to_attack.global_position.z))
		look_at(Globals.currentPlayer.global_position)
	elif player_to_attack == null:
		if Globals.currentPlayer != null:
			player_to_attack = Globals.currentPlayer
	
	
	velocity = SPEED * direction

	if velocity.x or velocity.z:
		animation_player.play("ArmatureAction")

	move_and_slide()
