extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var timer = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass;

func update():
	timer = timer + 1;
	if (timer > 1000):
		get_tree().change_scene("res://Scenes/World.tscn")
	print(timer);
