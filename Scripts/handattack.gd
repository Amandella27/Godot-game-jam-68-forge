extends CharacterBody3D

@onready var hurtbox_component = $HurtboxComponent

@export var SPEED: float = 2.5
@export var damage: int
@export var affectedByGravity: bool = true
@onready var time_out_timer = $TimeOutTimer
@onready var collision_shape_3d = $HurtboxComponent/CollisionShape3D

var direction: Vector3
var gravity = 9.8
var player_to_attack:CharacterBody3D = null

func _ready():
	
	player_to_attack = Globals.currentPlayer
	direction = position.direction_to(player_to_attack.global_position)
	hurtbox_component.set_damage(damage)
	print(player_to_attack.global_position)
	velocity.x = SPEED * direction.x
	velocity.z = SPEED * direction.z

func _physics_process(delta):

	#look_at(Vector3(direction))


	
	if affectedByGravity and not is_on_floor():
		if velocity.y >= 0:
			velocity.y -= gravity * delta
		elif velocity.y < 0:
			velocity.y -= gravity * delta

	move_and_slide()

func _on_time_out_timer_timeout():
	queue_free()

func _on_hurtbox_component_area_entered(area):
	if area.is_in_group("Player") and area.has_method("take_damage"):
		self.visible = false
		await get_tree().create_timer(.5).timeout
		queue_free()
