extends CharacterBody2D

@export var speed := 200.0
@export var gravity := 900.0
@export var min_jump_force := -100.0
@export var max_jump_force := -300.0
@export var max_jump_hold := 0.3

var jump_hold_time := 0.0
var jump_active := false

func _ready() -> void:
	print("Shadow collision_mask:", self.collision_mask)

func _physics_process(delta):
	# Always apply gravity
	velocity.y += gravity * delta

	# Only start replaying once buffer is full
	if Global.input_buffer.size() >= Global.buffer_max_frames:
		var delayed_index: int = Global.input_buffer.size() - Global.buffer_max_frames
		var input: Dictionary = Global.input_buffer[delayed_index]
		apply_input(input, delta)

	move_and_slide()

func apply_input(input: Dictionary, delta: float):
	# Horizontal movement
	velocity.x = 0.0
	if input.get("left", false):
		velocity.x = -speed
	elif input.get("right", false):
		velocity.x = speed

	# Jump logic
	if input.get("jump", false) and is_on_floor() and not jump_active:
		jump_active = true
		jump_hold_time = 0.0

	if jump_active and input.get("jump", false):
		jump_hold_time += delta
		var t: float = clamp(jump_hold_time / max_jump_hold, 0.0, 1.0)
		velocity.y = lerp(min_jump_force, max_jump_force, t)

	if not input.get("jump", false) or jump_hold_time >= max_jump_hold:
		jump_active = false
