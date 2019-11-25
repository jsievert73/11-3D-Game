extends KinematicBody

onready var camera = $RotationHelper/Camera
onready var rotation_helper = $RotationHelper

var gravity = -30
var max_speed = 1.05
var mouse_sensitivity = 0.002 # radians/pixel
var moving = false;
var starting = false;

var velocity = Vector3()
var currentFlight = Vector3()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func get_input():
	var input_dir = Vector3()
	# desired move in camera direction
	if Input.is_action_pressed("strafe_left"):
		input_dir += - camera.global_transform.basis.x
	if Input.is_action_pressed("strafe_right"):
		input_dir += camera.global_transform.basis.x
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_pressed("ui_accept"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		moving = true;
		starting = true;
	input_dir = input_dir.normalized()
	return input_dir

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_helper.rotate_x(-event.relative.y * mouse_sensitivity)
		rotate_y(-event.relative.x * mouse_sensitivity)

func _physics_process(delta):
	var input_dir = Vector3()
	get_input();
	var kb2d = self.move_and_collide(velocity*delta)
	if (kb2d):
        moving = false;
	if (moving):
		if (starting):
			input_dir += -camera.global_transform.basis.z
			currentFlight = input_dir;
			starting = false;
		var desired_velocity = currentFlight * max_speed
		currentFlight.x = desired_velocity.x
		currentFlight.z = desired_velocity.z
		currentFlight.y = desired_velocity.y
		velocity = move_and_slide(currentFlight, Vector3.UP, true)
	else:
		var desired_velocity = input_dir * max_speed
		velocity.x = desired_velocity.x
		velocity.z = desired_velocity.z
		velocity.y = desired_velocity.y
		velocity = move_and_slide(velocity, Vector3.UP, true)