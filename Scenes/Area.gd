extends Area

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Area_body_entered(body):
	print("collision detectd");
	if body.get_name() == "Player":
		if body.add_coins():
			queue_free()
	
