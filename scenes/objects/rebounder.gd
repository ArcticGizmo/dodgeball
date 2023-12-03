extends Node2D

@export var player: CharacterBody2D
@export var return_bonus_speed_factor: float = 1.01
@export var throw_speed: int = 1500

signal create_ball(position: Vector2, velocity: Vector2, times_thrown: int)

var ball_held: bool = true
var ball_caught_speed: float
var ball_throw_factor: int = 1

func _ready():
	$HeldItemSprite.visible = ball_held

func _physics_process(delta):
	if (player):
		look_at(player.global_position)

func _on_catch_area_body_entered(ball):
	print("apples")
	if !(ball is Ball):
		return
		
	ball_caught_speed = ball.linear_velocity.length()
	ball_throw_factor = ball.throw_factor + 1
	ball.queue_free()
	ball_held = true
	$HeldItemSprite.visible = true
	
	# start bonus speed timer
	$RethrowTimer.start()
	$HeldItemSprite.self_modulate = Color(255, 0, 0, 1)
	create_tween().tween_property($HeldItemSprite, "self_modulate:a", 0.5, 1)

func _on_rethrow_timer_timeout():
	var ball_speed = max(ball_caught_speed, throw_speed) * return_bonus_speed_factor
	
	var vel = Vector2.from_angle(rotation) * ball_speed
	
	create_ball.emit($ThrowFromMarker.global_position, vel, ball_throw_factor)
	
	ball_held = false
	ball_throw_factor = 1
	$HeldItemSprite.visible = false
	
	
	
