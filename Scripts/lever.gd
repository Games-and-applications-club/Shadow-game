extends Node2D

@export var rock_scene: PackedScene = preload("res://Scenes/rock.tscn")

var used = false
var player_inside= false
var label_node = null

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Main_Character" && used == false:
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
	if used == false:
		var rock = rock_scene.instantiate()
		rock.position = position + Vector2(0, -50)
		get_tree().current_scene.add_child(rock)
		used = true
		label_node.visible = false;
