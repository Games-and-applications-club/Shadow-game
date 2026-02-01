extends Node2D

@export var mine_door: StaticBody2D

var used := 0
var max := 0

var inside_count := 0
var player_inside := false
var label_node: Label = null

func _ready() -> void:
	if mine_door:
		max = mine_door.max

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "Main_Character" or used >= max:
		return

	inside_count += 1
	player_inside = true

	if label_node == null:
		label_node = body.get_node_or_null("Label")

	if is_instance_valid(label_node):
		label_node.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name != "Main_Character":
		return

	inside_count -= 1

	if inside_count > 0:
		return

	inside_count = 0
	player_inside = false

	if is_instance_valid(label_node):
		label_node.visible = false
	label_node = null


func _process(delta: float) -> void:
	if player_inside and Input.is_action_just_pressed("interact"):
		pulled()

func pulled() -> void:
	if used < max:
		mine_door.drop(used)
		used += 1
		if is_instance_valid(label_node):
			label_node.visible = false
