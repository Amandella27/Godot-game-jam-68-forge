extends CharacterBody3D

class_name Player

@onready var camera_pivot = $CameraPivot
@onready var camera_3d = $CameraPivot/Camera3D

@onready var animation_tree = $dwarf/AnimationTree

@onready var animation_player = $dwarf/AnimationPlayer
@onready var dwarf_model = $dwarf
@onready var interact_popup = %InteractPopup
@onready var weapon = $dwarf/Armature/Skeleton3D/BoneAttachment3D/Weapon

var runBlendParameter

var camera_sensitivity = 0.001
var gravity = 9.8
const JUMP_VELOCITY = 4.5
const SPEED = 5.0

func _ready():

	runBlendParameter = animation_tree["parameters/runblend/blend_amount"]

	Globals.currentPlayer = self
	Globals.currentWeapon = weapon
	
	
func _input(event):
	
	if event.is_action_pressed("action"):
		pass
			
	elif event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera_pivot.rotate_x(-event.relative.y * camera_sensitivity)
		rotate_y(-event.relative.x * camera_sensitivity)

		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-45), deg_to_rad(15))


func _physics_process(delta):
	
	if not is_on_floor():
		if velocity.y >= 0:
			velocity.y -= gravity * delta
		elif velocity.y < 0:
			velocity.y -= gravity * delta * 2
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if velocity.x or velocity.z:
		dwarf_model.look_at(transform.origin + Vector3(velocity.x, 0, velocity.z),Vector3.UP)
		animation_tree["parameters/runblend/blend_amount"] = lerp(animation_tree["parameters/runblend/blend_amount"], 1.0, 0.3)
	else:
		animation_tree["parameters/runblend/blend_amount"] = lerp(animation_tree["parameters/runblend/blend_amount"], 0.0, 0.3)

	move_and_slide()
