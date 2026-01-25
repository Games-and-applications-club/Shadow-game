extends Area2D

@export var happyEndingDate: int = 20

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Main_Character":
		if Global.day > happyEndingDate:
			get_tree().change_scene_to_file("res://Scenes/bad_ending.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/happy_ending.tscn")
		
