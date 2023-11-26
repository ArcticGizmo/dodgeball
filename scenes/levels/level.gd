extends Node2D

const player_template: PackedScene = preload("res://scenes/player/player.tscn")
const ball_template: PackedScene = preload("res://scenes/projectiles/ball.tscn")

func _on_player_player_death():
	print("Oh no. Player has died")
	$PlayerRespawnTimer.start()


func _on_player_respawn_timer_timeout():
	print("respawning player")
	var player = player_template.instantiate()
	player.global_position = $PlayerRespawnMarker.global_position
	player.connect("create_ball", _on_player_create_ball)
	player.connect("player_death", _on_player_player_death)
	$Players.add_child(player)
	


func _on_player_create_ball(position, velocity, times_thrown = 0):
	print("create ball")
	var ball = ball_template.instantiate()

	ball.global_position = position
	ball.linear_velocity = velocity
	ball.throw_factor = times_thrown
	print(ball.throw_factor)
#	ball.apply_central_impulse(impulse)
	
	$Projectiles.add_child(ball)
	
