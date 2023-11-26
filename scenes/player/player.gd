extends CharacterBody2D

@export var max_speed: int = 500;
@export var return_bonus_speed_factor: float = 1.5
var speed: int = max_speed;

const ballTemplate: PackedScene = preload("res://scenes/projectiles/ball.tscn")
var ballHeld: bool = false
var ballParent: Node
var ballCaughtSpeed: float

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
	
	if Input.is_action_just_pressed("primary") and ballHeld:
		throw_ball()
		
	
func handle_catchable_projectile():
	# TODO: might want to replace with enter/exit signals later on for performance	
	var bodies = $CatchArea.get_overlapping_bodies()
	# TODO: filter the bodies by class type
	
	if len(bodies) == 0:
		return
		
	print("caught")
		
		
	var projectile = bodies[0] as RigidBody2D;
	ballCaughtSpeed = projectile.linear_velocity.length()
	ballParent = projectile.get_parent()
	projectile.queue_free()
	ballHeld = true
	$HeldItemSprite.visible = true
	
	# start bonus speed timer
	$ReturnBonusSpeedTimer.start()
	
	
func throw_ball():
	$HeldItemSprite.visible = false	
	
	var ball = ballTemplate.instantiate()
	ballParent.add_child(ball)
	
	ball.global_position = $ThrowFromMarker.global_position
		
	ball.linear_velocity = get_player_direction_as_vector() * ballCaughtSpeed
	if ($ReturnBonusSpeedTimer.time_left > 0):
		ball.linear_velocity *= return_bonus_speed_factor
	
	ballHeld = false
	ballParent = null
	

func get_player_direction_as_vector():
	return (get_global_mouse_position() - position).normalized()
