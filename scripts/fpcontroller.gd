extends CharacterBody3D

class_name FPController

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
# HARDCODED PARAMETERS

# translation
const SPEED = 3.0
const RUN_MULT = 1.75
const JUMP_VELOCITY = 4.5
const ACCEL = 0.1
const FRICTION = 0.3
const AIR_RESISTANCE = 0.05

func _process(delta):
	var movement_speed = SPEED;
	
	# Adjust speed if running
	if Input.is_action_pressed("run"):
		movement_speed = SPEED * RUN_MULT
	
	# Add gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Player is inputting movement controls
	if direction:
		velocity.x = lerp(velocity.x, direction.x * movement_speed, ACCEL)
		velocity.z = lerp(velocity.z, direction.z * movement_speed, ACCEL)
		#anim_player.play("view_bobbing")
		# animation player should be calculated when player actually moves rather than input controls
	else:
		#anim_player.stop()
		if is_on_floor():
			velocity.x = lerp(velocity.x, 0.0, FRICTION)
			velocity.z = lerp(velocity.z, 0.0, FRICTION)
		else:
			velocity.x = lerp(velocity.x, 0.0, AIR_RESISTANCE)
			velocity.z = lerp(velocity.z, 0.0, AIR_RESISTANCE)
			
	move_and_slide()
