extends CharacterBody2D

var INPUT_VECTOR = Vector2(0,0)
var GRAVITY = 50
var SPEED = 400
var CLIMB_SPEED = 150
var JUMP_STRENGTH = -1100
var ACCELERATION = 400
var TIRED_FRAMES = 150
var tired = 0
var walljump_ready = false
var crouch_audio_played = false
#Probably a better way to do this
var walljump_array = [false, false, false, false, false, false, false, false, false, false, false, false, false]

@onready var ANIM_SPRITE = $CleptoSprite2D
@onready var ANIM_PLAYER = $AnimationPlayer
@onready var DUST_PARTICLES = $DustParticles
@onready var MEOW_AUDIO = $MeowAudio
@onready var CROUCH_AUDIO = $CrouchAudio
@onready var JUMP_AUDIO = $JumpAudio
@onready var WALLJUMP_AUDIO = $WalljumpAudio
# Problem with WALK_AUDIO?? Check where we try to stop it in _animation when jumping
@onready var WALK_AUDIO = $WalkAudio

var CAN_CONTROL = true
var DEAD = false

# Code that runs at the start of the game
func _ready():
	pass

# This is code that runs every single frame
func _physics_process(delta):
	
	if DEAD == false and CAN_CONTROL == true:
		_animate()
		
		walljump_ready = false
		
		
		#Controls meow
		if Input.is_action_just_pressed("meow"):
			MEOW_AUDIO.play()
			MEOW_AUDIO.pitch_scale = randf_range(.85, 1.2)
		
		# Set x variable of input to right minus left
		INPUT_VECTOR.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		INPUT_VECTOR.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		#PRINT CHECKERS
		#print(velocity.x)
		#print(INPUT_VECTOR.x)
		#print(walljump_array)
		#print(tired)
		
		# Set x velocity to play x input scaled by a speed variable
		if (INPUT_VECTOR.x != 0):
			velocity.x += INPUT_VECTOR.x * ACCELERATION * .05
			if (velocity.x >= SPEED or velocity.x <= -SPEED):
				velocity.x = INPUT_VECTOR.x * SPEED
			#clampf()
		# Make the player decelerate to 0 when nothing pressed
		elif (INPUT_VECTOR.x == 0):
			velocity.x = lerpf(velocity.x,0,0.2)
		
		# Adding gravity to y velocity
		velocity.y += GRAVITY
		
		#Improves aerial movement, mainly allowing player to climb onto something directly above them
		if !is_on_floor() and !is_on_wall():
			if (INPUT_VECTOR.x != 0):
				velocity.x += INPUT_VECTOR.x * ACCELERATION * .02
		
		#Jump
		if Input.is_action_just_pressed("move_up") and is_on_floor():
			if JUMP_AUDIO.playing == false:
				JUMP_AUDIO.play()
			jump()
			
		#Begin wallcling/climbing
		# Tiredness mechanics are currently disabled. Re-enable if sweat sprite is made
		if tired <= TIRED_FRAMES:
			if (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")) and is_on_wall_only():
				walljump_ready = true
				velocity.y = 0
				if INPUT_VECTOR.y != 0:
					#tired += 1
					velocity.y += INPUT_VECTOR.y * CLIMB_SPEED
		
		#Manages the buffer time on whether the player can walljump or not
		walljump_array.pop_front()
		walljump_array.push_back(walljump_ready)
		
		#Walljump mechanic, based on whether they are wallclinging
		if walljump_array.has(true):
			if (Input.is_action_just_pressed("move_up") and !is_on_wall()):
				if WALLJUMP_AUDIO.playing == false:
					WALLJUMP_AUDIO.play()
				#tired = 0
				#tired += 10
				velocity.y = JUMP_STRENGTH + 300
				velocity.x = INPUT_VECTOR.x * (SPEED + 150)
		
		# Move the character according to velocity variable
		move_and_slide()

func _animate():
	if (is_on_floor()):
		tired = 0
		#if (velocity.x <= 10 and velocity.x >= -10):
		#Crouched or idle
		if (INPUT_VECTOR.x == 0):
			WALK_AUDIO.stop()
			DUST_PARTICLES.emitting = false
			if (INPUT_VECTOR.y > 0):
				ANIM_SPRITE.play("crouch")
				# I'll see if I leave crouch sound in
				if CROUCH_AUDIO.playing == false and crouch_audio_played == false:
					CROUCH_AUDIO.play()
					crouch_audio_played = true
			else:
				ANIM_SPRITE.play("idle")
				crouch_audio_played = false
		#Walking
		else: 
			crouch_audio_played = true
			ANIM_SPRITE.play("walk")
			
			if WALK_AUDIO.playing == false:
				WALK_AUDIO.play()
			DUST_PARTICLES.emitting = true
			DUST_PARTICLES.direction.x = -INPUT_VECTOR.x
			if INPUT_VECTOR.x > 0:
				ANIM_SPRITE.flip_h = false
			else:
				ANIM_SPRITE.flip_h = true
	#Jumping/Falling
	elif !is_on_floor() and !is_on_wall():
		# BIG PROBLEM. IDK WHATS GOING ON HERE, OUT OF SCOPE SOMEHOW????
		if WALK_AUDIO != null:
			WALK_AUDIO.stop()
		if velocity.y <= 0:
			ANIM_SPRITE.play("jump")
		else:
			ANIM_SPRITE.play("fall")
		if INPUT_VECTOR.x > 0:
				ANIM_SPRITE.flip_h = false
		elif (INPUT_VECTOR.x < 0):
			ANIM_SPRITE.flip_h = true
		DUST_PARTICLES.emitting = false
	#Wallclimbing
	elif tired <= TIRED_FRAMES:
		WALK_AUDIO.stop()
		if (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")) and is_on_wall_only():
			ANIM_SPRITE.play("climb")
			if INPUT_VECTOR.y == 0:
				ANIM_SPRITE.pause()
			if INPUT_VECTOR.x > 0:
				ANIM_SPRITE.flip_h = false
			elif (INPUT_VECTOR.x < 0):
				ANIM_SPRITE.flip_h = true
			DUST_PARTICLES.emitting = false

func jump():
	velocity.y = JUMP_STRENGTH
	ANIM_PLAYER.seek(0)
	ANIM_PLAYER.play("jumpSquish")

func _die():
	DEAD = true
	ANIM_SPRITE.play("crouch")
	get_parent().get_parent()._restart()

func set_control(can_control: bool):
	CAN_CONTROL = can_control
