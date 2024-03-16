extends CharacterBody2D

const SPEED = 150.0
const ACCELERATION = 800
const FRICTION = 500
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d = $AnimatedSprite2D

func _physics_process(delta):
	apply_gravity(delta)
	handle_jump()
	var input_axis = Input.get_axis("ui_left", "ui_right")
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_jump():
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_VELOCITY
	else:
		if Input.is_action_just_released("ui_accept") and velocity.y < JUMP_VELOCITY / 2 or Input.is_action_just_released("ui_up") and velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 2

func apply_friction(input_axis, delta):
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, SPEED * input_axis, ACCELERATION * delta) 

func handle_acceleration(input_axis, delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
