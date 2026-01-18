extends Node2D

@export var rock_scene: PackedScene = preload("res://Scenes/rock.tscn")
@export var mine_door: StaticBody2D

var used = 0
var max = 0
var player_inside= false
var label_node = null

func _ready() -> void:
	if mine_door:
		max = mine_door.max

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Main_Character" && used <max:
		label_node = body.get_node("Label")
		player_inside = true
		label_node.visible = true;

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Main_Character":
		player_inside = false
		label_node.visible = false;
		
func _process(delta):
	if Input.is_action_just_pressed("interact"):
		pulled()
		
func pulled():
	if used<max:
		mine_door.drop(used)
		used += 1
		label_node.visible = false;
