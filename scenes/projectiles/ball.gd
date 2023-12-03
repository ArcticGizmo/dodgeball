extends RigidBody2D

class_name Ball

@export var min_damage_speed = 500
@export var frictionless: bool = false;
@export var friction: int = 500;

var throw_factor: int = 0

func _ready():
	self.linear_damp = 0
	if (friction <= 0):
		self.physics_material_override.friction = 0
		self.physics_material_override.bounce = 1

func _physics_process(_delta):
	if (self.linear_velocity.length() < min_damage_speed):
		throw_factor = 1
	
	self.apply_impulse(-self.linear_velocity.normalized() * friction * _delta)
	
