extends CharacterBody3D

class_name Enemy

@export var SPEED: int = 2

@onready var animation_player = $lavaslug/AnimationPlayer

var direction: Vector3
var player_to_attack:CharacterBody3D = null
var gravity = 9.8

func _ready():
	
	player_to_attack = Globals.currentPlayer

func _physics_process(delta):

	if !player_to_attack == null:
		direction = global_position.direction_to(Vector3(player_to_attack.global_position.x,0,player_to_attack.global_position.z))
		look_at(Vector3(player_to_attack.global_position.x,0,player_to_attack.global_position.z))
	elif player_to_attack == null:
		if Globals.currentPlayer != null:
			player_to_attack = Globals.currentPlayer
	
	
	velocity.x = SPEED * direction.x
	velocity.z = SPEED * direction.z

	if not is_on_floor():
		if velocity.y >= 0:
			velocity.y -= gravity * delta
		elif velocity.y < 0:
			velocity.y -= gravity * delta * 2

	if velocity.x or velocity.z:
		animation_player.play("ArmatureAction")

	move_and_slide()
