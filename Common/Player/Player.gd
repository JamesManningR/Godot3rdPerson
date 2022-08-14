extends CharacterBody3D

const BASE_SPEED = 10.0
const SPRINT_SPEED_MULTIPLIER = 2
const JUMP_VELOCITY = 4.5

@onready var jump_particle := $JumpParticles

var initial_pos = transform.origin

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var jump_count = 0;

func jump():
	velocity.y = JUMP_VELOCITY
	if jump_count > 0:
		jump_particle.restart()
		
	jump_count += 1
	
func respawn():
	transform.origin = initial_pos

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(_delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

func _physics_process(delta):
	# Get speed
	var speed = BASE_SPEED
	if Input.is_action_pressed("action_sprint"):
		speed = BASE_SPEED * SPRINT_SPEED_MULTIPLIER
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		jump_count = 0

	# Handle Jump.
	if Input.is_action_just_pressed("action_jump") and (is_on_floor() or jump_count <= 1):
		jump()
		
	if Input.is_action_just_pressed("action_reset"):
		respawn()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_l", "move_r", "move_fwd", "move_bk")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
