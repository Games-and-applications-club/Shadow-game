extends Node2D

@onready var detector = $PressDetector        # Area2D
@onready var top = $Top                       # StaticBody2D

var is_pressed = false
var press_count = 0

var press_depth := 8.0        # maximum distance the top can sink
var press_speed := 12.0       # how fast it moves

var min_y := 0.0              # top position when unpressed
var max_y := 8.0              # top position when fully pressed

func _ready():
	detector.body_entered.connect(_on_body_entered)
	detector.body_exited.connect(_on_body_exited)

func _physics_process(delta):
	# Choose target based on pressed state
	var target_y = max_y if is_pressed else min_y

	# Smooth movement
	top.position.y = lerp(top.position.y, target_y, delta * press_speed)

	# Clamp to ensure it never goes too far
	top.position.y = clamp(top.position.y, min_y, max_y)

func _on_body_entered(body):
	if body.is_in_group("player"):
		press_count += 1
		if press_count == 1:
			is_pressed = true
	print("ENTERED:", body, "   press_count:", press_count)

func _on_body_exited(body):
	if body.is_in_group("player"):
		press_count -= 1
		press_count = max(press_count, 0)
		if press_count == 0:
			is_pressed = false
	print("ENTERED:", body, "   press_count:", press_count)
