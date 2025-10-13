extends CharacterBody2D

@export var speed = 200.0
@export var jump_velocity = -400.0

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_right"):
		velocity.x = speed * delta
	if Input.is_action_just_pressed("ui_left"):
		velocity = -speed * delta
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = jump_velocity
			
