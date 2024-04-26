extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Reference to main character sprite
@onready var sprite_2d = $Sprite2D

# Reference to the camera
@onready var camera = get_node("../Camera2D")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	######### ANIMATION ##########
	# If running
	if(velocity.x > 1 || velocity.x < -1):
		sprite_2d.animation = "running"
	else:
		sprite_2d.animation = "idle"
	
	# Falling
	if(velocity.y > 0):
		sprite_2d.animation = "falling"
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		sprite_2d.animation = "jumping"

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	### Facing ###
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
	
	### Camera Following ###
	camera.position.x = lerp(camera.position.x, position.x, 0.1)  # Adjust the camera's X position to follow the character horizontally
	camera.position.y = lerp(camera.position.y, position.y, 0.1)  # Adjust the camera's Y position to follow the character vertically
