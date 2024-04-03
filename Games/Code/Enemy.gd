extends CharacterBody2D

# general enemy code
@export var DEAD = false

# floor enemy
@export var WALK_SPEED = 100.0
var GRAVITY = 30
var JUMP_VELOCITY = -400.0
@export var DIRECTION = 1

@onready var PLAYER = get_parent().get_parent().get_node("Clepto the Cat2")

# This is a ground based enemy from Luke's video. I'm not implementing a flying one right now
# I did watch the flying enemy stuff though

func _physics_process(delta):
	if DEAD == false:
		# floor enemy
		# walk like a koopa
		velocity.x = WALK_SPEED * DIRECTION
		# Add the gravity
		if not is_on_floor():
			velocity.y += GRAVITY
		
		move_and_slide()
		animate()

func animate():
	if velocity.x != 0:
		$AnimatedSprite2D.play("Walk")
	else:
		$AnimatedSprite2D.play("Idle")

func _die():
	DEAD = true
	# Freeze velocity
	velocity = Vector2.ZERO
	
	if $DeathTimer.is_stopped():
		# Start timer to delete self
		$DeathTimer.start()
	
func _on_death_timer_timeout():
	# Delete self
	queue_free()

func _on_enemy_area_body_entered(body):
	if body.is_on_floor() == false and body.velocity.y >= 0:
		_die()
		body.jump()

func _on_hurt_area_body_entered(body):
	body._die()