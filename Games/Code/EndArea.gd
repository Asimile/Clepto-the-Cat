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
@onready var END_TIMER = $EndTimer
@onready var SOUND_TIMER = $SoundTimer
@onready var HATCH_AUDIO = $HatchAudio

#func start_timer():
	## Wait for 2 seconds
	#await(get_tree().create_timer(2.0))

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	
func _on_body_entered(body):
	body.set_control(false)
	ANIM_SPRITE.play("close")
	SOUND_TIMER.start()
	END_TIMER.start()
	#get_parent().get_parent()._update_scene(NEXT_LEVEL)


func _on_end_timer_timeout():
	get_parent().get_parent()._update_scene()


func _on_sound_timer_timeout():
	HATCH_AUDIO.play()
