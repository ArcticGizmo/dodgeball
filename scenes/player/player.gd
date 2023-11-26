extends CharacterBody2D

@export var max_speed: int = 1000;
@export var return_bonus_speed_factor: float = 3
@export var throw_speed: int = 1500

signal player_death
signal create_ball(position: Vector2, velocity: Vector2)


var ball_held: bool = true
var ball_caught_speed: float

func _ready():
	$HeldItemSprite.visible = ball_held
	look_at(get_global_mouse_position())

func _physics_process(_delta):
	# Movement
	velocity = Input.get_vector("left", "right", "up", "down") * max_speed
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
		
	var projectile = bodies[0] as RigidBody2D;
	ball_caught_speed = projectile.linear_velocity.length()
	projectile.queue_free()
	ball_held = true
	$HeldItemSprite.visible = true
	
	# start bonus speed timer
	$ReturnBonusSpeedTimer.start()
	$HeldItemSprite.self_modulate = Color(255, 0, 0, 1)
	create_tween().tween_property($HeldItemSprite, "self_modulate:a", 0.5, 1)
	
	
func throw_ball():
	var pos = $ThrowFromMarker.global_position

	var vel = get_player_direction_as_vector()
	if ($ReturnBonusSpeedTimer.time_left > 0):
		var speed = ball_caught_speed * return_bonus_speed_factor
		if (speed < throw_speed):
			speed = throw_speed
		vel *= throw_speed
	else:
		vel *= throw_speed
	
	create_ball.emit(pos, vel)
	$ReturnBonusSpeedTimer.stop()
	ball_held = false
	$HeldItemSprite.visible = false
	

	
func maybe_pick_up_item():
	var triggers = $PickupArea.get_overlapping_areas().filter(func(x): return x.is_in_group("pickup-zones"))
	
	if len(triggers) == 0:
		return
		
	ball_held = true
	$HeldItemSprite.visible = true

func get_player_direction_as_vector() -> Vector2:
	return (get_global_mouse_position() - position).normalized()


func _on_body_hit_area_body_entered(body):
	pass
#	body.queue_free()
#	self.queue_free()
#	player_death.emit()
	
