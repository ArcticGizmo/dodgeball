extends CharacterBody2D

@export var max_speed: int = 1000;
@export var return_bonus_speed_factor: float = 1.01
@export var throw_speed: int = 1500

signal player_death
signal create_ball(position: Vector2, velocity: Vector2, times_thrown: int)


var ball_held: bool = true
var ball_caught_speed: float
var ball_throw_factor: int = 1

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
		
	var ball = bodies[0] as Ball;
	ball_caught_speed = ball.linear_velocity.length()
	ball_throw_factor = ball.throw_factor + 1
	ball.queue_free()
	ball_held = true
	$HeldItemSprite.visible = true
	
	# start bonus speed timer
	$ReturnBonusSpeedTimer.start()
	$HeldItemSprite.self_modulate = Color(255, 0, 0, 1)
	create_tween().tween_property($HeldItemSprite, "self_modulate:a", 0.5, 1)
	
	
func throw_ball():
	# if re-throwing, throw even harder
	var ball_speed = max(ball_caught_speed, throw_speed)
	
	if ($ReturnBonusSpeedTimer.time_left > 0):
		ball_speed *= ball_throw_factor * return_bonus_speed_factor
		
	var vel = get_player_direction_as_vector() * ball_speed
	
	create_ball.emit($ThrowFromMarker.global_position, vel, ball_throw_factor)
	
	$ReturnBonusSpeedTimer.stop()
	ball_held = false
	ball_throw_factor = 1
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
	
