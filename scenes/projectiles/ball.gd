extends RigidBody2D

@export var max_speed: int = 500

func _process(_delta):
	pass
	# limit max speed
#	if linear_velocity.length() > max_speed:
#		linear_velocity = linear_velocity.normalized() * max_speed
