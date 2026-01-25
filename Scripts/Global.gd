extends Node

# Shared input buffer for shadow replay
var input_buffer: Array = []

var day: int = 1

var movable: bool = true
# How long the shadow delay should be (in seconds)
var buffer_max_time := 1.0

# Convert seconds into frames (e.g. 3s * 60fps = 180 frames)
var buffer_max_frames := int(buffer_max_time * Engine.get_physics_ticks_per_second())

func record_input():
	# Capture current input state as a dictionary
	var input_snapshot := {
		"left": Input.is_action_pressed("move_left"),
		"right": Input.is_action_pressed("move_right"),
		"jump": Input.is_action_pressed("jump")
	}

	# Append snapshot to buffer
	input_buffer.append(input_snapshot)

	# Keep buffer capped at max length (sliding window)
	if input_buffer.size() > buffer_max_frames:
		input_buffer.pop_front()

	# Debug prints
