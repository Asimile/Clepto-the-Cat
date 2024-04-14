extends Area2D

#var LEVEL_LIST = ["Level1", "Level2", "Level3", "temp"]
#var next_level_counter = 1
"""
THIS HERE FOR NEXT_LEVEL IS NOT SUSTAINABLE. NEED TO FIX IN scene_controller CODE
probably fixable by just having scene_controller handle what the next level is,
rather than EndArea being responsible to tell it
"""
#@export var NEXT_LEVEL: String = "Level2"

@onready var ANIM_SPRITE = $AnimatedSprite2D
@onready var TIMER = $EndTimer

#func start_timer():
	## Wait for 2 seconds
	#await(get_tree().create_timer(2.0))
	
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	
func _on_body_entered(body):
	ANIM_SPRITE.play("close")
	TIMER.start()
	#get_parent().get_parent()._update_scene(NEXT_LEVEL)


func _on_end_timer_timeout():
	get_parent().get_parent()._update_scene()
