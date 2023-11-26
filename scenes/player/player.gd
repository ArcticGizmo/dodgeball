extends CharacterBody2D

@export var max_speed: int = 500;
@export var return_bonus_speed_factor: float = 1.5
@export var throw_speed: int = 500
var speed: int = max_speed;

const ball_template: PackedScene = preload("res://scenes/projectiles/ball.tscn")
var ball_held: bool = false
var ball_caught_speed: float

func _ready():
	$HeldItemSprite.visible = false

func _process(_delta):
	# Movement
	velocity = Input.get_vector("left", "right", "up", "down") * speed
	move_and_slide()

	# Point towards mouse
	look_at(get_global_mouse_position())

	# Handle catching the ball
	if Input.is_action_just_pressed("secondary"):
		handle_catchable_projectile()
		if !ball_held:
			maybe_pick_up_item()
	
	if Input.is_action_just_pressed("primary") and ball_held:
			throw_ball()
		
	
func handle_catchable_projectile():
	# TODO: might want to replace with enter/exit signals later on for performance	
	var bodies = $CatchArea.get_overlapping_bodies().filter(func(x): return x.is_in_group("catchable"))
	
	if len(bodies) == 0:
		return
		
	print("caught")
		
		
	var projectile = bodies[0] as RigidBody2D;
	ball_caught_speed = projectile.linear_velocity.length()
	projectile.queue_free()
	ball_held = true
	$HeldItemSprite.visible = true
	
	# start bonus speed timer
	$ReturnBonusSpeedTimer.start()
	
	
func throw_ball():
	$HeldItemSprite.visible = false	
	
	var ball = ball_template.instantiate()
	%Projectiles.add_child(ball)
	
	ball.global_position = $ThrowFromMarker.global_position
		
	ball.linear_velocity = get_player_direction_as_vector()
	if ($ReturnBonusSpeedTimer.time_left > 0):
		ball.linear_velocity *= ball_caught_speed * return_bonus_speed_factor
	else:
		ball.linear_velocity *= throw_speed
	
	ball_held = false
	$ReturnBonusSpeedTimer.stop()
	
func maybe_pick_up_item():
	var triggers = $PickupArea.get_overlapping_areas().filter(func(x): return x.is_in_group("pickup-zones"))
	
	if len(triggers) == 0:
		return
		
	print("pickup")
	
	ball_held = true
	$HeldItemSprite.visible = true	
	
	

func get_player_direction_as_vector():
	return (get_global_mouse_position() - position).normalized()
