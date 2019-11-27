extends KinematicBody

onready var camera = $RotationHelper/Camera
onready var rotation_helper = $RotationHelper

var gravity = -30
var max_speed = 1.05
var mouse_sensitivity = 0.002 # radians/pixel
var moving = false;
var starting = false;
var leaps = 0;
var coins = 0;

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
	if Input.is_action_pressed("begin"):
		get_tree().change_scene("res://Scenes/World.tscn")
	if Input.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_pressed("ui_accept"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if (!moving):
			moving = true;
			starting = true;
			leaps = leaps +1;
	input_dir = input_dir.normalized()
	return input_dir

func add_coins():
	coins = coins + 1;
	return true;

func _physics_process(delta):
	var input_dir = Vector3()
	get_input();
	var kb3d = self.move_and_collide(velocity*delta)
	if (kb3d):
		var strid = str(kb3d.collider_id)
		if (strid == "1211"):
			get_slide_collision(0).collider.queue_free();
			coins = coins + 1;
		elif (strid == "1214"):
			get_tree().change_scene("res://Scenes/World2.tscn")
		elif (strid == "1774"):
			get_slide_collision(0).collider.queue_free();
			coins = coins + 1;
		elif (strid == "1920"):
			get_tree().change_scene("res://Scenes/Finish.tscn")
		else:
			moving = false;
			print(strid);
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
		velocity.x = 0
		velocity.z = 0
		velocity.y = 0
		velocity = move_and_slide(velocity, Vector3.UP, true)