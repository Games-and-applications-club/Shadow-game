extends Node2D

@onready var plank: StaticBody2D = $Plank
@onready var left_zone: Area2D = $Plank/LeftZone
@onready var right_zone: Area2D = $Plank/RightZone

var left_weight: float = 0.0
var right_weight: float = 0.0

var max_angle: float = 20.0
var torque_strength: float = 30.0     # how strong weight affects rotation
var damping: float = 4.0              # slows motion so it doesn’t wobble forever

var angular_velocity: float = 0.0     # rotation speed

func _ready() -> void:
	left_zone.body_entered.connect(_on_left_enter)
	left_zone.body_exited.connect(_on_left_exit)
	right_zone.body_entered.connect(_on_right_enter)
	right_zone.body_exited.connect(_on_right_exit)

func _physics_process(delta: float) -> void:
	# Weight difference creates torque
	var diff: float = right_weight - left_weight
	var torque: float = diff * torque_strength

	# Apply torque to angular velocity
	angular_velocity += torque * delta

	# Apply damping (friction)
	angular_velocity = lerp(angular_velocity, 0.0, damping * delta)

	# Apply rotation
	plank.rotation_degrees += angular_velocity * delta

	# Clamp rotation so it never flips over
	plank.rotation_degrees = clamp(plank.rotation_degrees, -max_angle, max_angle)

func _on_left_enter(body: Node) -> void:
	left_weight += get_weight(body)

func _on_left_exit(body: Node) -> void:
	left_weight -= get_weight(body)

func _on_right_enter(body: Node) -> void:
	right_weight += get_weight(body)

func _on_right_exit(body: Node) -> void:
	right_weight -= get_weight(body)

func get_weight(body: Node) -> float:
	if body.is_in_group("player"):
		return 4.0
	if body.is_in_group("shadow"):
		return 1.0
	if body.is_in_group("box"):
		return 3.0
	return 0.0
