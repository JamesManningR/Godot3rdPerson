extends Node3D
@export var follow_target: NodePath

var camera_mount: Node3D
var update = false
# Global transforms
var gt_prev: Transform3D
var gt_current: Transform3D

# Called when the node enters the scene tree for the first time.
func _ready():
	top_level = true
	camera_mount = get_node_or_null(follow_target)
	if camera_mount == null:
		camera_mount = get_parent()
	global_transform = camera_mount.global_transform
	
	gt_prev = camera_mount.global_transform
	gt_current = camera_mount.global_transform
	
func update_transform():
	gt_prev = gt_current
	gt_current = camera_mount.global_transform

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if update:
		update_transform()
		update = false
	
	var f = clamp(Engine.get_physics_interpolation_fraction(), 0, 1)
	global_transform = gt_prev.interpolate_with(gt_current, f)
	
func _physics_process(_delta):
	update = true
