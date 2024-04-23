extends Node

@onready var CURRENT_LEVEL = $Level1
@onready var CURRENT_LEVEL_NAME: String = "Level1"
@onready var NEXT_LEVEL
@onready var NEXT_LEVEL_NAME: String = "Level2"
@onready var RELOAD
@onready var ADVANCING: bool

# Right now this level loader works well. Doesn't even need a placeholder at the end of the array
var LEVEL_LIST = ["Level1", "Level2", "Level3", "Level4", "Level5", "LevelDiamond", "EndScreen"]
var next_level_counter = 1

@export var ANIM: AnimationPlayer

# Code that runs at the start of the game
func _ready():
	pass
	
# This is code that runs every single frame
func _physics_process(delta):
	if Input.is_action_just_pressed("dev") and CURRENT_LEVEL_NAME != "EndScreen":
		_update_scene()

func _update_scene():
	NEXT_LEVEL_NAME = LEVEL_LIST[LEVEL_LIST.find(CURRENT_LEVEL_NAME) + 1]
	#NEXT_DESTINATION_NAME = LEVEL_LIST[LEVEL_LIST.find(NEXT_DESTINATION_NAME) + 1]
	ADVANCING = true
	ANIM.play("fade_in")

func _restart():
	ADVANCING = false
	ANIM.play("fade_in")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		if ADVANCING == true:
			next_level_counter += 1
			NEXT_LEVEL = load("res://Scenes/" + NEXT_LEVEL_NAME + ".tscn").instantiate()
			NEXT_LEVEL.visible = false
			add_child(NEXT_LEVEL)
			#Deletes current level
			CURRENT_LEVEL.queue_free()
			CURRENT_LEVEL = NEXT_LEVEL
			CURRENT_LEVEL_NAME = NEXT_LEVEL_NAME
			CURRENT_LEVEL.visible = true
			ANIM.play("fade_out")
		else:
			RELOAD = load("res://Scenes/" + CURRENT_LEVEL_NAME + ".tscn").instantiate()
			RELOAD.visible = false
			add_child(RELOAD)
			CURRENT_LEVEL.queue_free()
			CURRENT_LEVEL = RELOAD
			CURRENT_LEVEL.visible = true
			ANIM.play("fade_out")
