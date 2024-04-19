extends CharacterBody3D

class_name Enemy

signal enemy_defeated(type,heatvalue)

@onready var hurtbox_component = $HurtboxComponent

@export var SPEED: int = 2
@export var damage: int
@export var heatvalue: int
@export var affectedByGravity: bool = true


@export var animation_player: Node

var direction: Vector3
var player_to_attack:CharacterBody3D = null
var gravity = 9.8



func _ready():
	player_to_attack = Globals.currentPlayer
	hurtbox_component.set_damage(damage)
	
func _physics_process(delta):
	
	if !player_to_attack == null:
		direction = global_position.direction_to(Vector3(player_to_attack.global_position.x,0,player_to_attack.global_position.z))
		look_at(Vector3(player_to_attack.global_position.x,0,player_to_attack.global_position.z))
	elif player_to_attack == null:
		if Globals.currentPlayer != null:
			player_to_attack = Globals.currentPlayer
	
	
	velocity.x = SPEED * direction.x
	velocity.z = SPEED * direction.z
	
	if affectedByGravity and not is_on_floor():
		if velocity.y >= 0:
			velocity.y -= gravity * delta
		elif velocity.y < 0:
			velocity.y -= gravity * delta * 2

	if velocity.x or velocity.z:
		playAnimation(animation_player)

	move_and_slide()

func _on_health_component_defeated():
	enemy_defeated.emit(self.name,heatvalue)

func playAnimation(_animationPlayer: AnimationPlayer):
	pass
