extends Area2D

@onready var LASER_PARTICLES = $LaserParticles

func _on_body_entered(body):
	body._die()
