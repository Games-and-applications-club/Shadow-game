extends CharacterBody2D

# Movement tuning
@export var speed: float = 200.0
@export var jump_velocity: float = -400.0
@export var gravity: float = 900.0

# Clone / recording settings
@export var clone_scene: PackedScene = preload("res://Main_Character.tscn")
@export var max_record_time: float = 5.0 # maximum seconds to record when holding F

# Internal state
@export var is_clone: bool = false

var recording: bool = false
var record_timer: float = 0.0
var recorded_frames: Array = []
var clone_instance: Node = null

# Replay state (used only by clones)
var replay_data: Array = []
var replay_index: int = 0
var is_replaying: bool = false

func _ready() -> void:
	# If this node is a clone that shouldn't start its own recording/spawn, make sure flags are clear
	if is_clone:
		recording = false

func _physics_process(delta: float) -> void:
	if is_clone:
		_process_clone(delta)
		return

	# --- Player logic (records input while active) ---
	var dir := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	velocity.x = dir * speed

	var jump_pressed := Input.is_action_just_pressed("ui_up")
	if jump_pressed and is_on_floor():
		velocity.y = jump_velocity

	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

	# Recording is controlled by holding the F key
	# Use the project input action 'record' (mapped to F) to control recording
	var f_down := Input.is_action_pressed("record")
	if f_down and not recording:
		_start_recording()

	if recording:
		# capture this physics frame
		recorded_frames.append({"dir": dir, "jump": jump_pressed})
		record_timer += delta
		# stop recording if we reached max_record_time
		if record_timer >= max_record_time:
			recording = false
			_finish_recording()

	# when F is released, finish recording and spawn the clone
	if not f_down and recording:
		recording = false
		_finish_recording()


func _start_recording() -> void:
	recording = true
	record_timer = 0.0
	recorded_frames.clear()

	print_debug("[testcharacter] started recording")


func _finish_recording() -> void:
	# After recording ends, start the clone replay process: make it visible and give it the recorded frames
	if recorded_frames.size() == 0:
		print_debug("[testcharacter] finished recording but no frames captured")
		return

	# instantiate clone now (spawn on release)
	if not clone_scene:
		print_debug("[testcharacter] no clone_scene assigned")
		return

	clone_instance = clone_scene.instantiate()
	if not clone_instance:
		print_debug("[testcharacter] failed to instantiate clone_scene")
		return

	# mark it as a clone so it won't start recording
	if clone_instance.has_method("set"):
		clone_instance.set("is_clone", true)

	# place clone at player's position with slight offset and add to scene
	clone_instance.global_position = global_position + Vector2(16, 0)
	clone_instance.visible = true
	get_parent().add_child(clone_instance)
	print_debug("[testcharacter] spawned clone at release; frames=%d duration=%.2f" % [recorded_frames.size(), record_timer])

	# start the clone replay by calling its start_replay method if available
	if clone_instance.has_method("start_replay"):
		clone_instance.call("start_replay", recorded_frames)
	else:
		if clone_instance.has_method("set"):
			clone_instance.set("replay_data", recorded_frames.duplicate(true))
			clone_instance.set("is_replaying", true)

	# add a timer to remove the clone after the recorded duration (plus small buffer)
	var replay_time = max(record_timer, 0.1)
	var t := Timer.new()
	t.wait_time = replay_time + 0.1
	t.one_shot = true
	t.autostart = true
	clone_instance.add_child(t)
	t.connect("timeout", Callable(clone_instance, "queue_free"))


func start_replay(data: Array) -> void:
	# Called on clone instances to receive recorded frames and begin playback
	replay_data = data.duplicate(true)
	replay_index = 0
	is_replaying = true


func _process_clone(delta: float) -> void:
	# Clone should follow replay_data frames one per physics tick
	if is_replaying and replay_index < replay_data.size():
		var frame = replay_data[replay_index]
		var dir := 0.0
		if frame.has("dir"):
			dir = frame["dir"]
		var jump_pressed := false
		if frame.has("jump"):
			jump_pressed = frame["jump"]

		velocity.x = dir * speed
		if jump_pressed and is_on_floor():
			velocity.y = jump_velocity

		if not is_on_floor():
			velocity.y += gravity * delta

		replay_index += 1
	else:
		# If not replaying or finished replay, simple gravity to keep clone grounded
		if not is_on_floor():
			velocity.y += gravity * delta

	move_and_slide()
