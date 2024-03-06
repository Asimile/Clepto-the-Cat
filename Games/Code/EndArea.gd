extends Area2D

@export var NEXT_LEVEL: String = "Level2"

func _on_body_entered(body):
	get_parent().get_parent()._update_scene(NEXT_LEVEL)
