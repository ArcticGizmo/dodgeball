extends CharacterBody2D

@export var max_speed: int = 500;
var speed: int = max_speed;

func _process(_delta):
	# Movement
	velocity = Input.get_vector("left", "right", "up", "down") * speed
	move_and_slide()

	# Point towards mouse
	
