extends KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	var screen_size = get_viewport().size
	
	if position.x > screen_size.x:
		position.x = 0
		
	pass
