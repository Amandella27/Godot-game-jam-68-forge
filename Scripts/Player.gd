extends CharacterBody3D

class_name Player

@onready var camera_pivot = $CameraPivot
@onready var camera_3d = $CameraPivot/Camera3D



var camera_sensitivity = 0.001
var gravity = 9.8
const JUMP_VELOCITY = 4.5
const SPEED = 5.0

func _ready():
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Globals.currentPlayer = self
	
	
func _input(event):
	
	if event.is_action_pressed("action"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
	elif event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera_pivot.rotate_x(-event.relative.y * camera_sensitivity)
		rotate_y(-event.relative.x * camera_sensitivity)

		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-45), deg_to_rad(15))


func _physics_process(delta):
	
		# Add the gravity.
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

	move_and_slide()
