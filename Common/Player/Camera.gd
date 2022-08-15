extends SpringArm3D

var look_sensitivity_x := .4
var look_sensitivity_y := .75

var camera_zoom_weight := 1.0

const MAX_CAMERA_ZOOM := 2.0
const MIN_CAMERA_ZOOM := .2
const CAMERA_ZOOM_SENSITIVITY := .1
const CAMERA_ZOOM_STEP: float = CAMERA_ZOOM_SENSITIVITY * 1

const MIN_ANGLE := -80.0
const MAX_ANGLE := 70.0

const MIN_ANGLE_RAD = deg2rad(MIN_ANGLE)
const MAX_ANGLE_RAD = deg2rad(MAX_ANGLE)

var mouse_delta := Vector2()

@onready var player: CharacterBody3D = get_parent()
@onready var camera: Camera3D = $Camera3D
@onready var initial_spring_length := spring_length
@onready var initial_camera_pos := camera.position
@onready var min_spring_length: float = initial_spring_length * MIN_CAMERA_ZOOM
@onready var max_spring_length: float = initial_spring_length * MAX_CAMERA_ZOOM

func set_zoom_weight(weight: float):
	camera_zoom_weight = clamp(weight, MIN_CAMERA_ZOOM, MAX_CAMERA_ZOOM)

func update_camera_position():
	var camera_zoom_pos := position.lerp(initial_camera_pos, camera_zoom_weight)
	set_length(camera_zoom_pos.z)


func _input(event): 
	if event is InputEventMouseMotion:
		mouse_delta = event.relative
	# print(rad2deg(rotation.x))
	
	elif event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_WHEEL_UP):
			set_zoom_weight(camera_zoom_weight - CAMERA_ZOOM_STEP)
		elif (event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
			set_zoom_weight(camera_zoom_weight + CAMERA_ZOOM_STEP)

func _process(delta):
	# Set the rotation value
	var rot = Vector3(mouse_delta.y, mouse_delta.x, 0) * look_sensitivity_x * delta
	# Rotate Camera arm up and down
	rotation.x = clamp(rotation.x - rot.x, MIN_ANGLE_RAD, MAX_ANGLE_RAD)
	# Rotate player
	player.rotation.y -= rot.y * look_sensitivity_y
	
	update_camera_position()
	
	mouse_delta = Vector2()
