extends CharacterBody3D


@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
@export var mouse_sens = Vector2(1, 1)
@export var look_clamp = 0.45

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


var camera_rot: Vector2 = Vector2.ZERO


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	rotation.y = -camera_rot.x
	camera_rot.y = clamp(camera_rot.y, -PI * look_clamp, PI * look_clamp)
	$Camera3D.rotation.x = -camera_rot.y
	$Camera3D/Label3D.text = "FPS: " + str(Engine.get_frames_per_second())

func _input(event):
	if event is InputEventMouseMotion:
		camera_rot += event.relative / Vector2(1920, 1920) * mouse_sens
