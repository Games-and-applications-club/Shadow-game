extends Node2D

@export var rock_scene: PackedScene = preload("res://Scenes/rock.tscn")

var used = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Main_Character":
		print("Yes")
		pulled()
		
func pulled():
	if used == false:
		var rock = rock_scene.instantiate()
		rock.position = position + Vector2(0, -50)
		get_tree().current_scene.add_child(rock)
		used = true
