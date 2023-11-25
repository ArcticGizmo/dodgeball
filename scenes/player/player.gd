extends CharacterBody2D

@export var max_speed: int = 500;
var speed: int = max_speed;

func _process(_delta):
	# Movement
	velocity = Input.get_vector("left", "right", "up", "down") * speed
	move_and_slide()

	# Point towards mouse
	look_at(get_global_mouse_position())

	if Input.is_action_just_pressed("secondary"):
		handle_catchable_projectile()
		$CatchArea.get_overlapping_areas()
	
func handle_catchable_projectile():
	# TODO: might want to replace with enter/exit signals later on for performance	
	var bodies = $CatchArea.get_overlapping_bodies()
	# TODO: filter the bodies by class type
	
	if len(bodies) == 0:
		return
		
	var projectile = bodies[0] as RigidBody2D;
	projectile.linear_velocity *= -1
	
