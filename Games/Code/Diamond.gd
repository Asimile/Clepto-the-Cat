extends Area2D

var amplitude = 20 # Maximum height of the float
var speed = 2
var initial_position = Vector2()
var time_elapsed: float

@onready var ANIM_SPRITE = $DiamondAnimation

func _ready():
	# Store the initial position of the node
	initial_position = position
	ANIM_SPRITE.play()

func _process(delta):
	# Update the time elapsed
	time_elapsed += delta
	
	# Calculate the vertical offset using a sine wave
	var offset = sin(time_elapsed * speed) * amplitude
	
	# Update the position of the node
	position = initial_position + Vector2(0, offset)

func _on_body_entered(body):
	get_parent().get_parent()._update_scene()
